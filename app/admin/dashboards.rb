ActiveAdmin.register_page 'Dashboard' do
  content :title => "Incomehawk Dashboard" do

    columns do
      column do
        panel "Recent Projects" do
          ul do
            Project.recent(5).collect do |project|
              li link_to(project.name, admin_project_path(project))
            end
          end
        end
      end

      column do
        panel "Recent Organizations" do
          ul do
            Organization.recent(5).collect do |organization|
              li link_to(organization.name, admin_organization_path(organization))
            end
          end
        end
      end
    end

  end
end
