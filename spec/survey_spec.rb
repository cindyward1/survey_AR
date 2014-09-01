require "spec_helper"

describe Survey do
	it { should belong_to :survey_designer}
	it { should have_many :questions }
	it { should have_many :responses }
	it { should validate_presence_of :name }
	it { should validate_uniqueness_of :name }
	it { should ensure_length_of(:name).is_at_most(25) }
end
