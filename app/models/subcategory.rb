class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :operations, dependent: :restrict_with_error

  validates :name, presence: true
end
