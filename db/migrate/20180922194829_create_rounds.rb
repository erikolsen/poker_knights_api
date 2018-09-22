class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.integer :hand_id
      t.integer :sequence
      t.integer :pot
    end
  end
end
