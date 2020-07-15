class Broker::RocketchatsController < InheritedResources::Base

  before_filter :authenticate_broker!

  def create
    rc = RocketChat::Users.new
    answer = rc.create_token(current_broker.rc_id)
    respond_to do |format|
      if answer
        format.json { render json: answer, status: :ok }
      else
        format.json { render json: { error: rc.error }, status: :unprocessable_entity }
        end
    end
  end

end
