class AddRoasDetectedToAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :analyses, :roas_detected, :float
  end
end
