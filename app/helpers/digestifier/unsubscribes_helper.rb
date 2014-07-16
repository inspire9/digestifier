module Digestifier::UnsubscribesHelper
  def unsubscribe_path_for(user, digest = :digest)
    setting = Digestifier::Setting.for(user, digest)
    digestifier.unsubscribe_path(setting.identifier)
  end

  def unsubscribe_url_for(user, digest = :digest)
    setting = Digestifier::Setting.for(user, digest)
    digestifier.unsubscribe_url(setting.identifier)
  end
end
