class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :status
      t.integer :organization_id
      t.integer :estimated_value
      t.integer :category_id
      
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
