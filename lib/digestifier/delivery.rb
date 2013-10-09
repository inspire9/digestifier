class Digestifier::Delivery
  def self.deliver(digest)
    digest.recipients.each do |recipient|
      new(digest, recipient).deliver
    end
  end

  def initialize(digest, recipient)
    @digest, @recipient = digest, recipient
  end

  def deliver
    Digestifier.mailer.digest(recipient, contents).deliver
    Digestifier::Receipt.capture recipient
  end

  private

  attr_reader :digest, :recipient

  delegate :default_frequency, to: :digest

  def contents
    digest.contents.call.where(
      created_at: last_sent..Time.zone.now
    )
  end

  def last_sent
    receipt = Digestifier::Receipt.last_for(recipient)
    receipt.nil? ? default_frequency.ago : receipt.captured_at
  end
end
