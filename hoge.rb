require './lib/watson/conversation'

manage = Watson::Conversation::ManageDialog.new(
  username: "2dc1e553-7caf-42a6-9566-7b09563973b6",
  password: "scXHOmBTv5Po",
  workspace_id: "3efc86e6-ba1b-425a-a3f1-3dd69d4f2432"
)

p response = manage.talk("Smith", "")
p response = manage.talk("Smith", "料金案内")
p response = manage.talk("Smith", "当月")
p response = manage.talk("Smith", "090-1234-1234")
p response = manage.talk("Smith", "1234")
p response = manage.talk("Smith2", "")
p response = manage.talk("Smith", "はい")
p response = manage.talk("Smith", "はい")
