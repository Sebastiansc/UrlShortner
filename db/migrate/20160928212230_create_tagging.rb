class CreateTagging < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :tag_id, null: false
      t.integer :url_id, null: false
      t.timestamps
    end

    add_index :taggings, :tag_id
    add_index :taggings, :url_id
  end
end
