class Digestifier::Digest
  attr_accessor :contents

  def recipients
    User.order(:id)
  end
end
