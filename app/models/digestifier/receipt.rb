class Digestifier::Receipt < ActiveRecord::Base
  self.table_name = 'digestifier_receipts'

  belongs_to :recipient, polymorphic: true

  def self.capture(recipient)
    create recipient: recipient, captured_at: Time.zone.now
  end

  def self.last_for(recipient)
    where(
      recipient_type: recipient.class.name,
      recipient_id: recipient.id
    ).order('captured_at DESC').first
  end
end
