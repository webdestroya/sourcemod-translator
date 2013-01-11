class AddPercentagesToSourcemodPlugin < ActiveRecord::Migration
  def change
    add_column :sourcemod_plugins, :completed, :float
    add_column :sourcemod_plugins, :attempted, :float
  end
end
