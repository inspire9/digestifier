class Digestifier::Engine < Rails::Engine
  engine_name :digestifier

  config.after_initialize do
    Digestifier.mailer = Digestifier::Mailer
  end
end
