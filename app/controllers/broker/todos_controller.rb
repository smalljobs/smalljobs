class Broker::TodosController < ApplicationController
  before_filter :set_todo
  before_filter :authenticate_broker!

  def update
    postponed, message = nil
    if @todo.present?
      if(@todo.postponed == nil || @todo.postponed < DateTime.now)
        postponed = (DateTime.now+7.days).in_time_zone.beginning_of_day
        message = t('broker_dashboard.todo_table.postpone_message')
      else
        message = t('broker_dashboard.todo_table.postpone_message_back')
      end
    end
    respond_to do |format|
      if @todo.blank?
        format.json {render json: {message: t('broker_dashboard.todo_table.not_found')}, status: :not_found}
      elsif @todo.update(postponed: postponed)
        format.json {render json: {message: message, postponed: @todo.postponed&.strftime("%d.%m.%Y")}, status: :ok}
      else
        format.json {render json: {error: @todo.errors}, status: :unprocessable_entity}
      end
    end
  end

  def completed
    respond_to do |format|
      if @todo.blank?
        format.json {render json: {message: t('broker_dashboard.todo_table.not_found')}, status: :not_found}
      elsif @todo.update(completed: Time.zone.now)
        format.json {render json: {}, status: :ok}
      else
        format.json {render json: {error: @todo.errors}, status: :unprocessable_entity}
      end
    end
  end

  def uncompleted
    respond_to do |format|
      if @todo.blank?
        format.json {render json: {message: t('broker_dashboard.todo_table.not_found')}, status: :not_found}
      elsif @todo.update(completed: nil)
        format.json {render json: {}, status: :ok}
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
