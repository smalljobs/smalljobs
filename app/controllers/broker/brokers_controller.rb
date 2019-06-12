class Broker::BrokersController < InheritedResources::Base
  before_filter :authenticate_broker!

  load_and_authorize_resource :region

  def edit
    broker
  end

  def create
    respond_to do |format|
      if create_broker
        format.json { render json: { message: t('common.created')}, status: :ok }
      else
        format.json { render json: { error: @broker.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_additional_params(params)
    respond_to do |format|
      if update_broker
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

  def create_broker
    params[:broker][:region_id] = current_region.id
    @broker = Broker.new(permitted_params)
    ActiveRecord::Base.transaction do
      @broker.save
      create_employment
    end
    @broker.errors.blank?
  end

  def update_broker
    ActiveRecord::Base.transaction do
      broker.update(permitted_params)
      create_employment
    end
    broker.errors.blank?
  end

  # This is mockup, this is bad. When we have more time we have to makes employments unique and check all data if they're still correct.
  # I made it to create employment without broker or organizaiton.
  def create_employment
    if params[:organization].present?
      Employment.where(region_id: current_region.id, broker_id: broker.try('id')).destroy_all
      # takes employment if exisit, if not, takes empty slot of organization. if those does not exist, create one.
      # employment = Employment.where(region_id: current_region.id, organization_id: params[:organization], broker_id: broker.try('id')).first ||
      #              Employment.where(region_id: current_region.id, organization_id: params[:organization], broker_id: nil).first ||
      #              Employment.where(region_id: current_region.id, broker_id: broker.try('id')).first
      # if employment.present? && employment.broker.blank?
      #   employment.update(broker_id: broker.id)
      #   raise ActiveRecord::Rollback if employment.errors.present?
        emp = Employment.create(region_id: current_region.id, organization_id: params[:organization], broker_id: broker.id)
        raise ActiveRecord::Rollback unless emp
    else
      employments = Employment.where(region_id: current_region.id, broker_id: broker.id)
      employments.each do |emp|
        emp.assigned_only_to_region = true
        emp.update(organization_id: nil)
        raise ActiveRecord::Rollback if emp.errors.present?
      end
    end
  end

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
                                   :active, :role, :assigned_to_region, :region_id, employment_ids: [], update_pref_ids: [])
  end

end

