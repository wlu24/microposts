class AddRememberDigestToUsers < ActiveRecord::Migration[5.1]
  # $ rails generate migration add_remember_digest_to_users remember_digest:string
  def change
    add_column :users, :remember_digest, :string
  end
end
