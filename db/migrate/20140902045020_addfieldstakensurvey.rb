class Addfieldstakensurvey < ActiveRecord::Migration
  def change
    add_column :taken_surveys, :date, :datetime
    add_column :taken_surveys, :survey_id, :integer
    add_column :taken_surveys, :survey_taker_id, :integer
    add_column :taken_surveys, :created_at, :datetime
    add_column :taken_surveys, :updated_at, :datetime
  end
end
