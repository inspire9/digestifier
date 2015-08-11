class AddDigestToSettings < ActiveRecord::Migration
  def up
    add_column :digestifier_settings, :digest, :string
    execute "UPDATE digestifier_settings SET digest = 'digest'"
    Digestifier::Setting.reset_column_information

    change_column :digestifier_settings, :digest, :string, null: false
    add_index :digestifier_settings, :digest

    remove_index :digestifier_settings, [:recipient_type, :recipient_id]
    add_index :digestifier_settings, [:recipient_type, :recipient_id, :digest],
      name: 'unique_recipients', unique: true
  end

  def down
    remove_index :digestifier_settings, name: 'unique_recipients'
    remove_column :digestifier_settings, :digest
    Digestifier::Setting.reset_column_information

    add_index :digestifier_settings, [:recipient_type, :recipient_id],
      unique: true
  end
end
