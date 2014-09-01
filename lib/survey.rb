class Survey < ActiveRecord::Base
	has_many :questions
	validates :name, :presence=>true
end