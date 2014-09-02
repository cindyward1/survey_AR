class Addlettertoresponse < ActiveRecord::Migration
  def change
    add_column :responses, :response_letter, :string
  end
end
