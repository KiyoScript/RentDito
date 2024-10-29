import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

// Connects to data-controller="deactivate-account"
export default class extends Controller {
  static targets = [
    'checkBoxField',
    'errorMessage',
    'submitButton'
  ]

  enableButton(){
    const errorMessage = this.errorMessageTarget
    const checkBox = this.checkBoxFieldTarget
    const submitButton = this.submitButtonTarget


    if (checkBox.checked){
      submitButton.disabled = false;
      if (!errorMessage.classList.contains('d-none')){
        errorMessage.classList.add('d-none')
        checkBox.classList.remove('is-invalid')
      }
    } else {
      submitButton.disabled = true;
      checkBox.classList.add('is-invalid')
      errorMessage.classList.remove('d-none')
    }
  }

  async updateStatus() {
    const userId = this.element.dataset.deactivateAccountUserId
    console.log(userId)
    const request = new FetchRequest('PATCH', `/profile/${userId}/update_status`, {
      body: JSON.stringify({ status: 'deactivated' }),
      headers: { "Content-Type": "application/json" }
    });

    try {
      const response = await request.perform();
      if (response.ok) {
        await response.json
        window.location.reload();
      } else {
        console.error("Failed to deactivate account:", response);
      }
    } catch (error) {
      console.error("Error in account deactivation request:", error);
    }
  }
}
