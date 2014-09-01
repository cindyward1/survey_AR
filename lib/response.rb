class Response < ActiveRecord::Base
	belongs_to :question
	validates :response_text, :presence=>true
end
