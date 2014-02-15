class AddDemoToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :demo, :boolean
  end

  def self.down
    remove_column :projects, :demo, :boolean
  end
end
