class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @loan_requests = Loan.requested.includes(:user)
    @active_loans = Loan.open.includes(:user)
    @closed_loans = Loan.closed.includes(:user)
    @approved_loans = Loan.approved.includes(:user)
    @rejected_loans = Loan.rejected.includes(:user)
  end

  private

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
