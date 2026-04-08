class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :psn_communication_id, null: false
      t.string :name, null: false
      t.string :platform, null: false
      t.date :release_date, null: false
      t.timestamps
    end

    add_index :games, :psn_communication_id, unique: true
  end
end
