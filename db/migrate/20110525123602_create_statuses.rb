class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :text
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
