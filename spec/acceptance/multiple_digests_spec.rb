require 'spec_helper'

RSpec.describe 'Multiple Digests' do
  let(:food_digest) { Digestifier::Digest.new :food }
  let(:tech_digest) { Digestifier::Digest.new :tech }
  let(:user)   { User.create! email: 'me@somewhere.com' }

  before :each do
    ActionMailer::Base.deliveries.clear

    food_digest.contents = lambda { |user, range|
      Article.category('food').where(created_at: range).order(:created_at)
    }
    tech_digest.contents = lambda { |user, range|
      Article.category('tech').where(created_at: range).order(:created_at)
    }

    user
  end

  it 'sends an email of posts within the past day' do
    Article.create! name: 'Recent Food Post', category: 'food'
    Article.create! name: 'Recent Tech Post', category: 'tech'
    Article.create!(name: 'Old Food Post', category: 'food').
      update_attribute :created_at, 25.hours.ago
    Article.create!(name: 'Old Tech Post', category: 'tech').
      update_attribute :created_at, 25.hours.ago

    Digestifier::Delivery.deliver food_digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Food Post/)
    expect(mail.body).to_not match(/Old Food Post/)
    expect(mail.body).to_not match(/Tech Post/)
    expect(mail.body).to_not match(/Old Tech Post/)
  end

  it 'respects distinct frequency preferences' do
    Article.create! name: 'Recent Food Post', category: 'food'
    Article.create! name: 'Recent Tech Post', category: 'tech'
    Article.create!(name: 'Old Food Post', category: 'food').
      update_attribute :created_at, 13.hours.ago
    Article.create!(name: 'Old Tech Post', category: 'tech').
      update_attribute :created_at, 13.hours.ago

    setting = Digestifier::Setting.for(user, :food)
    setting.preferences['frequency'] = 12.hours.to_i
    setting.save

    setting = Digestifier::Setting.for(user, :tech)
    setting.preferences['frequency'] = 24.hours.to_i
    setting.save

    Digestifier::Delivery.deliver food_digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Food Post/)
    expect(mail.body).to_not match(/Old Food Post/)

    ActionMailer::Base.deliveries.clear
    Digestifier::Delivery.deliver tech_digest

    mail = ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }
    expect(mail.body).to match(/Recent Tech Post/)
    expect(mail.body).to match(/Old Tech Post/)
  end

  it 'respects disabled digest preferences' do
    Article.create! name: 'Recent Food Post', category: 'food'
    Article.create! name: 'Recent Tech Post', category: 'tech'

    setting = Digestifier::Setting.for(user, :food)
    setting.enabled = true
    setting.save!

    setting = Digestifier::Setting.for(user, :tech)
    setting.enabled = false
    setting.save!

    Digestifier::Delivery.deliver food_digest

    expect(ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }).not_to be_nil

    ActionMailer::Base.deliveries.clear

    Digestifier::Delivery.deliver tech_digest

    expect(ActionMailer::Base.deliveries.detect { |mail|
      mail.to.include?('me@somewhere.com')
    }).to be_nil
  end
end
