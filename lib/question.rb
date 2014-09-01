class Question < ActiveRecord::Base
	belongs_to :survey
	has_many :responses
	validates :question_text, :presence=>true
end