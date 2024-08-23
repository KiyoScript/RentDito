import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["propertyUnit"]

  connect(){
    const propertyUnitSelect = this.element.querySelector("[name='room[property_unit_id]']")
    propertyUnitSelect.classList.add("form-select")
  }

  loadPropertyUnits(event) {
    const propertyId = event.target.value

    if (propertyId) {
      fetch(`/dashboard/properties/${propertyId}/property_units`)
        .then(response => response.json())
        .then(data => {
          this.updatePropertyUnits(data)
        })
        .catch(error => {
          console.error("Error fetching property units:", error)
        })
    } else {
      this.clearPropertyUnits()
    }
  }

  updatePropertyUnits(propertyUnits) {
    const propertyUnitSelect = this.element.querySelector("[name='room[property_unit_id]']")

    if (propertyUnitSelect) {
      propertyUnitSelect.innerHTML = "<option value=''>Choose Property Unit</option>"

      if (propertyUnits.length > 0) {
        propertyUnits.forEach((unit, index) => {
          const option = document.createElement("option")
          option.value = unit.id
          option.textContent = unit.name
          if (index === 0) {
            option.selected = true
          }
          propertyUnitSelect.appendChild(option)
        })
      }
    }
  }

  clearPropertyUnits() {
    const propertyUnitSelect = this.element.querySelector("[name='room[property_unit_id]']")
    if (propertyUnitSelect) {
      propertyUnitSelect.innerHTML = "<option value=''>Choose Property Unit</option>"
    }
  }
}
