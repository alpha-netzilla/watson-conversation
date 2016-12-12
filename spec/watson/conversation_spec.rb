require "spec_helper"

manage = Watson::Conversation::ManageDialog.new(
  username: [username],
  password: [password],
  workspace_id: [workspace_id]
)


describe "Version" do
  it "has a version number" do
    expect(Watson::Conversation::VERSION).not_to be nil
  end
end


describe "Talk" do
	let(:user) {"user1"}
	it "responds a greet message" do
		expect(manage.talk(user, "")).to match (/piyo/)
	end

	it "responds to a user's input" do
		expect(manage.talk(user, "料金案内")).to match (/fuga/)
	end
end



describe "User manage" do
	let(:user) {"user1"}
	it "checkes if the the user exists" do
		expect(manage.has_user?(user)).to match (/#{user} exists/)
	end

	it "deletes the user" do
		expect(manage.delete_user(user)).to match (/#{user} was deleted/)
	end
end


