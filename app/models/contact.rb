class Contact < ActiveRecord::Base

  has_attached_file :avatar,
                    :styles => { :medium => "150x100>", :thumb => "97x53" },
                    :storage => :s3,
                    :s3_credentials => {
                        :bucket => 'incomeHawk',
                        :access_key_id => 'AKIAI4KKOYIC5NJZ2PDQ',
                        :secret_access_key => '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'
                    }

  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'application/octet-stream']
  validates_attachment_size :avatar, less_than: 500.kilobytes
  attr_accessor :tmp_upload

  ## associations ##
  belongs_to :organization
  has_and_belongs_to_many :projects, include: [:payments, :category]

  ## callbacks ##

  ## validations ##
  validates :email, uniqueness: { scope: :organization_id }, if: -> x { !x.email.blank? }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  validate :plan_limits, on: :create
  validate :any_info
  delegate :plan_id, :plan, to: :organization

  def any_info
    unless [first_name, last_name, organization_name].any?{|x| !x.blank?}
      errors.add(:base, "Please provide any information about contact")
    end
  end

  def plan_limits
    o = organization
    if o.plan_id.present?
      if o.contacts.count >= plan.max_contacts && plan.max_contacts > 0
        errors.add(:plan_limit, "You have reached limit of contacts for your plan(#{plan.max_contacts}). <a href='#'>Upgrade?</a>")
      end
    end
  end

  ## named scopes ##
  scope :search_for, lambda {|term|
    term = "%#{term.downcase}%"
    where(["LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(email) LIKE ?", term, term, term]) }

  ## methods ##
  def name
    if organization_name && !organization_name.blank?
      if fl_name.blank?
        organization_name
      else
        "#{organization_name} (#{fl_name})"
      end
    else
      fl_name
    end
  end

  def fl_name
    [first_name, last_name].reject(&:blank?).join(', ')
  end

  def name=(text)
    first_name, last_name = text.split(' ')
  end

  def summary
    "#{name} (#{email})"
  end

  def no_address
    [address_1, address_2, city, zip, country].each {|f|
      return false if !f.nil? && !f.blank?
    }
    return true
  end

  def address_full
    return if no_address
    i = 0
    html = ''
    [address_1, address_2, city, zip, country].each {|f|
      if !f.nil? && !f.blank?
        if i > 0
          html <<=if i % 2 == 0
                    "<br/>"
                  else
                    ', '
                  end
        end
        html << f
        i += 1
      end
    }
    return html
  end

  def self_errors
    errors.delete(:organization)
    errors
  end

  class << self
    include Rails.application.routes.url_helpers

    def json_data(contacts)
      contacts.collect{|x|
        {:label => x.name, :category => 'Contacts', :desc => x.email, :href => contact_path( x)}
      }
    end

    def demo_contacts
      where(['contacts.demo = ?', TRUE])
    end
  end

end