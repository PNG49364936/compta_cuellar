# Utilisateur administrateur
User.find_or_create_by!(email: "pngauthier@hotmail.fr") do |user|
  user.password = "Alba2023@@@"
  user.password_confirmation = "Alba2023@@@"
end

# Catégories de dépenses (débit)
piso = Category.find_or_create_by!(name: "Piso", operation_type: "debit")
%w[Comunidad Gas Agua Electricidad IBI Seguros Mantenimiento].each do |sub|
  piso.subcategories.find_or_create_by!(name: sub)
end
piso.subcategories.find_or_create_by!(name: "Otros gastos")

cochera = Category.find_or_create_by!(name: "Cochera", operation_type: "debit")
%w[Comunidad Agua Electricidad IBI Seguros Mantenimiento].each do |sub|
  cochera.subcategories.find_or_create_by!(name: sub)
end
cochera.subcategories.find_or_create_by!(name: "Otros gastos")

madre = Category.find_or_create_by!(name: "Madre", operation_type: "debit")
%w[Logopeda Peluquería Podólogo Bollos Begoña].each do |sub|
  madre.subcategories.find_or_create_by!(name: sub)
end
madre.subcategories.find_or_create_by!(name: "Otros gastos")

residencia = Category.find_or_create_by!(name: "Residencia", operation_type: "debit")
residencia.subcategories.find_or_create_by!(name: "Frais résidence")
residencia.subcategories.find_or_create_by!(name: "Otros gastos")

# Catégorie de revenus (crédit)
ingresos = Category.find_or_create_by!(name: "Ingresos", operation_type: "credit")
%w[Pensión Transferencias].each do |sub|
  ingresos.subcategories.find_or_create_by!(name: sub)
end
ingresos.subcategories.find_or_create_by!(name: "Otros ingresos")

puts "Seeds chargées avec succès !"
puts "- #{User.count} utilisateur(s)"
puts "- #{Category.count} catégorie(s)"
puts "- #{Subcategory.count} sous-catégorie(s)"
