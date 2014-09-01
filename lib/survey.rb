class Survey < ActiveRecord::Base
	validates :name, :presence=>true
end