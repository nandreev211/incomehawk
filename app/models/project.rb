class Project < ActiveRecord::Base
  ## Extensions ##

  ## fields ##
  STATUSES = ["Active", "Prospective", "Lost", "Completed"]
  MAX_LIMIT = 5
  attr_accessor :contact

  ## associations ##
  belongs_to :organization
  belongs_to :category
  has_and_belongs_to_many :user
  has_many :payments, dependent: :destroy, :order => "start_date DESC"
  has_many :membershipments
  has_many :members, through: :membershipments, :class_name => "User"
  has_many :notes, order: "created_at DESC"
  has_and_belongs_to_many :contacts

  accepts_nested_attributes_for :payments
  delegate :plan_id, :plan, to: :organization

  ## callbacks ##

  ## validations ##
  validates :name, :organization, :status, :category_id, presence: true
  validate :category_id_non_zero
  validates :status, inclusion: { in: STATUSES }
  validate :plan_limits, on: :create

  def plan_limits
    o = organization
    if o.plan_id.present?
      if o.projects.count >= plan.max_projects && plan.max_projects > 0
        errors.add(:plan_limit, "You have reached limit of projects for your plan(#{plan.max_projects}). <a href='#'>Upgrade?</a>")
      end
    end
  end

  ## named scopes ##
  STATUSES.each do |status|
    define_singleton_method status.downcase do
      where("status = '#{status}'")
    end
  end
  scope :recent, lambda {|n| order('created_at DESC').limit(n)}
  scope :search_for, lambda {|term| term = "%#{term.downcase}%"
  where(["LOWER(name) LIKE ? OR LOWER(description) LIKE ? OR LOWER(status) LIKE ?", term, term, term]) }


  ## methods ##
  def payment
    payments.build
  end

  STATUSES.each do |st|
    define_method st.downcase+"?" do
      self.status == st
    end
  end

  def estimated
    if active? || completed?
      payments.collect(&:total_value).sum
    else
      estimated_value
    end
  end

  def estimated_value
    self.attributes['estimated_value'] || 0
  end

  def billed
    payments.collect(&:billed_value).sum
  end

  def remaining
    payments.collect(&:remaining_value).sum
  end

  def payment_progress
    unless estimated == 0
      ((billed / estimated)*100).to_i
    else
      0
    end
  end

  def update_status(nstatus, update_payments = false)
    if nstatus == "Prospective" || nstatus == "Lost"
      self.estimated_value = estimated
    elsif nstatus == "Completed"
      if update_payments
        payments.each {|p|
          p.completed = true
          p.save!
        }
      end
    end
    self.status = nstatus
    save!
  end

  def self_errors
    errors.delete(:organization)
    errors
  end

  class << self
    include Rails.application.routes.url_helpers

    def json_data(projects)
      projects.collect{|x|
        {:label => x.name, :category => 'Projects', :desc => x.status, :href => project_path( x)}
      }
    end

    def demo_projects
      where(['projects.demo = ?', TRUE])
      .order('start_date ASC')
    end
  end


  private

  def category_id_non_zero
    if category_id == 0
      errors.add :base, "Can't create project without category"
      false
    end
  end

end