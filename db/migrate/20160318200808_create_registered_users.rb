class CreateRegisteredUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :registered_users do |t|
      t.string :user_id

      t.timestamps
    end
    add_index :registered_users, :user_id, unique: true
  end
end
