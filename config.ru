require_relative './routes/user_routes'
require_relative './routes/friend_routes'

ENV['RACK_ENV'] ||= 'development'

run Rack::URLMap.new({
	'/users' => UserRoutes,
	'/friends' => FriendRoutes
})
