class LoansController < ApplicationController
    before_action :authenticate_user!
    before_action :set_loan, only: [:show, :approve, :confirm, :repay]
  
    def new
      @loan = current_user.loans.build
    end
  
    def create
      @loan = current_user.loans.build(loan_params)
      @loan.total_amount = @loan.amount
      @loan.interest_rate = 5
      @loan.requested!
  
      if @loan.save
        redirect_to user_dashboard_path, notice: 'Loan requested successfully.'
      else
        render :new
      end
    end

    private

    def set_loan
        @loan = Loan.find(params[:id])
      end
    
    def loan_params
      params.require(:loan).permit(:amount, :interest_rate)
    end
end
  