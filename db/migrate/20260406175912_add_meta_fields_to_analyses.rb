class AddMetaFieldsToAnalyses < ActiveRecord::Migration[7.0]
  def change
    # Só cria se a coluna ainda não existir no banco
    add_column :analyses, :purchase_type, :string unless column_exists?(:analyses, :purchase_type)
    add_column :analyses, :conversion_location, :string unless column_exists?(:analyses, :conversion_location)
    add_column :analyses, :performance_goal, :string unless column_exists?(:analyses, :performance_goal)
  end
end
