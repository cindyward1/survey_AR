require "spec_helper"

describe Question do
	it "requires question text to be saved to the database" do
		test_question = Question.new(:question_text=>"")
		expect(test_question.save).to eq false
	end
end