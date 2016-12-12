require "watson/conversation/version"
require 'rest-client'
require "json"
require "thread"


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
						body = e.response.body
					end
					future_data.setRealData(code, body)
				end
	
				return future_data
			end


			def getData()
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


			def setRealData(code, body)
				@mutex.synchronize do
					if (@is_ready == true)
						return
					end
				end
				
				@real_data = code, body
				@is_ready = true

				@cv.broadcast
			end


			def getData()
				@mutex.synchronize do
					while (@is_ready == false)
						@cv.wait(@mutex)
					end
				end
				return @real_data
			end
		end

				

		class ManageDialog
			def initialize(username: "", password: "", workspace_id: "")
				@mutex = Mutex.new

				@cnv = Dialog.new(
					username: username,
					password: password,
					workspace_id: workspace_id
				)
			
				@users = {}
			end


			def has_user?(user)
				@mutex.synchronize do
					if @users.has_key?(user)
						{code: true, description: "#{user} exists."}.to_json
					else	
						{code: false, description: "#{user} does not exists."}.to_json
					end
				end
			end


			def delete_user(user)
				if @users.has_key?(user)
					@mutex.synchronize do
						@users.delete(user)
					end
					{code: 0, description: "#{user} was deleted."}.to_json
				else
					{code: 1, description: "#{user} does not exist."}.to_json
				end
			end
		
		
			def talk(user, question)
				future_data = nil
				@mutex.synchronize do
					if @users.key?(user) == false
						future_data = @cnv.talk("", "")
					else
						future_data = @cnv.talk(question, context = @users[user])
					end
				end

				code, response = future_data.getData()	

				output_texts = []
				if code == 200
					context = response["context"]
					response["output"]["text"].each do | output_text |
						output_texts.push(output_text)
					end
				end


				@mutex.synchronize do
					if code == 200
						@users[user] = context
					else
						@users.delete(user)
					end
				end

				return {user: user, status_code: code, output: output_texts}.to_json
			end
		end
		
	end
end
