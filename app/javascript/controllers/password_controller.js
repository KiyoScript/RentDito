import { Controller } from '@hotwired/stimulus'

// Connects to data-controller='password'
export default class extends Controller {
  static targets = ['password', 'passwordConfirmation'];

  generatePassword() {
    const password = this.randomPassword();
    this.passwordTarget.value = password;
    this.passwordConfirmationTarget.value = password;
  }

  randomPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()';
    let password = '';
    for (let i = 0; i < 12; i++) {
      password += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return password;
  }
}
