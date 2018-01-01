# $ rails generate migration add_picture_to_microposts picture:string

class AddPictureToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :picture, :string
  end
end
