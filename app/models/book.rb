class Book < ApplicationRecord
  # For more validations https://guides.rubyonrails.org/active_record_validations.html
  validates :title, presence: true, length: { minimum: 3 }

  belongs_to :author
end
