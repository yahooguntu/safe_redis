require 'spec_helper'

describe SafeRedis do
  let(:safe_redis) { SafeRedis.new(Redis.new) }

  it 'with_broken_redis sanity check' do
    with_broken_redis do |redis|
      expect { redis.get('key') }.to raise_error(Redis::BaseError)
    end
  end

  describe '#set' do
    it 'works when redis is up' do
      expect { safe_redis.set('k', 'v') }.to_not raise_error
    end

    it 'fails when redis is down' do
      with_broken_redis do |redis|
        expect { SafeRedis.new(redis).set('k', 'v') }.to raise_error(Redis::BaseError)
      end
    end
  end

  describe '#get' do
    it 'works when redis is up' do
      safe_redis.set('k', 'v')
      expect(safe_redis.get('k')).to eq('v')
    end

    it 'returns safe default when redis is down' do
      with_broken_redis do |redis|
        expect(SafeRedis.new(redis).get('k')).to be_nil
      end
    end
  end

  describe '#del' do
    it 'works when redis is up' do
      safe_redis.set('k', 'v')
      expect(safe_redis.del('k')).to eq(1)
    end

    it 'returns safe default when redis is down' do
      with_broken_redis do |redis|
        expect(SafeRedis.new(redis).del('k')).to eq(0)
      end
    end
  end

  describe '#mget' do
    it 'works when redis is up' do
      safe_redis.mset('a', 1, 'b', 2)
      expect(safe_redis.mget('a', 'b', 'c')).to match_array(['1', '2', nil])
    end

    it 'returns safe default when redis is down' do
      with_broken_redis do |redis|
        expect(SafeRedis.new(redis).mget('a', 'b', 'c')).to match_array([nil, nil, nil])
      end
    end
  end

end
