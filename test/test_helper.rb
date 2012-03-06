$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'simple_enum'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'plugin_test'])

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")
