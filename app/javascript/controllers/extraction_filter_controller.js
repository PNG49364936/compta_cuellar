import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["allMonths", "month", "category", "subcategoryGroup", "subcategory", "allSubs"]

  // --- MOIS ---

  toggleAllMonths() {
    const allChecked = this.allMonthsTarget.checked
    this.monthTargets.forEach(cb => {
      cb.checked = false
      cb.disabled = allChecked
    })
  }

  onMonthChange() {
    const anyMonthChecked = this.monthTargets.some(cb => cb.checked)
    this.allMonthsTarget.checked = !anyMonthChecked
    this.monthTargets.forEach(cb => {
      cb.disabled = false
    })
  }

  // --- CATÉGORIES ---

  onCategoryChange(event) {
    const categoryId = event.target.dataset.categoryId
    const isChecked = event.target.checked

    // Afficher/masquer le bloc de sous-catégories
    const subGroup = this.subcategoryGroupTargets.find(
      el => el.dataset.categoryId === categoryId
    )
    if (subGroup) {
      subGroup.style.display = isChecked ? "flex" : "none"
    }

    // Si on décoche la catégorie, décocher toutes ses sous-catégories
    if (!isChecked) {
      this.subcategoryTargets
        .filter(cb => cb.dataset.categoryId === categoryId)
        .forEach(cb => { cb.checked = false; cb.disabled = false })

      // Recocher "Toutes les sous-catégories"
      const allSubsCb = this.allSubsTargets.find(
        cb => cb.dataset.categoryId === categoryId
      )
      if (allSubsCb) allSubsCb.checked = true
    }
  }

  // --- SOUS-CATÉGORIES ---

  toggleAllSubs(event) {
    const categoryId = event.target.dataset.categoryId
    const allChecked = event.target.checked

    this.subcategoryTargets
      .filter(cb => cb.dataset.categoryId === categoryId)
      .forEach(cb => {
        cb.checked = false
        cb.disabled = allChecked
      })
  }

  onSubcategoryChange(event) {
    const categoryId = event.target.dataset.categoryId
    const subs = this.subcategoryTargets.filter(cb => cb.dataset.categoryId === categoryId)
    const anySubChecked = subs.some(cb => cb.checked)

    const allSubsCb = this.allSubsTargets.find(
      cb => cb.dataset.categoryId === categoryId
    )
    if (allSubsCb) {
      allSubsCb.checked = !anySubChecked
    }

    subs.forEach(cb => { cb.disabled = false })
  }
}
