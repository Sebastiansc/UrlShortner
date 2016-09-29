class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :url_id, null: false
      t.integer :user_id, null: false
      t.integer :vote, default: 0
      t.timestamps
    end

    add_index :votes, :url_id
    add_index :votes, :user_id
  end
end
