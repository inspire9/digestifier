ActiveRecord::Schema.define do
  create_table :articles, :force => true do |table|
    table.string :name
    table.string :category
    table.timestamps null: false
  end

  create_table :books, :force => true do |table|
    table.string :title
    table.timestamps null: false
  end

  create_table :users, :force => true do |table|
    table.string :email
    table.timestamps null: false
  end
end
