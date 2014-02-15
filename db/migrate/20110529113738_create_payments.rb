class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :project_id
      t.float :rate
      t.string :recurring
      t.datetime :expected_payment_date
      t.float :number_of_hours
      t.float :number_of_months
      t.datetime :start_date
      t.boolean :completed
      t.datetime :completed_date
      t.integer :client_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
