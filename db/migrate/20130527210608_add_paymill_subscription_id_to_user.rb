class AddPaymillSubscriptionIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :paymill_subscription_id, :string, default: ""
  end

  def self.down
    remove_column :users, :paymill_subscription_id
  end
end
