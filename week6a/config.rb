set :server, %w[thin mongrel webrick]
enable :sessions
use Rack::Flash
