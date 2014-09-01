class Response < ActiveRecord::Base
  belongs_to :question
  validates :response_text, :presence=>true, length: { maximum: 1 }

  after_create do |response|
    puts "The response was added to the database"
  end

  after_update do |response|
    puts "The reasponse was updated in the database"
  end

  after_destroy do |response|
    puts "The response was deleted from the database"
  end
end
