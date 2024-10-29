import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

// Connects to data-controller="fetch-occupied-bedspaces"
export default class extends Controller {
  static targets = ["propertyId", "propertyName", "occupancy", "upperDeck", "lowerDeck"]

  async updateCard(event) {


    const propertyId = event.target.dataset.propertyId;
    const request = new FetchRequest("get", `/dashboard/properties/${propertyId}/occupancy_data`, { responseKind: "json" });


    const response = await request.perform();

    if (response.ok) {
      const data = await response.json;
      this.propertyIdTarget.href = `/dashboard/rooms?q%5Bproperty_id_eq%5D=${data.property_id}&amp;commit=Apply`
      this.propertyNameTarget.textContent = data.property_name;
      this.occupancyTarget.textContent = `${data.total_occupants}/${data.total_bedspaces}`;
      this.upperDeckTarget.textContent = `${data.total_upper_deck}`;
      this.lowerDeckTarget.textContent = `${data.total_lower_deck}`;
    }
  }
}
