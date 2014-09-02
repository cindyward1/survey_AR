class SurveyDesigner < ActiveRecord::Base
  has_many :surveys
  has_many :questions, through: :surveys
  validates :name, :presence => true, :uniqueness => true, length: { maximum: 25 }

  after_create do |designer|
    puts "Welcome, new designer #{self.name}"
  end

  after_find do |designer|
    puts "Welcome back, #{self.name}"
  end
end
