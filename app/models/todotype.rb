class Todotype < ApplicationRecord
  enum table: { job: 1, provider: 2, allocation: 3, seeker: 4 }

  has_many :todos, dependent: :destroy

  validates :table, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :where, presence: true

  validate :check_where

  def check_where
    if !where.nil? && where.include?(';')
      errors.add(:where, :invalid_where)
    else
      begin
        if table == 'job'
          Job.find_by(where)
        elsif table == 'provider'
          Provider.find_by(where)
        elsif table == 'allocation'
          Allocation.find_by(Allocation.replace_state_with_number(where))
        elsif table == 'seeker'
          Seeker.find_by(where)
        end
      rescue => ex
        errors.add(:where, ex.to_s)
      end
    end

  end
end
