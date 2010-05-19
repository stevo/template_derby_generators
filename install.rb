RAILS_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..') unless defined?(RAILS_ROOT)


	def gsub_file(file, regexp, *args, &block)
	path = "#{RAILS_ROOT}/#{file}"
	content = File.read(path).gsub(regexp, *args, &block)
	File.open(path, 'wb') { |file| file.write(content) } unless File.read(path) =~ /map.lbuilder/
    end


#kopiowanie default
begin
  puts "\n\n=========================================================="
  puts "Attempting to copy dm2_layout defaults files into your application..."

  require 'fileutils'

  FileUtils.cp_r 'defaults/.', RAILS_ROOT, :remove_destination => false

  puts "Success!"
  puts "=========================================================="
rescue Exception => ex
  raise ex
  puts "FAILED TO COPY LBUILDER DEFAULT FILES INTO YOUR APPLICATION."
  puts "EXCEPTION: #{ex}"
end

#zmiany w environment.rb
begin
  puts "\n\n=========================================================="
  puts "Attempting to make changes in environment.rb and application_controller.rb..."

  sentinel = 'Rails::Initializer.run do |config|'
  gsub_file('config/environment.rb', /(#{Regexp.escape(sentinel)})/mi) do |match|
      "\nTEMPLATE_DERBY_TAG_SOURCES = [File.join(RAILS_ROOT, 'app', 'tags', 'tags.derb')]\n\n#{match}"
  end

  sentinel = 'Rails::Initializer.run do |config|'
  gsub_file('config/environment.rb', /(#{Regexp.escape(sentinel)})/mi) do |match|
      "#{match}\nconfig.gem 'railsgarden-message_block', :lib => 'message_block'\nconfig.gem 'formtastic'\nconfig.gem 'will_paginate'\nconfig.gem 'inherited_resources'\nconfig.gem 'searchlogic'\n"
  end

  sentinel = 'class ApplicationController < ActionController::Base'
  gsub_file('app/controllers/application_controller.rb', /(#{Regexp.escape(sentinel)})/mi) do |match|
      "#{match}\nlayout \"default\"\n"
  end

  puts "Success!"
  puts "=========================================================="
rescue Exception => ex
raise ex
  puts "FAILED TO MAKE CHANGES IN ENVIRONMENT.RB AND APPLICATION_CONTROLLER.RB."
  puts "EXCEPTION: #{ex}"
end
