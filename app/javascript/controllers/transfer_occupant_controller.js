import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modalTrigger", "transferButton"];

  handleSubmit(event) {
    // Replace the modal trigger button with the loading spinner
    if (this.hasModalTriggerTarget) {
      const loadingButtonHTML = `
        <button class="btn btn-warning" type="button" style="border-radius: 0.375rem !important" disabled>
          <span class="spinner-border me-1" role="status" aria-hidden="true"></span>
          Loading...
        </button>
      `;
      this.modalTriggerTarget.outerHTML = loadingButtonHTML;
    } else {
      console.error("Modal trigger target not found.");
    }
  }
}
