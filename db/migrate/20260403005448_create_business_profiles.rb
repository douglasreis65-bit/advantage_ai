class CreateBusinessProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :business_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :segment
      t.string :platform
      t.string :website_url
      t.boolean :is_whatsapp_lead

      t.timestamps
    end
  end
end
