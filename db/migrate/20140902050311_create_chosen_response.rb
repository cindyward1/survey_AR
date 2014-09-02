class CreateChosenResponse < ActiveRecord::Migration
  def change
    create_table :chosen_responses do |t|
      t.integer :question_id
      t.integer :response_id
      t.timestamps
    end
  end
end
