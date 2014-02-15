class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :confirmable

    attr_accessor :organization_name
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :own_organization_attributes, :name, :avatar_url, :paymill_client_id

  has_many :membershipments
  has_many :organizations, :through => :membershipments
  has_one :own_organization, :foreign_key => 'admin_id', :class_name => 'Organization', :dependent => :destroy
  has_and_belongs_to_many :projects
  has_many :notes

  accepts_nested_attributes_for :own_organization
  validates_associated :own_organization

  after_create :ac_build_own_organization, :unless => :own_organization

  # devise confirm! method overriden
  def confirm!
    send_welcome_email
    super
  end


  def ac_build_own_organization
     self.build_own_organization(:name         => self.default_company_name,
                                 :admin_id     => self.id,
                                 :color_scheme => Organization.color_schemes.sample,
                                 :currency     => Organization.currencies.sample,
                                 :plan_id      => Plan.default_id)
  end

  def default_company_name
     email.match(/(.*)@/)[1] + ' organization'
  end

  def paymill_client!
    if self.paymill_client_id.blank?
      self.paymill_client_id =  ::Paymill::Client.create(email: self.email).id
      save!
      reload
    end
    @paymill_client ||= Paymill::Client.find(self.paymill_client_id)
  end

  private

    def send_welcome_email
      UserMailer.welcome_email(self).deliver
    end
end
