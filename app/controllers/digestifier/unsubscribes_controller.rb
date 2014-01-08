class Digestifier::UnsubscribesController < ApplicationController
  def change
    setting = Digestifier::Setting.find_by_identifier params[:id]
    setting.enabled = false
    setting.save
  end
end
