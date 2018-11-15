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
      @total_giver = apply(@giver, karma * 0.2)
      @delta_giver = karma * 0.2
    else
      @total_giver = 0
      @delta_giver = 0
    end
  end

  def apply(user, karma)
    user.karma += karma
    if user.save
      return unicornize(user.karma)
    end
  end

  def unicornize(karma)
    case karma.abs
    when 1...1000
      "#{karma.round(2)} Billion"
    when 1001...1000000
      "#{karma.round(2)} Trillion"
    when 1000001...1000000000
      "#{karma.round(2)} Quadrillion"
    when String
      "You passed a string"
    else
      "#{karma.round(2)} Billion"
    end
  end

  def sanitize_json
    sanitized = self
    sanitized.giver = self.id_giver
    sanitized.receiver = self.id_receiver
    sanitized
  end

end
