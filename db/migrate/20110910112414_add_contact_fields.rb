class AddContactFields < ActiveRecord::Migration
  def self.up
    add_column :contacts, :logo, :string
    add_column :contacts, :website, :string
    add_column :contacts, :home_phone, :string
    add_column :contacts, :work_phone, :string
    add_column :contacts, :address_1, :string
    add_column :contacts, :address_2, :string
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :zip, :string
    add_column :contacts, :description, :text
  end

  def self.down                       
    remove_column :contacts, :logo
    remove_column :contacts, :website
    remove_column :contacts, :home_phone
    remove_column :contacts, :work_phone
    remove_column :contacts, :address_1
    remove_column :contacts, :address_2
    remove_column :contacts, :city
    remove_column :contacts, :state
    remove_column :contacts, :zip
    remove_column :contacts, :description
  end
end
