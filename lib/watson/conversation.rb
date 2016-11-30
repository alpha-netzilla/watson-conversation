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
		
		
			def talk(conversation_id, context, text)
				if conversation_id == ""
					body = {}.to_json
				else
					body = {
						input: {
							text: text
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
			
				@conversation_id = ""
	
				@context = {
					context: {
						conversation_id: @conversation_id,
					  dialog_stack: [
					   "root"
					  ],
					  dialog_turn_counter: 1,
						dialog_request_counter: 1
					}
				}
			end
		
		
			def talk(text)
				code, body = @cnv.talk(@conversation_id, @context, text)
	
				if code == 200
					@context = body["context"]
					@conversation_id = @context["conversation_id"]
	
					output_texts = Array.new
					body["output"]["text"].each do | output_text |
						output_texts.push(output_text)
					end
	
					return output_texts
				else
					return "#{code} #{body}"
				end
		
			end
		end
		
	end
end
