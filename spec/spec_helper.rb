require 'broken_redis'
require 'fakeredis'
require 'safe_redis'

RSpec.configure do |config|
  config.include BrokenRedis
end
