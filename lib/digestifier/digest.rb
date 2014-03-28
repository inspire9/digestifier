class Digestifier::Digest
  attr_accessor :identifier, :contents, :default_frequency, :recipients

  def initialize(identifier = :digest)
    @identifier        = identifier
    @default_frequency = 24.hours
    @recipients        = lambda { User.order(:id) }
  end
end
