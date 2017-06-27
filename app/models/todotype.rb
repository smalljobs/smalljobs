class Todotype < ApplicationRecord
  enum table: { job: 1, provider: 2, allocation: 3, seeker: 4 }

  has_many :todos, dependent: :destroy

  validates :table, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :where, presence: true

  validate :check_where

  # after_save :create_todos_for_allocations

  def check_where
    if !where.nil? && where.include?(';')
      errors.add(:where, :invalid_where)
    else
      begin
        if table == 'job'
          Job.joins(:allocations).find_by(where)
        elsif table == 'provider'
          Provider.find_by(where)
        elsif table == 'allocation'
          Allocation.joins(:seeker, job: :provider).find_by(Allocation.replace_state_with_number(where))
        elsif table == 'seeker'
          Seeker.find_by(where)
        end
      rescue => ex
        errors.add(:where, ex.to_s)
      end
    end
  end

  def create_todos_for_allocations
    Todo.where(todotype_id: id).find_each &:destroy!
    Allocation.joins(:seeker, job: :provider).where(Allocation.replace_state_with_number(where)).find_each do |allocation|
      Todo.create(record_id: allocation.id, record_type: :allocation, todotype_id: id, allocation_id: allocation.id, seeker_id: allocation.seeker_id, job_id: allocation.job_id, provider_id: allocation.provider_id)
    end
  end
end
