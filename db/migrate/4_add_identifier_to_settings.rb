class AddIdentifierToSettings < ActiveRecord::Migration
  def up
    add_column :digestifier_settings, :identifier, :string

    Digestifier::Setting.find_each do |setting|
      setting.set_identifier!
    end

    change_column :digestifier_settings, :identifier, :string, null: false
    add_index :digestifier_settings, :identifier, unique: true
  end
end
