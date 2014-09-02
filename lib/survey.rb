class Survey < ActiveRecord::Base
  scope :taken, -> { where(taken: true) }

  belongs_to :survey_designer
  has_many :questions
  has_many :responses, through: :questions
  has_many :taken_surveys
  
  validates :name, :presence => true, :uniqueness => true, length: { maximum: 25 }

  after_create do |survey|
    puts "The survey #{self.name} was added to the database"
  end

  after_update do |survey|
    puts "The name of the survey was changed to #{self.name}"
  end

  after_destroy do |survey|
    puts "The survey was deleted from the database"
  end
end
