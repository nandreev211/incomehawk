class PaymentsChangeDefaults < ActiveRecord::Migration
  def self.up
    change_column_default(:payments, :number_of_hours, 0)
    change_column_default(:payments, :number_of_months, 0)    
  end

  def self.down
  end
end
