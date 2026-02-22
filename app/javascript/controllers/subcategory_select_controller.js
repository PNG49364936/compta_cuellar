import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["category", "subcategory"]

  loadSubcategories() {
    const categoryId = this.categoryTarget.value
    const subcategorySelect = this.subcategoryTarget

    if (!categoryId) {
      subcategorySelect.innerHTML = '<option value="">Sélectionner une sous-catégorie</option>'
      return
    }

    fetch(`/subcategories_for_category/${categoryId}`)
      .then(response => response.json())
      .then(data => {
        let options = '<option value="">Sélectionner une sous-catégorie</option>'
        data.forEach(sub => {
          options += `<option value="${sub.id}">${sub.name}</option>`
        })
        subcategorySelect.innerHTML = options
      })
  }
}
