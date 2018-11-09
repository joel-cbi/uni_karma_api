class KarmaController < ApplicationController
  before_action :set_users, only: [:give_karma]

  def give_karma
    if authenticate
      @karmic_object = Karma.new(@giver, @receiver)
      @karmic_response = @karmic_object.give(@karma)
      @history = History.create(giver: @giver, receiver: @receiver, karma: @karma)
      render json: @karmic_response.sanitize_json
    else
      render json: {}, status: 401
    end
  end

  def show_karma
    if authenticate
      @karmas = User.all.select(:slack_id, :karma)
      render json: @karmas
    else
      render json: {}, status: 401
    end
  end

  def show_history
    render json: History.all
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_users
    @giver = User.where(slack_id: karma_params[:slack_id_giver]).first_or_create
    @receiver = User.where(slack_id: karma_params[:slack_id_receiver]).first_or_create
    @karma = karma_params[:karma]
  end

  # Only allow a trusted parameter "white list" through.
  def karma_params
    params.require(:karma).permit(:slack_id_giver, :slack_id_receiver, :karma)
  end

  def authenticate
    auth_header = request.headers['Authorization']
    JsonWebToken.decode(auth_header) == ENV['API_TOKEN_PAYLOAD']
  end

end
