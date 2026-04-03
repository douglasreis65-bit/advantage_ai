class AddBusinessProfileToAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_reference :analyses, :business_profile, null: false, foreign_key: true
  end
end
