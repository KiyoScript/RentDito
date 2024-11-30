import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="terms-and-condition"
export default class extends Controller {
  static targets = ['termsAndConditionField', 'submitButton', 'statusField'];

  enableSubmit() {
    const isChecked = this.termsAndConditionFieldTarget.checked;

    this.submitButtonTarget.disabled = !isChecked;

    this.statusFieldTarget.value = isChecked ? "unverified" : "incomplete";
    
  }
}
