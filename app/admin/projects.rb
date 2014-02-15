ActiveAdmin.register Project do

  index do
    column :id
    column :name
    column :description
    column :status
    column :start_date
    column :end_date
    column :created_at
    column :organization_id
    default_actions
  end

  filter :id
  filter :organization_id
  filter :name
  filter :description
  filter :status
  filter :created_at

  form do |f|
    f.inputs "Details" do
      f.input :organization
      f.input :name
      f.input :start_date
      f.input :end_date
      f.input :status, :as => :radio, :collection => Project::STATUSES
    end
    f.buttons
  end
end
