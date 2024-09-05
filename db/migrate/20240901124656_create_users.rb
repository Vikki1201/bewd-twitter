class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.index :username, unique: true

      t.string :email, null: false
      t.index :email, unique: true

      t.string :password

      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
