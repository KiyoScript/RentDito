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

    const dropdownMenu = event.target.closest("div").querySelector(".dropdown-menu");
    if (dropdownMenu) {
      // Remove the "show" class from the dropdown menu
      dropdownMenu.classList.remove("show");
    }

    // Find the button to replace it with a loading spinner
    const button = event.target.closest("div").querySelector("button");
    if (!button) return;

    // Save the original button content
    const originalButtonContent = button.innerHTML;

    // Replace button content with a loading spinner
    button.innerHTML = `
      <span class="spinner-border me-2" role="status" aria-hidden="true"></span>
      Loading...&nbsp;<i class='bx bx-chevron-down'></i>
    `;
    button.disabled = true;

    const request = new FetchRequest("patch", `/profile/${userId}/update_status`, {
      body: JSON.stringify({ name: "Request.JS", status: selectedStatus }),
      headers: { "Content-Type": "application/json" },
    });

    try {
      const response = await request.perform();
      if (response.ok) {
        const data = await response.json;
        // Update the status label
        this.statusLabel.textContent = data.status;

        // Reload the page to reflect the new status
        window.location.reload();
      } else {
        console.error("Failed to update status:", response);
        // Restore original button content on failure
        button.innerHTML = originalButtonContent;
        button.disabled = false;
      }
    } catch (error) {
      console.error("There was a problem with the fetch operation:", error);
      // Restore original button content on error
      button.innerHTML = originalButtonContent;
      button.disabled = false;
    }
  }
}
