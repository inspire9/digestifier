require 'rubygems'
require 'bundler'

Bundler.require :default, :development

Combustion.initialize! :action_controller, :active_record, :action_mailer
run Combustion::Application
