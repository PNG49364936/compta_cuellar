class Operation < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :observation, length: { maximum: 80 }

  default_scope { order(payment_date: :desc) }

  def signed_amount
    category.credit? ? amount : -amount
  end
end
