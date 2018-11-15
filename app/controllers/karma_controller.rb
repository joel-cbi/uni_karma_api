class KarmaController < ApplicationController
  before_action :set_users, only: [:give_karma]
  before_action :set_slack, only: [:show_leaderboard, :show_friends, :show_foes, :show_karma]

  def give_karma
    if authenticate
      @karmic_object = Karma.new(@giver, @receiver)
      @karmic_response = @karmic_object.give(@karma)
      @history = History.create(giver: @giver, receiver: @receiver, karma: @karma)
      render json: @karmic_response.sanitize_json
    else
      render json: {message: 'Not Authorized. API_TOKEN missing'}, status: 401
    end
  end

  def show_karma
    if authenticate
      @karmas = User.all.select(:slack_id, :karma)
      render json: @karmas
    else
      render json: {message: 'Not Authorized. API_TOKEN missing'}, status: 401
    end
  end

  def show_history
    render json: History.all
  end

  def show_leaderboard
    @i = 0
    @winners = User.all.select(:slack_id, :karma).order("karma DESC").limit(5)
    @texts = "*Top #{@winners.length}*\n"
    while @i < @winners.length
      @texts += serialize_leaderboard_row(@i+1, @winners[@i].slack_id, Karma.unicornize(@winners[@i].karma))
      @i += 1
    end

    @i = 0
    @losers = User.all.select(:slack_id, :karma).order("karma ASC").limit(5)
    @texts += "*Bottom #{@losers.length}*\n"
    while @i < @losers.length
      @texts += serialize_leaderboard_row(@i+1, @losers[@i].slack_id, Karma.unicornize(@losers[@i].karma))
      @i += 1
    end

    render json: {"text": @texts, "mrkdwn": true, "response_type": "in_channel"}
  end

  def show_friends

    @i = 0
    @friends = History.all.where(receiver_id: @user_id).group(:giver_id).select("giver_id, sum(karma) as karma").order("karma DESC").limit(5)
    @text = "*Top #{@friends.length} friends*\n"
    if @friends.length == 0
      @text = "You don't have any friends"
    else
      while @i < @friends.length
        @tmp_id = User.where(id: @friends[@i].giver_id).first.slack_id
        @text += serialize_friend_foe_row(@i+1, @tmp_id, Karma.unicornize(@friends[@i].karma))
        @i += 1
      end
    end

    render json: {"text": @text, "mrkdwn": true, "response_type": "in_channel"}
  end

  def show_foes

    @i = 0
    @foes = History.all.where(receiver_id: @user_id).group(:giver_id).select("giver_id, sum(karma) as karma").order("karma").limit(5)
    @text = "*Top #{@foes.length} foes*\n"
    if @foes.length == 0
      @text = "You don't have any foes"
    else
      while @i < @foes.length
        @tmp_id = User.where(id: @foes[@i].giver_id).first.slack_id
        @text += serialize_friend_foe_row(@i+1, @tmp_id, Karma.unicornize(@foes[@i].karma))
        @i += 1
      end
    end

    render json: {"text": @text, "mrkdwn": true, "response_type": "in_channel"}
  end

  def serialize_leaderboard_row(rownum, slack_id, karma_value)
    return "\t#{ rownum}. <@#{slack_id}> with #{karma_value} karma.\n"
  end

  def serialize_friend_foe_row(rownum, slack_id, karma_value)
    return "\t#{ rownum}. <@#{slack_id}> gave you #{karma_value} karma.\n"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_users
    @giver = User.where(slack_id: karma_params[:slack_id_giver]).first_or_create
    @receiver = User.where(slack_id: karma_params[:slack_id_receiver]).first_or_create
    @karma = karma_params[:karma]
  end

  def set_slack
    @slack_id = slack_params[:user_id]
    @user_id = User.where(slack_id: @slack_id).first_or_create
  end

  def slack_params
    params.permit(:token,
                  :team_id,
                  :team_domain,
                  :enterprise_id,
                  :enterprise_name,
                  :channel_id,
                  :channel_name,
                  :user_id,
                  :user_name,
                  :command,
                  :text,
                  :response_url,
                  :trigger_id)
  end

  # Only allow a trusted parameter "white list" through.
  def karma_params
    params.require(:karma).permit(:slack_id_giver,
                                  :slack_id_receiver,
                                  :karma)
  end

  def authenticate
    auth_header = request.headers['Authorization']
    JsonWebToken.decode(auth_header) == ENV['API_TOKEN_PAYLOAD']
  end

end
