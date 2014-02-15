class Associations < ActiveRecord::Migration
  def self.up
    create_table :membershipments do |t|
      t.integer :organization_id
      t.integer :user_id

      t.timestamps
    end
    
    create_table :projects_users, :id => false do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end    
  end

  def self.down
    drop_table :projects_users
    drop_table :membershipments
  end
end
