class InterestCalculationWorker
  include Sidekiq::Worker

  def perform(loan_id)
    loan = Loan.find(loan_id)
    return unless loan.open?

    interest_amount = calculate_interest(loan.amount, loan.interest_rate)

    total_amount = loan.total_amount + interest_amount
    loan.update(total_amount: total_amount)

    InterestCalculationWorker.perform_in(5.minutes, loan_id)
  end

  private

  def calculate_interest(amount, interest_rate)
    interest_amount = amount * (interest_rate / 100)
    interest_amount
  end
end
