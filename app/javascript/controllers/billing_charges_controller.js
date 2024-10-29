import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="billing-charges"
export default class extends Controller {
  static targets = [
    'extraChargeAmount',
    'electricityShareAmount',
    'waterShareAmount',
    'wifiShareAmount',
    'monthlyRentalAmount',
    'totalAmount'
  ]


  calculateTotal() {
    const extraCharge = parseFloat(this.extraChargeAmountTarget.value) || 0;
    const electricityShare = parseFloat(this.electricityShareAmountTarget.value) || 0;
    const waterShare = parseFloat(this.waterShareAmountTarget.value) || 0;
    const wifiShare = parseFloat(this.wifiShareAmountTarget.value) || 0;
    const monthlyRental = parseFloat(this.monthlyRentalAmountTarget.value) || 0;

    const total = extraCharge + electricityShare + waterShare + wifiShare + monthlyRental;

    this.totalAmountTarget.value = total.toFixed(2);
  }

  hideModal(event) {
    if (event.detail.success) {
      const modal = this.element;
      const bootstrapModal = bootstrap.Modal.getInstance(modal);
      if (bootstrapModal) {
        bootstrapModal.hide();
        window.location.reload();
      }
    }
  }
}
