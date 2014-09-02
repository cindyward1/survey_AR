require "spec_helper"

describe TakenSurvey do
  it { should belong_to :survey_taker }
  it { should belong_to :survey }
  it { should have_many :questions }
  it { should validate_presence_of :date }
end
