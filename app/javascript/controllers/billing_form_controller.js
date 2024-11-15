import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["electricity", "water", "wifi", "billingType"]

  displayFrame(event) {
    const billingType = event.target.value

    this.electricityTarget.classList.add("d-none")
    this.waterTarget.classList.add("d-none")
    this.wifiTarget.classList.add("d-none")


    if (billingType === "electricity") {
      this.electricityTarget.classList.remove("d-none")
      this.billingTypeTarget.value = "electricity"
    } else if (billingType === "water") {
      this.waterTarget.classList.remove("d-none")
      this.billingTypeTarget.value = "water"
    } else if (billingType === "wifi") {
      this.wifiTarget.classList.remove("d-none")
      this.billingTypeTarget.value = "wifi"
    }
  }
}
