class CreateHands < ActiveRecord::Migration[5.2]
  def change
    create_table :hands do |t|
      t.string :cards
      t.text :position
      t.string :white
      t.string :black
      t.integer :sequence
      t.integer :game_id

      t.timestamps
    end
  end
end
