class PlayerLeaderboard
  def initialize(year = 'all', attr = 'dpi_total_earning')
    @year = year
    @attr = attr
    redis_options = { redis_connection: redis_store }
    @lb = Leaderboard.new(cache_key, Leaderboard::DEFAULT_OPTIONS, redis_options)
    init_ld_data
  end

  def ld
    @lb
  end

  def redis_store
    Rails.cache.data
  end

  def cache_key
    @cache_key ||= Rails.cache.data.send(:interpolate, "player_#{@attr}_#{@year}")
  end

  def init_ld_data!
    redis_store.expire(cache_key, 0)
    @lb.rank_members Player.pluck(:id, @attr)
  end

  def init_ld_data
    return if redis_store.exists(cache_key)

    init_ld_data!
  end
end
