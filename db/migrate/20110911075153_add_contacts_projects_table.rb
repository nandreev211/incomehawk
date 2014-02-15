class AddContactsProjectsTable < ActiveRecord::Migration
  def self.up
    create_table :contacts_projects, :id => false do |t|
      t.integer :contact_id
      t.integer :project_id
    end
  end

  def self.down
    drop_table  :contacts_projects
  end
end
