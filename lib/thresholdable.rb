require 'social_blast/shm_store'
require 'social_blast/object'
require 'social_blast/timed_counter'
require 'social_blast/exceptions'

module Thresholdable
  extend ShmStore
  include ShmStore

  DEFAULT_THRESHOLD = 3

  def threshold=(v)
    @threshold = v
  end

  def threshold
    @threshold ||= ( config.threshold || DEFAULT_THRESHOLD )
  end

  def post_counter
    @post_counter ||= TimedCounter.new
  end

  def reset_post_count
    post_counter.reset
  end

  def increment_post_count
    post_counter.increment
  end

  def threshold_reached?
    post_counter.value >= threshold
  end

  def can_post?
    !threshold_reached?
  end

  def when_can_post
    t = if threshold_reached?
      post_counter.timestamp + post_counter.interval_minutes
    else
      Time.now
    end

    t.to_s
  end
end

