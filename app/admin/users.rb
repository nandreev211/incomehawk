ActiveAdmin.register User do

  index do
    column :id
    column :email
    column :name
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "Info" do
      f.input :email
      f.input :password
      f.input :name, :label => "User name"
    end
    f.buttons
  end
end