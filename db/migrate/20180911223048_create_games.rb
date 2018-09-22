class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.text :slug
      t.integer :stack
      t.integer :big_blind
      t.integer :small_blind
      t.integer :timer

      t.timestamps
    end
  end
end
