class Broker::StatisticsController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]

  def index
  end

  def organization_statistics
    organization = params[:organization_id] == '0' ? current_broker.all_organizations.pluck(:id) : [params[:organization_id]]
    data = ::Statistics::GenerateDataForChart.new(get_date_range, organization, options).call
    render json: {statistic: data[:datasets], label: data[:labels]}
  end

  def prepare_data_for_download
    params[:format] = :csv
    render json: {link: download_csv_broker_statistics_path(permitted_params)}
  end

  def download_csv
    organization = params[:organization_id] == '0' ? current_broker.all_organizations.pluck(:id) : [params[:organization_id]]
    respond_to do |format|
      format.all { send_data ::Statistics::ExportChartToCsv.new(get_date_range, organization, options).call, filename: "chart-#{Date.today}.csv" }
    end
  end

  protected

  def options
    params[:region_id] = current_region.id
    params.permit(:interval, :sum_type, :region_id, :active, :archived)
  end

  def permitted_params
    params.permit(:organization_id, :start_date, :end_date, :interval, :sum_type, :active, :archived, :format)
  end

  def get_date_range
    lowest_date = [Seeker, Provider, Job, Allocation, Assignment].map{|x| x.order(created_at: :asc).first.created_at}.sort.first.to_date
    highest_date = [Seeker, Provider, Job, Allocation, Assignment].map{|x| x.order(created_at: :desc).first.created_at}.sort.last.to_date
    [
        params[:start_date].present? ? params[:start_date].to_date : lowest_date,
        params[:end_date].present? ? params[:end_date].to_date : highest_date
    ]
  end

  def current_user
    current_broker
  end

end
