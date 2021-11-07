class AddTagsToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :tags, :integer, array:true, default:[]
  end
end
