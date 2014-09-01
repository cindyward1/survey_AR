class CreateSurveyDesigner < ActiveRecord::Migration
  def change
    create_table :survey_designers do |t|
    	t.string :name
    end

    add_column :surveys, :survey_designer_id, :integer
    
  end
end
