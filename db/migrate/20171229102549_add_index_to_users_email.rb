class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  # $ $ rails generate migration add_index_to_users_email
  def change
    add_index :users, :email, unique: true
  end
end
