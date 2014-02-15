ActiveAdmin.register Organization do
  index do
    column :id
    column :name
    column :admin_id
    column :url
    column :plan
    column :currency
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :admin
      f.input :name
      f.input :plan
      f.input :url, as: :string
      f.input :currency, :as => :radio, :collection => Organization.currencies
    end
    f.buttons
  end
end
