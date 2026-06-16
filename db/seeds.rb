categories = [ "Roupas", "Eletronicos", "Livros", "Moveis", "Esportes", "Brinquedos", "Outros" ]
categories.each { |name| Category.find_or_create_by!(name: name) }
