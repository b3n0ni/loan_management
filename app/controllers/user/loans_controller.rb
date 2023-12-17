# app/controllers/user/loans_controller.rb
class User::LoansController < ApplicationController
    before_action :authenticate_user!
    before_action :set_loan, only: [:show, :repay, :confirm]
  
    def index
      @loans = current_user.loans
    end
  
    def new
      @loan = current_user.loans.build
    end
    def show
      @loan = Loan.find(params[:id])
      @loan_transactions = @loan.amount
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { loan: @loan, transactions: @loan_transactions } }
      end
    end

    def confirm
      @loan = current_user.loans.find(params[:id])
      @admin = User.where(role: 'admin').first

      if @loan.approved?
        ActiveRecord::Base.transaction do
          admin_wallet = @admin.wallet_amount - @loan.amount
          @admin.update!(wallet_amount: admin_wallet)

          user_wallet = @loan.user.wallet_amount + @loan.amount
          @loan.user.update!(wallet_amount: user_wallet)

          @loan.open!

          InterestCalculationWorker.perform_in(5.minutes, @loan.id)
          LoanDebitingWorker.perform_in(5.minutes, @loan.id)

          redirect_to @loan
        end
      else
        redirect_to @loan
      end
    end

    def reject
      @loan = current_user.loans.find(params[:id])
  
      if @loan.approved?
        @loan.reject!
  
        redirect_to user_dashboard_path(@loan)
      else
        redirect_to user_dashboard_path(@loan)
      end
    end
  
    def show
      @loan = current_user.loans.find(params[:id])
    end
  
    def repay
      @loan = current_user.loans.find(params[:id])

      if @loan.may_close?
        ActiveRecord::Base.transaction do
          user_wallet = current_user.wallet_amount - @loan.total_amount
          current_user.update!(wallet_amount: user_wallet)

          admin = User.find_by(role: 'admin')
          admin_wallet = admin.wallet_amount + @loan.total_amount
          admin.update!(wallet_amount: admin_wallet)

          @loan.close!
        end
  
        redirect_to @loan
      else
        redirect_to @loan
      end
    end
  
    private
  
    def set_loan
      @loan = current_user.loans.find(params[:id])
    end
  
    def loan_params
      params.require(:loan).permit(:amount, :interest_rate)
    end
  end
  