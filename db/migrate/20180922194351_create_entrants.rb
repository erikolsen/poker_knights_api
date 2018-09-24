class CreateEntrants < ActiveRecord::Migration[5.2]
  def change
    create_table :entrants do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :sequence
      t.integer :stack
    end
  end
end
