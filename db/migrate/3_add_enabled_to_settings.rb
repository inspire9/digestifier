class AddEnabledToSettings < ActiveRecord::Migration
  def change
    add_column :digestifier_settings, :enabled, :boolean, default: true,
      null: false
  end
end
