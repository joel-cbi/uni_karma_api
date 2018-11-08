class Karma

  def self.give(giver, receiver, karma)
    karma = karma.to_f
    karma_delta = {}
    if karma > 0
      karma_delta[receiver.slack_name] = self.add(receiver, karma)
    else
      karmic_response = self.subtract(giver, receiver, karma)
      karma_delta[receiver.slack_name] = karmic_response[:receiver]
      karma_delta[giver.slack_name] = karmic_response[:giver]
    end
    return karma_delta
  end

  def self.add(receiver, karma)
    self.apply(receiver, karma)
  end

  def self.subtract(giver, receiver, karma)
    receiver_delta = receiver_delta = self.apply(receiver, karma)
    giver_delta = self.apply(giver, karma * 0.2)
    return {receiver: receiver_delta, giver: giver_delta}
  end

  def self.apply(user, karma)
    user.karma += karma
    if user.save
      return self.unicornize(user.karma)
    end
  end

  def self.unicornize(karma)
    case karma.abs
    when 1...1000
      "#{karma} Billion"
    when 1000...1000000
      "#{karma} Trillion"
    when 1000000...1000000000
      "#{karma} Quadrillion"
    when String
      "You passed a string"
    else
      "#{karma} Billion"
    end
  end

end
