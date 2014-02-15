class AddBilledOnToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :billed_at, :datetime
  end

  def self.down
    remove_column :payments, :billed_at
  end
end
