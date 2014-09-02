require "spec_helper"

describe ChosenResponse do
  it { should belong_to :question }
  it { should belong_to :response }
end
