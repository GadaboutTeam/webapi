require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require 'rake/testtask'
require 'sinatra/activerecord/rake'

Rake::TestTask.new do |t|
	ENV['RACK_ENV']="test"
	t.libs << "test"
	t.test_files = FileList['test/test*.rb']
	t.verbose = true
end
