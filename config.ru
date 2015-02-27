require_relative 'app'
require_relative './routes/user_routes'
require_relative './routes/friend_routes'


run Rack::URLMap.new({
	'/' => GadaboutApi,
	'/users' => UserRoutes,
	'/friends' => FriendRoutes
})
