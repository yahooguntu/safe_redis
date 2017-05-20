require 'redis'

class SafeRedis < SimpleDelegator
  VERSION = '0.1.0'

  def initialize(redis)
    @redis = redis
    raise ArgumentError, 'argument must be instance of Redis class' unless @redis.class == Redis
    super @redis
  end

  def get(*args)
    super(*args)
  rescue Redis::BaseError
    nil
  end

  def del(*args)
    super(*args)
  rescue Redis::BaseError
    0
  end

  def mget(*args)
    super(*args)
  rescue Redis::BaseError
    Array.new(args.size)
  end

end
