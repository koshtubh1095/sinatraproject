require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)
disable :run
Encoding.default_external = Encoding::UTF_8

use Rack::ShowExceptions
use Rack::Session::Pool

require File.expand_path '../my_app.rb', __FILE__
run MyApp