module Digestifier
  mattr_accessor :mailer, :sender
end

require 'digestifier/delivery'
require 'digestifier/digest'
require 'digestifier/engine'
