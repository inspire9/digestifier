class AddEnabledToSettings < ActiveRecord::Migration
  def change
    add_column :digestifier_settings, :enabled, :boolean, default: true,
      null: false
    Digestifier::Setting.reset_column_information
  end
end
