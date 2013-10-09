class Digestifier::Delivery
  def self.deliver(digest)
    new(digest).deliver
  end

  def initialize(digest)
    @digest = digest
  end

  def deliver
    recipients.each do |recipient|
      Digestifier.mailer.digest(recipient, contents).deliver
    end
  end

  private

  attr_reader :digest

  delegate :default_frequency, :recipients, to: :digest

  def contents
    digest.contents.call.where(
      created_at: default_frequency.ago..Time.zone.now
    )
  end
end
