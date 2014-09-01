class CreateResponse < ActiveRecord::Migration
  def change
    create_table :responses do |t|
    	t.string :response_text
    	t.integer :question_id
    	t.timestamps
    end
  end
end
