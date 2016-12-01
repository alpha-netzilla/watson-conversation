require "watson/conversation/version"
require 'rest-client'
require "json"

	
module Watson
	module Conversation

		class Dialog			
			def initialize(username: "", password: "", workspace_id: "")
				url = "https://#{username}:#{password}@gateway.watsonplatform.net/conversation/api"
				version="2016-07-11"
				
				@endpoint = "#{url}/v1/workspaces/#{workspace_id}/message?version=#{version}"
			end
		
		
			def talk(question, context)
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
				
				begin
					response = RestClient.post @endpoint, body, content_type: :json, accept: :json
					code = response.code
					body = JSON.parse(response.body)
				rescue RestClient::ExceptionWithResponse => e
					code = e.response.code
					body = e.response.body
				end
	
				return code, body
			end
		end
				
				
		class ManageDialog
			def initialize(username: "", password: "", workspace_id: "")
				@cnv = Dialog.new(
					username: username,
					password: password,
					workspace_id: workspace_id
				)
			
				@users = {}
			end
		
		
			def talk(user, question)
				if @users.key?(user) == false
					code, response = @cnv.talk("", "")
				else
					code, response = @cnv.talk(question, context = @users[user])
				end

	
				if code == 200
					context = response["context"]
					@users[user] = context
	
					output_texts = Array.new
					response["output"]["text"].each do | output_text |
						output_texts.push(output_text)
					end
				end

				return "{user: #{user}, status_code: #{code}, output: #{output_texts}}"
			end
		end
		
	end
end
