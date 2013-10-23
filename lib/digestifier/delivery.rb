class Digestifier::Delivery
  def self.deliver(digest)
    digest.recipients.call.find_each do |recipient|
      new(digest, recipient).deliver_and_capture
    end
  end

  def initialize(digest, recipient)
    @digest, @recipient = digest, recipient
  end

  def capture
    Digestifier::Receipt.capture recipient
  end

  def deliver
    return unless settings.enabled?

    Digestifier.mailer.digest(recipient, contents).deliver
  end

  def deliver_and_capture
    deliver
    capture
  end

  private

  attr_reader :digest, :recipient

  delegate :default_frequency, to: :digest

  def contents
    digest.contents.call(last_sent..Time.zone.now)
  end

  def frequency
    return default_frequency unless settings.preferences['frequency']

    settings.preferences['frequency']
  end

  def last_sent
    receipt = Digestifier::Receipt.last_for(recipient)
    receipt.nil? ? frequency.ago : receipt.captured_at
  end

  def settings
    @settings ||= Digestifier::Setting.for recipient
  end
end
