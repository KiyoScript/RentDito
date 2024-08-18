import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash-messages"
export default class extends Controller {
  connect() {
    const noticeMessage = this.element.dataset.notice;
    const alertMessage = this.element.dataset.alert;

    if (noticeMessage) {
      toastr.success(noticeMessage);
    }

    if (alertMessage) {
      toastr.error(alertMessage);
    }
  }
}
