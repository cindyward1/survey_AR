require "spec_helper"

describe Survey do
	it "requires a name to be saved to the database" do
		test_survey = Survey.new(:name=>"")
		expect(test_survey.save).to eq false
	end

it "has many questions" do
		test_survey = Survey.create(:name=>"test survey")
		test_question1 = Question.create(:question_text=>"question text 1", :survey_id=>test_survey.id)
		test_question2 = Question.create(:question_text=>"question text 2", :survey_id=>test_survey.id)
		expect(test_survey.questions).to eq [test_question1, test_question2]
	end

end