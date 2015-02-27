require 'sinatra'#/base'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/user'

configure { set :server, :puma }
set :port, '8080'
set :bind, '0.0.0.0'

class GadaboutApi < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/' do
		"Hello World!"
	end

	get '/usertest' do
		User.first.first_name
	end


	# start the server if ruby file executed directly
	run! if app_file == $0
end
