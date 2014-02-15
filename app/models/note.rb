class Note < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  delegate :organization, to: :project

  validates :project, :user, presence: true
end
