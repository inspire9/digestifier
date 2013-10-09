class Digestifier::Digest
  attr_accessor :contents, :default_frequency, :recipients

  def initialize
    @default_frequency = 24.hours
    @recipients        = Proc.new { User.order(:id) }
  end
end
