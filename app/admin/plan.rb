ActiveAdmin.register Plan do
  index do
    column :name
    column :max_projects
    column :max_contacts
    column :amount
    column :currency
    column :interval
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :max_projects
      f.input :max_contacts
      f.input :amount, :label => "Amount (in cents)"
      f.input :currency, :label => "Currency (ISO 4217 formatted currency code Ex: EUR)"
      f.input :interval, :label => "Interval (Format: number DAY|WEEK|MONTH|YEAR Example: 2 DAY)"
    end
    f.buttons
  end

  show do |f|
    attributes_table do
      row :name
      row :max_projects
      row :max_contacts
      row :amount
      row :currency
      row :interval
    end
    active_admin_comments
  end
end
