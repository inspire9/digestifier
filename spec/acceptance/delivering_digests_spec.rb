require 'spec_helper'

describe 'Delivering digests' do
  let(:digest) { Digestifier::Digest.new }
  let(:user)   { User.create! email: 'me@somewhere.com' }

  before :each do
    ActionMailer::Base.deliveries.clear

    digest.contents = lambda { |range|
      Article.where(created_at: range).order(:created_at)
    }

    user
  end

  it 'sends an email of posts within the past day' do
    Article.create! name: 'Recent Post'
    Article.create!(name: 'Old Post').
      update_attribute :created_at, 25.hours.ago

    Digestifier::Delivery.deliver digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Post/)
    expect(mail.body).to_not match(/Old Post/)
  end

  it "allows the digest to have a different frequency" do
    digest.default_frequency = 12.hours

    Article.create! name: 'Recent Post'
    Article.create!(name: 'Old Post').
      update_attribute :created_at, 13.hours.ago

    Digestifier::Delivery.deliver digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Post/)
    expect(mail.body).to_not match(/Old Post/)
  end

  it "does not include already sent items if sending sooner than expected" do
    Article.create!(name: 'Old Post').
      update_attribute :created_at, 13.hours.ago
    Digestifier::Delivery.deliver digest
    ActionMailer::Base.deliveries.clear

    Article.create! name: 'Recent Post'
    Digestifier::Delivery.deliver digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Post/)
    expect(mail.body).to_not match(/Old Post/)
  end
end
