require "spec_helper"

require "spec_helper"

describe Survey do
	it { should have_many :questions }
	it { should have_many :responses }
	it { should validate_presence_of :name }
	it { should validate_uniqueness_of :name}
end