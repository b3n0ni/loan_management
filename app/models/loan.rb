class Loan < ApplicationRecord
  belongs_to :user

  enum state: { requested: 'requested', approved: 'approved', open: 'open', closed: 'closed', rejected: 'rejected', repaid: 'repaid' }

  include AASM

  aasm column: 'state' do
    state :requested, initial: true
    state :approved, :open, :closed, :rejected, :repaid

    event :approve do
      transitions from: :requested, to: :approved
    end

    event :reject do
      transitions from: [:requested, :approved], to: :rejected
    end

    event :confirm do
      transitions from: :approved, to: :open
    end

    event :close do
      transitions from: :open, to: :closed
    end
  end


  def close!
    self.update(state: 'closed')
  end
end
