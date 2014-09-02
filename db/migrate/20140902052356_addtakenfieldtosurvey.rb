class Addtakenfieldtosurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :taken, :boolean
  end
end
