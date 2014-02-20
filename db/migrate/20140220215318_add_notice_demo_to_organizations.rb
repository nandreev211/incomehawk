class AddNoticeDemoToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :notice_demo, :boolean
  end

  def self.down
    remove_column :organizations, :notice_demo, :boolean
  end
end
