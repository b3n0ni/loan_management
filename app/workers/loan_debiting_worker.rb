class LoanDebitingWorker
  include Sidekiq::Worker

  def perform(loan_id)
    loan = Loan.find(loan_id)
    return unless loan.open?

    user = loan.user

    total_amount = loan.total_amount

    if total_amount > user.wallet_amount
      admin = User.find_by(role: 'admin')
      admin.wallet_amount +=  user.wallet_amount
      loan.total_amount = user.wallet_amount
      user.wallet_amount = 0
      user.save
      admin.save
      loan.close!
    end
    LoanDebitingWorker.perform_in(5.minutes, loan_id)
  end
end
