class AddDefaultPlan < ActiveRecord::Migration
  def self.up
    change_column_default :organizations, :plan_id, Plan.default_id
  end

  def self.down
  end
end
