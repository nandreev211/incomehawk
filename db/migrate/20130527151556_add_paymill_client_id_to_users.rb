class AddPaymillClientIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :paymill_client_id, :string, default: ""
  end

  def self.down
    remove_column :users, :paymill_client_id
  end
end
