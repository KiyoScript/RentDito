import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="deposit-form"
export default class extends Controller {
  closeModal(event) {
    if (event.detail.success) {
      const modal = document.getElementById("depositModal");
      const bootstrapModal = bootstrap.Modal.getInstance(modal);
      bootstrapModal.hide();
      window.location.reload();
    }
  }
}
