class Digestifier::Setting < ActiveRecord::Base
  self.table_name = 'digestifier_settings'

  belongs_to :recipient, polymorphic: true

  serialize :preferences, JSON

  validates :recipient,  presence: true
  validates :identifier, presence: true, uniqueness: true
  validates :digest,     presence: true

  before_validation :set_identifier, on: :create

  def self.for(recipient, digest = :digest)
    where(
      digest:         digest,
      recipient_type: recipient.class.name,
      recipient_id:   recipient.id
    ).first || create(digest: digest, recipient: recipient)
  end

  def set_identifier!
    set_identifier
    save!
  end

  private

  def set_identifier
    self.identifier = SecureRandom.hex(12)

    set_identifier if self.class.where(identifier: identifier).any?
  end
end
