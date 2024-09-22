import { Controller } from "@hotwired/stimulus"

// Connects to data-controller='form-validation-validation'
export default class extends Controller {
  static targets = [
    'firstname',
    'lastname',
    'email',
    'phoneNumber',
    'password',
    'passwordConfirmation',
    'gender',
    'genderMale',
    'genderFemale',
    'property',
    'propertyCode',
    'room',
    'deck',
    'checkIn'
  ]

  connect() {
    this.form = this.element
    document.addEventListener('turbo:load', () => {
      this.initializeCleave()
      this.form.addEventListener('submit', (event) => {
        if (!this.validateForm()) {
          event.preventDefault()
        }
      })
    })
  }

  initializeCleave() {
    new Cleave(this.phoneNumberTarget, {
      blocks: [4, 3, 4],
      numericOnly: true
    })
  }

  validateForm() {
    let valid = true

    if (!this.firstnameTarget.value.trim()) {
      this.showError(this.firstnameTarget, "First name is required.")
      valid = false
    } else {
      this.clearError(this.firstnameTarget)
    }

    if (!this.lastnameTarget.value.trim()) {
      this.showError(this.lastnameTarget, "Last name is required.")
      valid = false
    } else {
      this.clearError(this.lastnameTarget)
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(this.emailTarget.value.trim())) {
      this.showError(this.emailTarget, "Valid email is required.")
      valid = false
    } else {
      this.clearError(this.emailTarget)
    }

    if (!this.phoneNumberTarget.value.trim()) {
      this.showError(this.phoneNumberTarget, "Phone number is required.")
      valid = false
    } else {
      this.clearError(this.phoneNumberTarget)
    }

    if (!this.genderMaleTarget.checked && !this.genderFemaleTarget.checked) {
      this.showError(this.genderTarget, "Please select a gender.")
      valid = false
    }

    if (!this.propertyTarget.value.trim()) {
      this.showError(this.propertyTarget, "Please select a property.")
      valid = false
    } else {
      this.clearError(this.propertyTarget)
    }

    if (!this.propertyCodeTarget.value.trim()){
      this.showError(this.propertyCodeTarget, "Please select a property code.")
      valid = false
    } else {
      this.clearError(this.propertyCodeTarget)
    }

    if (!this.roomTarget.value.trim()){
      this.showError(this.roomTarget, "Please select a room.")
      valid = false
    } else {
      this.clearError(this.roomTarget)
    }

    if (!this.deckTarget.value.trim()){
      this.showError(this.deckTarget, "Please select a deck.")
      valid = false
    } else {
      this.clearError(this.deckTarget)
    }

    if (this.passwordTarget.value.trim().length < 8) {
      this.showError(this.passwordTarget, "Password must be at least 8 characters long.")
      valid = false
    } else {
      this.clearError(this.passwordTarget)
    }

    if (this.passwordTarget.value !== this.passwordConfirmationTarget.value) {
      this.showError(this.passwordConfirmationTarget, "Passwords do not match.")
      valid = false
    } else {
      this.clearError(this.passwordConfirmationTarget)
    }


    return valid
  }

  showError(target, message) {
    const errorDiv = target.closest('.form-group').querySelector('.error-message')
    if (errorDiv) {
      errorDiv.textContent = message
    } else {
      const errorMessage = document.createElement('div')
      errorMessage.classList.add('text-danger', 'error-message')
      errorMessage.textContent = message
      target.closest('.form-group').appendChild(errorMessage)
    }
    target.classList.add('is-invalid')
  }

  clearError(target) {
    const errorDiv = target.closest('.form-group').querySelector('.error-message')
    if (errorDiv) {
      errorDiv.remove()
    }
    target.classList.remove('is-invalid')
  }
}
