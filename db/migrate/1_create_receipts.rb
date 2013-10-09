class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :digestifier_receipts do |t|
      t.string   :recipient_type, null: false
      t.integer  :recipient_id,   null: false
      t.datetime :captured_at,    null: false
    end

    add_index :digestifier_receipts, [:recipient_type, :recipient_id]
  end
end
