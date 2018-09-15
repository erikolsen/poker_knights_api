class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :cards
      t.text :position
      t.string :white
      t.string :black

      t.timestamps
    end
  end
end
