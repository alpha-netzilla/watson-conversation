require "spec_helper"
=begin
manage = Watson::Conversation::ManageDialog.new(
  username: [username],
  password: [password],
  workspace_id: [workspace_id]
)
=end


describe "Version" do
  it "has a version number" do
    expect(Watson::Conversation::VERSION).not_to be nil
  end
end



shared_examples_for "conversation" do |storage|
	manage = Watson::Conversation::ManageDialog.new(
		username: [username],
		password: [password],
		workspace_id: [workspace_id],
		storage: storage
	)


	describe "#talk" do
		let(:user) {"user1"}
		it "responds a greet message" do
			expect(manage.talk(user, "")).to match(/status_code/)
		end

		it "responds to a user's input" do
			expect(manage.talk(user, "bar")).to match(/status_code/)
		end
	end


	describe "has_key?" do
		let(:user1) {"user1"}
		let(:user2) {"user2"}
		it "checkes if the the user exists" do
			expect(manage.users.has_key?(user1)).to eq true
		end

		it "checkes if the the user doesnot exist" do
			expect(manage.users.has_key?(user2)).to eq false
		end
	end


	describe "delete" do
		let(:user1) {"user1"}
		let(:user2) {"user2"}
		it "checkes if the the user exists" do
			expect(manage.users.delete(user1)).to include(a_string_starting_with("conversation")).or eq(1)
		end

		it "checkes if the the user doesnot exist" do
			expect(manage.users.delete(user2)).to eq(nil).or eq(0)
		end
	end
end



describe "Hash" do
	it_behaves_like "conversation", "hash"
end


describe "Redis" do 
	it_behaves_like "conversation", "redis://127.0.0.1:6379"
end



