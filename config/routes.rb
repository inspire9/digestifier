Digestifier::Engine.routes.draw do
  get 'unsubscribe/:id', to: 'digestifier/unsubscribes#change',
    as: :unsubscribe
end
