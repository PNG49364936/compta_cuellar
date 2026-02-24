class ExportsController < ApplicationController
  require "csv"

  def csv
    operations = Operation.unscoped.includes(:category, :subcategory).order(payment_date: :asc)

    csv_data = CSV.generate(col_sep: ";", encoding: "UTF-8") do |csv|
      csv << ["Date", "Catégorie", "Type", "Sous-catégorie", "Montant", "Montant signé", "Observation"]

      operations.each do |op|
        csv << [
          op.payment_date.strftime("%d/%m/%Y"),
          op.category.name,
          op.category.debit? ? "Débit" : "Crédit",
          op.subcategory.name,
          op.amount.to_s.gsub(".", ","),
          op.signed_amount.to_s.gsub(".", ","),
          op.observation
        ]
      end
    end

    send_data "\xEF\xBB\xBF" + csv_data,
              filename: "home_compta_operations.csv",
              type: "text/csv; charset=utf-8",
              disposition: "attachment"
  end
end
