class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :position
      t.string :white
      t.string :black

      t.timestamps
    end
  end
end
