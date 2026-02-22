class Category < ApplicationRecord
  has_many :subcategories, dependent: :restrict_with_error
  has_many :operations, dependent: :restrict_with_error

  validates :name, presence: true
  validates :operation_type, presence: true, inclusion: { in: %w[debit credit] }

  scope :debits, -> { where(operation_type: "debit") }
  scope :credits, -> { where(operation_type: "credit") }

  def debit?
    operation_type == "debit"
  end

  def credit?
    operation_type == "credit"
  end
end
