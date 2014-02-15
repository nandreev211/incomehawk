class Feedback
  include ActiveModel::Validations

  attr_accessor :email
  attr_accessor :phone
  attr_accessor :name
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :subject
  attr_accessor :body

  validates :email, format: { :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i }
  validates :email, :subject, :body, presence: true

  def initialize(data = nil)
    data.each do |k,v|
      self.send("#{k}=", v)
    end if data
  end

  def to_key
    [""]
  end

end

