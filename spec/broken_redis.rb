require 'redis'

# simulates a broken redis instance
module BrokenRedis

  def with_broken_redis
    # override fakeredis
    Redis::Connection.drivers << ::Redis::Connection::Ruby

    # create fake ones
    # this address needs to be resolvable, but not point at a real redis instance
    break_redis
    redis = Redis.new

    begin
      yield(redis)
    ensure
      # put everything back the way it was
      unbreak_redis
      Redis::Connection.drivers.pop
    end
  end

  private

  # Here we do unspeakable things to Redis. `break_redis` reopens the Redis class, overrides
  # the initializer to ignore all passed-in options, and overrides `synchronize` so it
  # always raises Redis::BaseError. Since `synchronize` wraps all Redis calls, this simulates a
  # failed connection to a Redis server. `unbreak_redis` then undoes all these changes.

  def break_redis
    eval <<-CLS
      class ::Redis
        alias old_initialize initialize
        def initialize(options={})
          super()
        end

        alias old_synchronize synchronize
        def synchronize
          raise Redis::BaseError.new('not connected')
        end
      end
    CLS
  end

  def unbreak_redis
    eval <<-CLS
      class ::Redis
        alias initialize old_initialize
        alias synchronize old_synchronize
      end
    CLS
  end

end
