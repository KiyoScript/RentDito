import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

// Connects to data-controller="fetch-occupied-bedspaces"
export default class extends Controller {
  static targets = ["propertyUnitId", "propertyUnitName", "occupancy", "upperDeck", "lowerDeck"]

  async updateCard(event) {
    const propertyUnitId = event.target.dataset.propertyUnitId


    const request = new FetchRequest("get", `/dashboard/property_units/${propertyUnitId}/occupancy_data`, { responseKind: "json" })

    const response = await request.perform()

    if (response.ok) {
      const data = await response.json;
      this.propertyUnitIdTarget.href = `/dashboard/rooms?q%5Bproperty_unit_id_eq%5D=${data.property_unit_id}&amp;commit=Apply`
      this.propertyUnitNameTarget.textContent = `${data.property_address} - ${data.property_unit_name}`
      this.occupancyTarget.textContent = `${data.total_occupants} : ${data.total_bedspaces}`
      this.upperDeckTarget.textContent = `${data.total_upper_deck}`
      this.lowerDeckTarget.textContent = `${data.total_lower_deck}`
    }
  }
}
