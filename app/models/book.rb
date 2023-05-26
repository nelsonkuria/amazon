class Book < ApplicationRecord
  # For more validations https://guides.rubyonrails.org/active_record_validations.html
  validates :author, presence: true, length: { minimum: 3 }
  validates :title, presence: true, length: { minimum: 3 }
end
