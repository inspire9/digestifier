class Digestifier::Setting < ActiveRecord::Base
  self.table_name = 'digestifier_settings'

  belongs_to :recipient, polymorphic: true

  serialize :preferences, JSON

  validates :recipient, presence: true

  def self.for(recipient)
    where(
      recipient_type: recipient.class.name,
      recipient_id:   recipient.id
    ).first || create(recipient: recipient)
  end
end
