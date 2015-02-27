#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
	# fix for spatial? issue
	ActiveRecord::ConnectionAdapters::PostgreSQLColumn.class_eval do
	  def spatial?
	    type == :spatial || type == :geography
	  end
	end


	db = URI.parse(ENV['DATABASE_URL'])
 
	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme == 'postgres' ? 'postgis' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end
