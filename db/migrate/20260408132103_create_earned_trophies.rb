class CreateEarnedTrophies < ActiveRecord::Migration[8.0]
  def change
    create_table :earned_trophies do |t|
      t.references :game, null: false, foreign_key: true
      t.references :trophy_group, null: false, foreign_key: true
      t.integer :psn_trophy_id, null: false
      t.string :trophy_type
      t.datetime :earned_at
      t.timestamps
    end
  end
end
