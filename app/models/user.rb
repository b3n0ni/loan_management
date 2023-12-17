class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :loans
  before_create :set_default_user

  def admin?
    role == 'admin'
  end

  private

  def set_default_user
    self.wallet_amount = 10000
    self.role = "user"
    self.name = self.email.split('@').first
  end
end
