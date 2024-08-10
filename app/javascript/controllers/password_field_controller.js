import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-field"
export default class extends Controller {
  static targets = ['password', 'passwordEye', 'passwordEyeSlash'];

  toggle() {
    const isPassword = this.passwordTarget.type === 'password';

    // Toggle the password field type
    this.passwordTarget.type = isPassword ? 'text' : 'password';

    // Toggle the visibility of icons
    this.passwordEyeTarget.classList.toggle('d-none', !isPassword);
    this.passwordEyeSlashTarget.classList.toggle('d-none', isPassword);
  }
}
