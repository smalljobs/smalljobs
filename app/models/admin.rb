class Admin < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  has_many :access_tokens, as: :userable, dependent: :destroy

  def name
    email
  end
end
