class CreateRolesPermissions < ActiveRecord::Migration[7.2]
  def change
    create_table :roles_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.string :constraints

      t.timestamps
    end
  end
end
