class Category < ActiveRecord::Base

  ## associations ##
  belongs_to :organization
  has_many :projects

  ## validations ##
  validates :name, :color, :organization_id, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  ## options ##
  attr_accessible :name, :color, :organization_id

  ## named scopes ##
  scope :search_for, -> (term) { term = "%#{term.downcase}%"
    where(["LOWER(name) LIKE ?", term]) }

  ## methods ##
  def to_s
    name
  end

  class << self
    def colorname2color(color)
      clrs = {'blue'        =>  '#0054a6','light-blue'  =>  '#0074bd','cyan'        =>  '#0093bd',
      'sky-blue'    =>  '#00aef0','eggplant'    =>  '#00aef0','fuxia'       =>  '#00aef0',
      'purple'      =>  '#6500bd','red'         =>  '#f81d46','maroon'      =>  '#f81d46',
      'dark-green'  =>  '#00612d','light-green' =>  '#8dc73f','orange'      =>  '#f8941d',
      'brown'       =>  '#603913','gray'        =>  '#52616b','black'       =>  'black' }
      clrs[color]
    end

    def json_data(categories)
      categories.collect do |cat|
        { label: cat.name, category: 'Categories', desc: "projects: #{cat.projects.count}" }
      end
    end

  end

end
