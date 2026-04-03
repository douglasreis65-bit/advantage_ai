class AddProfileFieldsToAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :analyses, :website_url, :string
    add_column :analyses, :is_whatsapp_lead, :boolean
    add_column :analyses, :segment, :string
    add_column :analyses, :analysis_type, :string
  end
end
