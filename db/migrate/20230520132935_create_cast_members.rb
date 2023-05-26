class CreateCastMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :cast_members do |t|
      t.references :movie, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
