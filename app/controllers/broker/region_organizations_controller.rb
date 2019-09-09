class Broker::RegionOrganizationsController < InheritedResources::Base

  before_filter :authenticate_broker!
  load_and_authorize_resource :organization

  def edit
    organization
  end

  def create
    params[:organization][:region_id] = current_region.id
    params[:organization][:assigned_to_region] = 'true'
    @organization = Organization.new(permitted_params)
    respond_to do |format|
      if @organization.save
        format.json { render json: { message: t('common.created')}, status: :ok }
      else
        format.json { render json: { error: @organization.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if organization.update(permitted_params)
        flash[:notice] = t('common.created')
        format.html { redirect_to edit_broker_region_organization_path(organization) }
        format.json { render json: { message: t('common.updated')}, status: :ok }
      else
        flash[:error] = organization.errors.full_messages.join('.')
        format.html { redirect_to edit_broker_region_organization_path(organization) }
        format.json { render json: { error: broker.errors.full_messages.join('.') }, status: :unprocessable_entity }
      end
    end
  end

  def reset_templates_to_default
    template_names = Organization::TEMPLATES_NAMES
    default_templates = {}
    DefaultTemplate.where(template_name: template_names).each do |default_template|
      default_templates[default_template.template_name] = default_template.template
    end
    render json: default_templates
  end

  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def organization
    @organization ||= current_region.organizations.where(id: params[:id]).first
  end

  def permitted_params
    params.require(:organization).permit(:wage_factor, :welcome_email_for_parents_msg, :activation_msg, :get_job_msg, :not_receive_job_msg, :welcome_chat_register_msg, :welcome_app_register_msg, :welcome_app_register_above_18_msg, :welcome_chat_register_above_18_msg, :welcome_email_for_parents_above_18_msg, :welcome_letter_employers_msg, :opening_hours, :id, :logo, :logo_delete, :background, :background_delete, :name, :description, :website, :street, :email, :phone, :default_hourly_per_age, :place_id,:assigned_to_region, :region_id, :broker_ids, :from_age, :to_age)
  end

end

