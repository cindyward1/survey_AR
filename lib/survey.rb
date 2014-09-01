class Survey < ActiveRecord::Base
	belongs_to :survey_designer
	has_many :questions
	has_many :responses, through: :questions
	validates :name, :presence=>true, :uniqueness=>true
end
