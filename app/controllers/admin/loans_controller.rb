class Admin::LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def show
    @loan = Loan.find(params[:id])
    @loan_transactions = @loan.amount
    respond_to do |format|
      format.html { render :show }
      format.json { render json: { loan: @loan, transactions: @loan_transactions } }
    end
  end

  def reject
    @loan = Loan.find(params[:id])

    if @loan.requested?
      @loan.reject!
      redirect_to admin_dashboard_path
    end
  end

  def accept
    @loan = Loan.find(params[:id])
    
    if @loan.requested?
      new_interest_rate = params[:loan][:interest_rate]
      new_interest_rate = new_interest_rate.present? ? new_interest_rate : 0.05

      @loan.update(interest_rate: new_interest_rate)

      ActiveRecord::Base.transaction do
        @loan.approve!
        redirect_to admin_dashboard_path
      end
    end
    respond_to do |format|
      format.html { redirect_to admin_loan_path(@loan) }
      format.js
    end
  end

  private

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.role == 'admin'
  end
end
