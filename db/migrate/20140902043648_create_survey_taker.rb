class CreateSurveyTaker < ActiveRecord::Migration
  def change
    create_table :survey_takers do |t|
      t.string :name
      t.string :phone_number
      t.timestamps
    end
  end
end
