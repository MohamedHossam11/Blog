class AddTagsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :tags, :post, null: false, foreign_key: true
  end
end
