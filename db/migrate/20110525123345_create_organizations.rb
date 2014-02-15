class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :url
      t.integer :admin_id
      t.references :plan
      t.string :color_scheme
      t.string :currency

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
