import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

// Connects to data-controller="user-status"
export default class extends Controller {
  static targets = ["dropdownItem", "statusLabel"];

  connect() {
    this.statusLabel = this.statusLabelTarget;
  }

  async updateStatus(event) {
    const selectedStatus = event.target.dataset.userStatusStatus;
    const userId = this.data.get("userId");



    console.log(event.target)
    const request = new FetchRequest('patch', `/profile/${userId}/update_status`, {
      body: JSON.stringify({ name: 'Request.JS', status: selectedStatus }),
      headers: { "Content-Type": "application/json" }
    });

    try {
      const response = await request.perform();
      if (response.ok) {
        const data = await response.json
        window.location.reload();
        this.statusLabel.textContent = data.status;
      } else {
        console.error("Failed to update status:", response);
      }
    } catch (error) {
      console.error("There was a problem with the fetch operation:", error);
    }
  }
}
