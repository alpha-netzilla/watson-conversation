require "watson/conversation/version"
require 'rest-client'
require "json"
require "thread"
require "redis"



module Watson
	module Conversation

		class Dialog			
			def initialize(username: "", password: "", workspace_id: "")
				url = "https://#{username}:#{password}@gateway.watsonplatform.net/conversation/api"
				version="2016-07-11"
				@endpoint = "#{url}/v1/workspaces/#{workspace_id}/message?version=#{version}"
			end

		
			def talk(question, context)
				future_data = FutureData.new()

				if context == ""
					body = {}.to_json
				else
					body = {
						input: {
							text: question
						},
						alternate_intents: true,
						context: context,
					}.to_json
				end

				Thread.start do
					begin
						response = RestClient.post @endpoint, body, content_type: :json, accept: :json
						code = response.code
						body = JSON.parse(response.body)
					rescue RestClient::ExceptionWithResponse => e
						code = e.response.code
						body = JSON.parse(e.response.body)
					end
					future_data.set_real_data(code, body)
				end
	
				return future_data
			end


			def get_data()
				return code, body
			end
		end


		class FutureData
			def initialize()
				@is_ready = false
				@real_data = nil

				@mutex = Mutex.new
				@cv = ConditionVariable.new
			end


			def set_real_data(code, body)
				@mutex.synchronize do
					if @is_ready == true
						return
					end
				end
				
				@real_data = code, body
				@is_ready = true

				@cv.broadcast
			end


			def get_data()
				@mutex.synchronize do
					while @is_ready == false
						@cv.wait(@mutex)
					end
				end
				return @real_data
			end
		end




		class Redis < ::Redis
			def fetch(user)
				JSON.parse(get(user))
			end


			def store(user, data)
				set(user, data.to_json)
			end


			def delete(user)
				del(user)
			end


			def has_key?(user)
				exists(user) 
			end
		end


	
		class ManageDialog
			def initialize(username: "", password: "", workspace_id: "", storage: "hash")
				@cnv = Dialog.new(
					username: username,
					password: password,
					workspace_id: workspace_id
				)
			
				if storage == "hash"
					@users = Hash.new
				else
					@users = Redis.new(:url => storage)
				end

				@mutex = Mutex.new
			end


			def users()
				@users
			end


			def has_key?(user) 
				@users.has_key?(user)
			end


			def delete(user)
				@users.delete(user)
			end


			def talk(user, question)
				future_data = nil

				@mutex.synchronize do
					if @users.has_key?(user) == false
						future_data = @cnv.talk("", "")
					else
						future_data = @cnv.talk(question, context = @users.fetch(user))
					end
				end

				code, response = future_data.get_data()	

				output_texts = []
				if code == 200
					context = response["context"]
					response["output"]["text"].each do | text |
						output_texts.push(text)
					end
				else
					response["error"]["error"]["input.text"].each do | text |
						output_texts.push(text)
					end
				end

				@mutex.synchronize do
					if code == 200
						@users.store(user, context)
					else
						@users.delete(user)
					end
				end

				return {user: user, status_code: code, output: output_texts}.to_json
			end
		end
	end
end
