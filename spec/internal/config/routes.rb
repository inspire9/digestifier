Rails.application.routes.draw do
  mount Digestifier::Engine => '/digests'
end
