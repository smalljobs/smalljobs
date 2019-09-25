class Broker::JobsCertificatesController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:certificate]

  def update
    @seeker = Seeker.find(params[:id])
    @jobs_certificate =  @seeker.jobs_certificate
    @jobs_certificate = JobsCertificate.new(seeker_id: @seeker.id) if @jobs_certificate.blank?
    respond_to do |format|
      if @jobs_certificate.update(permitted_params[:jobs_certificate])
        format.json { render json: {pdf_link: broker_jobs_certificate_certificate_path(@jobs_certificate.jobs_certificate_id)}, status: :ok}
      else
        format.json { render json: { error: @jobs_certificate.errors.full_messages}, status: :unprocessable_entity}
      end
    end
  end

  def certificate
    @jobs_certificate = JobsCertificate.find_by(jobs_certificate_id: params[:jobs_certificate_id])
    @seeker = @jobs_certificate.seeker
    @organization = @seeker.organization
    render pdf: "Arbeitszeugnis_#{@seeker.firstname}_#{@seeker.lastname}", template: 'broker/jobs_certificates/certificate.html.erb', margin: {top: 0, left: 0, right: 0, bottom: 0}
  end

  private
  def permitted_params
    params.permit(jobs_certificate: [:content])
  end
end