class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
