require "spec_helper"

manage = Watson::Conversation::ManageDialog.new(
  username: [username],
  password: [password],
  workspace_id: [workspace_id]
)

describe Watson::Conversation do
  it "has a version number" do
    expect(Watson::Conversation::VERSION).not_to be nil
  end

	it "is a greet message" do
		expect(manage.talk("")[0]).to match (/piyo/)
	end

	it "is a response to a user's input" do
		expect(manage.talk("foo")[0]).to match (/bar/)
	end
end
