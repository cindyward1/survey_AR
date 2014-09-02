require "spec_helper"

describe SurveyTaker do
  it { should have_many :taken_surveys }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name}
  it { should ensure_length_of(:name).is_at_most(25) }
end
