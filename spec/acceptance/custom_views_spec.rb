require 'spec_helper'

describe 'Custom digest partials' do
  let(:digest) { Digestifier::Digest.new }
  let(:user)   { User.create! email: 'me@somewhere.com' }

  before :each do
    ActionMailer::Base.deliveries.clear

    digest.contents = lambda { Book }

    user
  end

  it 'respects object-specific partials' do
    Book.create! title: 'Recent Book'

    Digestifier::Delivery.deliver digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Book/)
  end
end
