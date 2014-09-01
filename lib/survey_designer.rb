class SurveyDesigner < ActiveRecord::Base
	has_many :surveys
	has_many :questions, through: :surveys
	validates :name, :presence=>true, :uniqueness=>true
end
