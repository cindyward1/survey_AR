require "spec_helper"

describe Question do
  it { should belong_to :survey}
  it { should have_many :responses }
  it { should validate_presence_of :question_text }
  it { should ensure_length_of(:question_text).is_at_most(100) }
end
