module Digestifier::UnsubscribesHelper
  def unsubscribe_path_for(user)
    setting = Digestifier::Setting.for(user)
    digestifier.unsubscribe_path(setting.identifier)
  end

  def unsubscribe_url_for(user)
    setting = Digestifier::Setting.for(user)
    digestifier.unsubscribe_url(setting.identifier)
  end
end
