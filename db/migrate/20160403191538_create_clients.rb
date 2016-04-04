class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :age
      t.string :gender
      t.string :race
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
