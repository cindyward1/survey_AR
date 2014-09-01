class Addtimestamptosurveydesigner < ActiveRecord::Migration
  def change
    add_column :survey_designers, :created_at, :datetime
    add_column :survey_designers, :updated_at, :datetime
  end
end
