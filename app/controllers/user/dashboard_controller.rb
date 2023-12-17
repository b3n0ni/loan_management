class User::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @active_loans = current_user.loans.where(state: ["requested", "approved","open"])

    @repaid_loans = current_user.loans.where(state: "closed")

    @rejected_loans = current_user.loans.where(state: "rejected")
  end
end
