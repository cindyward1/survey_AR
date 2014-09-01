class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :responses
  validates :question_text, :presence=>true, length: { maximum: 100 }

  after_create do |question|
    puts "The question was added to the database"
  end

  after_update do |question|
    puts "The question was updated in the database"
  end

  after_destroy do |question|
    puts "The question was deleted from the database"
  end
end
