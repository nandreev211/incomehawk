class Organization < ActiveRecord::Base
  scope :recent, lambda {|n| order('created_at DESC').limit(n)}

  belongs_to :admin, class_name: 'User', dependent: :destroy
  belongs_to :plan
  has_many :membershipments
  has_many :members, through: :membershipments, class_name: 'User'
  has_many :projects, order: 'created_at DESC', :dependent => :destroy
  has_many :payments, through: :projects, include: { project: [:category, :organization] }
  has_many :contacts, order: 'first_name, last_name DESC', :dependent => :destroy
  has_many :categories, :dependent => :destroy

  #validates :name, :color_scheme, :currency, :plan, :admin, presence: true
  #validates :url, uniqueness: true, :unless => lambda {|o| o.url.blank?}

  validates_presence_of :name, :currency
  validates_uniqueness_of :url, :unless => lambda {|o| o.url.blank?}

  attr_accessible :name, :url, :currency, :plan_id
  attr_accessible :name, :url, :currency, :plan_id, :admin_id, :as => :admin

  before_create :set_default_plan
  after_create :create_demo_projects

  def set_default_plan
    self.plan_id = Plan.default_id if self.plan_id.nil? || self.plan_id == 0
  end

  def create_demo_projects
    #create default categories
    cat_web = categories.create!(:name => "Website Design", :color => '#0000cc')
    cat_dev = categories.create!(:name => "Development", :color => '#cc2222')
    cat_log = categories.create!(:name => "Logo Design", :color => '#22aa22')

    #create default contacts
    con_apple = contacts.create!(:first_name => "Steve", :last_name => "Jobs", :organization_name => 'Apple', :email => "steve@apple.com", :demo => TRUE)
    con_google = contacts.create!(:first_name => "Carolyn", :last_name => "Morrison", :organization_name => 'Google', :email => "info@fakegoogle.com", :website => "www.fakegoogle.com", :demo => TRUE)
    con_micro = contacts.create!(:first_name => "Kimberly", :last_name => "Foster", :organization_name => 'Micro Tech', :email => "kim@microtech.fake", :demo => TRUE)

    pro_first = projects.create(:name => "My First Project",
                                :status => "Active",
                                :category_id => categories.collect(&:id)[0],
                                :description => "An example project that's shows the different types of payments",
                                :demo => TRUE
    )

    pro_first.payments.build(:rate => 20, :recurring => "Monthly", :completed => FALSE, :start_date => (Date.today + 2.months).end_of_month, :number_of_months => rand(6)+1, :description => "Hosting")
    pro_first.payments.build(:rate => 20, :recurring => "Monthly", :completed => FALSE, :start_date => (Date.today + 1.months).end_of_month, :number_of_months => rand(6)+1, :description => "Hosting")
    pro_first.payments.build(:rate => 50, :recurring => "Hourly", :completed => FALSE, :start_date => (Date.today + rand(20).days), :number_of_hours => rand(30)+1, :description => "Updates")
    pro_first.payments.build(:rate => 20, :recurring => "Monthly", :completed => FALSE, :start_date => Date.today.end_of_month, :number_of_months => rand(5)+1, :description => "Hosting")
    pro_first.payments.build(:rate => 5000, :recurring => "Fixed", :completed => FALSE, :start_date => Date.today + rand(5).days, :description => "Development Completed")
    pro_first.payments.build(:rate => 1000, :recurring => "Fixed", :completed => FALSE, :start_date => Date.today - rand(30).days, :description => "Design Completed")
    pro_first.payments.build(:rate => 1000, :recurring => "Fixed", :completed => TRUE, :start_date => Date.today.beginning_of_month, :description => "Down Payment", :billed_at => Date.today)

    pro_first.contacts << con_google
    pro_first.save

    pro_second = projects.create(:name => "Apple Redesign",
                                 :status => "Lost",
                                 :category_id => categories.collect(&:id)[2],
                                 :description => "Redesign Apple logo",
                                 :demo => TRUE,
                                 :estimated_value => 10000
    )

    pro_second.notes.build(:text => "Didn't work out.", :user => admin)
    pro_second.contacts << con_apple
    pro_second.save

    pro_third = projects.create(:name => "Micro Tech",
                                :status => "Completed",
                                :category_id => categories.collect(&:id)[0],
                                :description => "Design website for micro tech",
                                :demo => TRUE
    )

    pro_third.payments.build(:rate => 2500, :recurring => "Fixed", :completed => TRUE, :start_date => Date.today.beginning_of_month, :completed_date => Date.today.beginning_of_month, :description => "Website Design", :billed_at => Date.today)

    pro_third.contacts << con_micro
    pro_third.save

    pro_fourth = projects.create(:name => "Sim crop",
                                 :status => "Prospective",
                                 :category_id => categories.collect(&:id)[1],
                                 :description => "Build Sim Corp website",
                                 :demo => TRUE,
                                 :estimated_value => 500
    )

    pro_fourth.contacts << con_google
    pro_fourth.save

  end

  def demo_projects
    projects.demo_projects.to_a
  end

  def demo_contacts
    contacts.demo_contacts.to_a
  end

  def currency_symbol
    self.class.currency_symbol(self.currency)
  end

  def categories_list
    tmp = self.categories.collect(&[:name, :id])
    #['Select project category', 'Add/Edit Categories'] + tmp
    ['Add/Edit Categories'] + tmp
  end

  def contacts_list
    tmp = self.contacts.sort_by{|x| x.name.downcase[0]}.collect(&[:name, :id])
    ['Create New Contact'] + tmp
  end

  def this_month_payments(year, month)
    payments.this_month_payments(year, month).to_a
  end

  def next_month_payments(year, month)
    payments.next_month_payments(year, month).to_a
  end

  def last_5_months_payments(year, month)
    payments.last_5_months_payments(year, month).to_a
  end

  class << self
    def color_schemes
      ["Black", "Red", "Blue", "Green"]
    end

    def currencies
      ["USD", "Pounds", "Euro", "Shekel"]
    end

    def currency_symbol(currency)
      currencies = {
          "USD" => "$",
          "Euro" => '&euro;',
          "Pounds" => "&pound;",
          "Shekel" => '&#8362;'
      }
      currencies[currency]
    end
  end
end