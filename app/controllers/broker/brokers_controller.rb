class Broker::BrokersController < InheritedResources::Base
  before_filter :authenticate_broker!

  load_and_authorize_resource :region

  def edit
    broker
  end

  def create
    @broker = current_region.brokers.new(permitted_params)
    respond_to do |format|
      if @broker.save
        format.json { render json: { message: t('common.created')}, status: :ok }
      else
        format.json { render json: { error: @broker.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_additional_params(params)
    respond_to do |format|
      if broker.update(permitted_params)
        flash[:notice] = t('common.updated')
        format.html { redirect_to edit_broker_user_path(broker) }
        format.json { render json: { message: t('common.updated')}, status: :ok }
      else
        flash[:error] = broker.errors.full_messages.join('.')
        format.html { redirect_to edit_broker_user_path(broker) }
        format.json { render json: { error: broker.errors.full_messages.join('.') }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if broker.destroy
        format.json { render json: { message: t('common.updated'), location: broker_dashboard_path}, status: :ok }
      else
        format.json { render json: { error: broker.errors.full_messages.join('.'), location: broker_dashboard_path }, status: :unprocessable_entity }
      end
    end
  end

  protected

  def set_additional_params params
    if params[:broker][:password].blank?
      params[:broker].delete(:password)
    else
      params[:broker][:password_confirmation] = params[:broker][:password]
    end
    params[:broker][:active] = !(params[:broker][:role] == "blocked")
  end

  def broker
    @broker ||= current_region.brokers.find_by(id: params[:id])
  end

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
    params.require(:broker).permit(:email, :password, :password_confirmation, :firstname, :lastname, :phone, :mobile, :contact_availability,
                                   :active, :role, employment_ids: [], update_pref_ids: [])
  end

end

