class AddPaymillOfferFieldsToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :amount, :integer, default: 0 # in cents
    add_column :plans, :currency, :string, default: "EUR" # ISO 4217 formatted currency code
    add_column :plans, :interval, :string, default: "1 MONTH" # Format: number DAY|WEEK|MONTH|YEAR Example: 2 DAY
  end

  def self.down
    remove_column :plans, :amount
    remove_column :plans, :currency
    remove_column :plans, :interval
  end
end
