class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :description
      t.integer :year
      t.string :director
      t.string :actor
      t.string :location
      t.string :country

      t.timestamps
    end
  end
end
