class Broker::TodosController < ApplicationController
  before_filter :set_todo
  before_filter :authenticate_broker!

  def update
    if @todo.present?
      postponed = ( @todo.postponed == nil || @todo.postponed < DateTime.now) ? (DateTime.now+7.days) : nil
    end
    respond_to do |format|
      if @todo.blank?
        format.json {render json: {message: "Todo nicht gefunden"}, status: :not_found}
      elsif @todo.update(postponed: postponed)
        format.json {render json: {message: "Das Todo wurde um eine Woche verschoben.", postponed: @todo.postponed&.strftime("%d.%m.%Y")}, status: :ok}
      else
        format.json {render json: {error: @todo.errors}, status: :unprocessable_entity}
      end
    end
  end

  def set_todo
    allocations = Allocation.where(job: @jobs)
    @providers = current_broker.providers.includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).reverse_order()
    @seekers = current_broker.seekers.includes(:place, :organization).group('seekers.id').order(:updated_at).reverse_order()
    @jobs = current_broker.jobs.includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()

    @todo = Todo.where(seeker: @seekers)
                 .or(Todo.where(provider: @providers))
                 .or(Todo.where(job: @jobs))
                 .or(Todo.where(allocation: allocations))
                 .where(id: params[:id]).first
  end

end
