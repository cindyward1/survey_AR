class SurveyTaker < ActiveRecord::Base
  has_many :taken_surveys

  validates :name, :presence => true, :uniqueness => true, length: { maximum: 25 }

  after_create do |survey_taker|
    puts "Welcome, new survey taker #{self.name}"
  end

end
