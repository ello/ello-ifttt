class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :owner_id
      t.string :action_taken_by_id
      t.string :kind
      t.datetime :created_at
      t.json :payload
    end
    add_index :events, :owner_id
    add_index :events, :action_taken_by_id
    add_index :events, :kind
    add_index :events, :created_at
  end
end
