require "spec_helper"

describe SurveyDesigner do
	it { should have_many :surveys }
	it { should have_many :questions }
	it { should validate_presence_of :name }
	it { should validate_uniqueness_of :name}
end
