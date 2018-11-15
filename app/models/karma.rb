class Karma
  attr_accessor :delta_giver, :delta_receiver, :total_giver, :total_receiver, :id_giver, :id_receiver, :giver, :receiver, :karma

  def initialize(giver, receiver)
    @giver = giver
    @receiver = receiver
    @id_giver = @giver.slack_id
    @id_receiver = @receiver.slack_id
    @delta_giver = 0.0
  end

  def give(karma)
    @karma = karma.to_f
    @delta_receiver = @karma
    if @karma > 0
      add(@karma)
    else
      subtract(@karma)
    end
    return self
  end

  def add(karma)
    @total_receiver = apply(@receiver, karma)
    @total_giver = apply(@giver, 0)
  end

  def subtract(karma)
    @total_receiver = apply(@receiver, karma)
    if @receiver != @giver
      penalty = 0.2
      delta = karma * penalty
      rounded_int_delta = delta>0 ? delta.ceil : delta.floor
      @total_giver = apply(@giver, rounded_int_delta)
      @delta_giver = rounded_int_delta
    else
      @total_giver = 0
      @delta_giver = 0
    end
  end

  def apply(user, karma)
    user.karma += karma
    if user.save
      return Karma.unicornize(user.karma)
    end
  end

  def self.unicornize(karma)
    case karma.abs
    when 1...1000
      "#{karma.round} Billion"
    when 1001...1000000
      "#{karma.round} Trillion"
    when 1000001...1000000000
      "#{karma.round} Quadrillion"
    when String
      "You passed a string"
    else
      "#{karma.round} Billion"
    end
  end

  def sanitize_json
    sanitized = self
    sanitized.giver = self.id_giver
    sanitized.receiver = self.id_receiver
    sanitized
  end

end
