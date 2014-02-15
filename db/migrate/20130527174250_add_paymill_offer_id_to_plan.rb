class AddPaymillOfferIdToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :paymill_offer_id, :string, default: ""
  end

  def self.down
    remove_column :plans, :paymill_offer_id
  end
end
