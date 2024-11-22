class RemoveIndexFromUsersEmail < ActiveRecord::Migration[8.0]
  def change
    remove_index :users, name: "index_users_on_email"
  end
end
