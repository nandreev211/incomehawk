# TODO create default user organization
# Create a default user
User.create!(:email => 'n.andreev.211@gmail.com', :password => 'password', :password_confirmation => 'password')

# categories #
Category.destroy_all
Organization.all.collect{ |o|
  o.categories.create!(:name => "Web-design", :color => '#cc2222')
  o.categories.create!(:name => "Logo-design", :color => '#22aa22')
  o.categories.create!(:name => "HTML/CSS", :color => '#0000cc')
}

# contacts #
Contact.destroy_all
Organization.all.each{ |o|
  o.contacts.create!(:first_name => "John",      :last_name => "Ghalt",       :organization_name => 'google', :email => "john1@example.com")
  o.contacts.create!(:first_name => "Kyle",      :last_name => "Lawrence",    :organization_name => 'google', :email => "kyle@example.com")
  o.contacts.create!(:first_name => "Ayn",       :last_name => "Rand",        :organization_name => 'google', :email => "ayn@example.com")
  o.contacts.create!(:first_name => "Francisco", :last_name => "d'Anconia",   :organization_name => 'google', :email => "francisco@example.com")
  o.contacts.create!(:first_name => "Ragnar",    :last_name => "Danneskjold", :organization_name => 'google', :email => "ragnar@example.com")
  o.contacts.create!(:first_name => "Frank",     :last_name => "O'Connor",    :organization_name => 'google', :email => "frank@example.com")
  o.contacts.create!(:first_name => "Robert",    :last_name => "E. Howard",   :organization_name => 'google', :email => "robert@example.com")
}

# projects #
Project.destroy_all
user = User.last
org = user.own_organization
if  org
  15.times do |i|
    p = org.projects.create(:name => "project_#{i}",
      :status => Project::STATUSES.sample,
      :category_id => org.categories.collect(&:id).sample,
      :estimated_value => (100..5000).to_a.sample
      )

    rand(5).times do |i|
      type = Payment::STATUSES.sample
      completed = rand(10) > 5
      if type == "Fixed"
        p.payments.build(:rate => rand(30), :recurring => type, :completed => completed, :start_date => Date.today - (rand(10)-5).days)
      elsif type == "Hourly"
        p.payments.build(:rate => rand(30), :recurring => type, :number_of_hours => rand(30), :completed => completed, :start_date => Date.today - (rand(10)-5).days)
      elsif type == "Monthly"
        p.payments.build(:rate => rand(30), :recurring => type, :number_of_months => rand(12), :completed => completed, :start_date => Date.today - (rand(10)-5).days)
      end
    end
    p.save

    (0..5).to_a.sample.times do |i|
      p.notes.build(:text => "waka-waka", :user => user)
    end
    f = p.save
    puts "Error: #{p.errors.full_messages.join(',')}" unless f
  end
end

Plan.create!(name: "Unlimited", amount: 900, :max_users => 50, :max_projects => 50, :max_contacts => 50)

Plan.create(:name => 'Free', :max_users => 5, :max_projects => 5, :max_contacts => 5)
Plan.create(:name => 'Basic', :max_users => 10, :max_projects => 5, :max_contacts => 20)
Plan.create(:name => 'Advanced', :max_users => 20, :max_projects => 10, :max_contacts => 50)
Plan.create(:name => 'Pro', :max_users => 30, :max_projects => 20, :max_contacts => 100)
Plan.create(:name => 'Unlimited', :max_users => 0, :max_projects => 0, :max_contacts => 0)