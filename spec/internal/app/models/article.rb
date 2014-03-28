class Article < ActiveRecord::Base
  scope :category, lambda { |category| where category: category }
end
