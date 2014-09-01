class CreateSurvey < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
    	t.string :name
    	t.date :date_created
    	t.timestamps
    end
  end
end
