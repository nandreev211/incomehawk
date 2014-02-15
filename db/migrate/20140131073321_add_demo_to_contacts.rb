class AddDemoToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :demo, :boolean
  end

  def self.down
    remove_column :contacts, :demo, :boolean
  end
end