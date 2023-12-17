class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :loans
  before_create :set_default_wallet_amount
  attr_accessor :name

  def admin?
    role == 'admin'
  end

  private

  def set_default_wallet_amount
    self.wallet_amount = 10000
  end
end
