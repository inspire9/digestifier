require 'spec_helper'

describe 'Unsubscribing' do
  let(:user) { User.create! email: 'me@somewhere.com' }

  it "marks a user as unsubscribed" do
    setting = Digestifier::Setting.for(user)
    expect(setting.enabled).to be_true

    get "/digests/unsubscribe/#{setting.identifier}"

    setting.reload
    expect(setting.enabled).to be_false
  end
end
