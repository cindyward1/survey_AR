require "spec_helper"

describe Response do
  it { should belong_to :question }
  it { should validate_presence_of :response_text }
  it { should ensure_length_of(:response_text).is_at_most(1) }
end
