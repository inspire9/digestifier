class Digestifier::Digest
  attr_accessor :contents, :default_frequency

  def initialize
    @default_frequency = 24.hours
  end

  def recipients
    User.order(:id)
  end
end
