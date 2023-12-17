class AddTotalAmountToLoan < ActiveRecord::Migration[6.1]
  def change
    add_column :loans, :total_amount, :decimal
  end
end
