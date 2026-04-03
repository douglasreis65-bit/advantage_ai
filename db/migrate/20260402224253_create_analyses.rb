class CreateAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :analyses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :business_name
      t.string :business_platform
      t.string :product_category
      t.string :campaign_objective
      t.date :target_date
      t.integer :events_page_views
      t.integer :events_view_content
      t.integer :events_add_to_cart
      t.integer :events_initiate_checkout
      t.integer :events_purchase
      t.string :public_token
      t.text :ai_diagnostic

      t.timestamps
    end
    add_index :analyses, :public_token
  end
end
