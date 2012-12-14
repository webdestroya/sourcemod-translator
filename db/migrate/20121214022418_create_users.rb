class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :provider,      null: false
      t.string  :uid,           null: false
      t.string  :name,          null: false

      t.string  :time_zone,     null: false, default: 'UTC'


      t.boolean :admin,         null: false, default: false
      t.boolean :moderator,     null: false, default: false
      t.boolean :banned,        null: false, default: false

      t.timestamps
    end
  end
end
