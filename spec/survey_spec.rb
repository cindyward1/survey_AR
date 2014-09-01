require "spec_helper"

describe Survey do
	it "requires a name to be saved to the database" do
		test_survey = Survey.new(:name=>"")
		expect(test_survey.save).to eq false
	end
end