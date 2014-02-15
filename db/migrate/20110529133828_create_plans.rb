class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.integer :max_users
      t.integer :max_projects
      t.integer :max_contacts

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
