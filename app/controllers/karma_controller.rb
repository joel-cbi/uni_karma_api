class KarmaController < ApplicationController
  before_action :set_users, only: [:give_karma]

  def give_karma
    puts "PARAMS:\n\n#{karam_params}\n\n"
    @delta = Karma.give(@giver, @receiver, @karma)
    @history = History.create(giver: @giver, receiver: @receiver, karma: @karma)
    render json: @delta
  end

  def show_karma
    @karmas = User.all.select(:slack_name, :karma).map{ |user| {slack_name: user.slack_name, karma: Karma.unicornize(user.karma)}}
    render json: @karmas
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
    params.require(:karma).permit(:slack_id_giver, :slack_id_receiver, :slack_name_giver, :slack_name_receiver, :karma)
  end

end
