require 'spec_helper'

describe 'Delivering digests' do
  let(:digest) { Digestifier::Digest.new }
  let(:user)   { User.create! email: 'me@somewhere.com' }

  before :each do
    ActionMailer::Base.deliveries.clear

    digest.contents = lambda { Article }
  end

  it 'respects receipient frequency preferences' do
    Article.create! name: 'Recent Post'
    Article.create!(name: 'Old Post').
      update_attribute :created_at, 13.hours.ago

    setting = Digestifier::Setting.for(user)
    setting.preferences['frequency'] = 12.hours.to_i
    setting.save

    Digestifier::Delivery.deliver digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Post/)
    expect(mail.body).to_not match(/Old Post/)
  end
end
