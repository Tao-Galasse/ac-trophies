class CreateTrophyGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :trophy_groups do |t|
      t.references :game, null: false, foreign_key: true
      t.string :psn_group_id, null: false
      t.string :name, null: false
      t.date :release_date, null: false
      t.integer :total_count, null: false, default: 0
      t.timestamps
    end
  end
end
