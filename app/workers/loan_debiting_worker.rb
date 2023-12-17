class LoanDebitingWorker
  include Sidekiq::Worker

  def perform(loan_id)
    loan = Loan.find(loan_id)
    return unless loan.open?

    user = loan.user

    total_amount = loan.total_amount

    if total_amount > user.wallet_amount
      admin = User.find_by(role: 'admin')
      admin.wallet_amount += user.wallet_amount
      user.wallet_amount = 0
      user.save
      admin.save
      loan.close!
      scheduled_set = Sidekiq::ScheduledSet.new
      interest_worker_jobs = scheduled_set.select { |job| job.args.first == 'LoanInterestWorker' && job.args.last == [loan_id] }
      interest_worker_jobs.each(&:delete)
      return
    end
    LoanDebitingWorker.perform_in(5.minutes, loan_id)
  end
end
