class AddDigestToReceipts < ActiveRecord::Migration
  def up
    add_column :digestifier_receipts, :digest, :string
    execute "UPDATE digestifier_receipts SET digest = 'digest'"

    change_column :digestifier_receipts, :digest, :string, null: false
    add_index :digestifier_receipts, :digest

    remove_index :digestifier_receipts, [:recipient_type, :recipient_id]
    add_index :digestifier_receipts, [:recipient_type, :recipient_id, :digest],
      name: 'unique_digest_receipts', unique: true
  end

  def down
    remove_index :digestifier_receipts, name: 'unique_digest_receipts'
    remove_column :digestifier_receipts, :digest

    add_index :digestifier_receipts, [:recipient_type, :recipient_id],
      unique: true
  end
end
