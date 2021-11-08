class RemovePostIdFromTags < ActiveRecord::Migration[6.1]
  def change
    remove_reference :tags, :post, foreign_key: true
  end
end
