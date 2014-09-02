class TakenSurvey < ActiveRecord::Base
  belongs_to :survey_taker
  belongs_to :survey
  has_many :questions, through: :survey
  validates :date, :presence => true
end