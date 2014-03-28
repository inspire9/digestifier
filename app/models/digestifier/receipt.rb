class Digestifier::Receipt < ActiveRecord::Base
  self.table_name = 'digestifier_receipts'

  belongs_to :recipient, polymorphic: true

  validates :recipient,   presence: true
  validates :captured_at, presence: true
  validates :digest,      presence: true

  def self.capture(recipient, digest)
    receipt = last_for recipient, digest

    if receipt.nil?
      create recipient: recipient, captured_at: Time.zone.now, digest: digest
    else
      receipt.update_attributes captured_at: Time.zone.now
    end
  end

  def self.last_for(recipient, digest)
    where(
      digest:         digest,
      recipient_type: recipient.class.name,
      recipient_id:   recipient.id
    ).order('captured_at DESC').first
  end
end
