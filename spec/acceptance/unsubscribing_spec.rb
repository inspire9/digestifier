require 'spec_helper'

RSpec.describe 'Unsubscribing', type: :request do
  let(:user) { User.create! email: 'me@somewhere.com' }

  it "marks a user as unsubscribed" do
    setting = Digestifier::Setting.for(user)
    expect(setting.enabled).to eq(true)

    get "/digests/unsubscribe/#{setting.identifier}"

    setting.reload
    expect(setting.enabled).to eq(false)
  end
end
