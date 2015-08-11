class AddIdentifierToSettings < ActiveRecord::Migration
  def up
    add_column :digestifier_settings, :identifier, :string
    Digestifier::Setting.reset_column_information

    Digestifier::Setting.find_each do |setting|
      setting.set_identifier!
    end

    change_column :digestifier_settings, :identifier, :string, null: false
    add_index :digestifier_settings, :identifier, unique: true
  end

  def down
    remove_column :digestifier_settings, :identifier
    Digestifier::Setting.reset_column_information
  end
end
