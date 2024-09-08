import { Controller } from "@hotwired/stimulus";
import SignaturePad from "signature_pad";

// Connects to data-controller="signature-pad"
export default class extends Controller {
  static targets = ["canvas", "input"];

  initialize() {
    this.signaturePad = new SignaturePad(this.canvasTarget, {
      minWidth: 1,
      maxWidth: 3, // Adjust width to ensure visibility
      penColor: "black"
    });
    this.resizeCanvas();
  }

  resizeCanvas() {
    const canvas = this.canvasTarget;
    const ratio = Math.max(window.devicePixelRatio || 1, 1);

    const parentWidth = canvas.parentElement.offsetWidth || 320;
    const parentHeight = canvas.parentElement.offsetHeight || 200;

    canvas.width = parentWidth * ratio;
    canvas.height = parentHeight * ratio;

    const context = canvas.getContext("2d");
    context.scale(ratio, ratio);

    this.signaturePad.clear();
  }

  clearSignature(event) {
    event.preventDefault();
    this.signaturePad.clear();
  }

  saveSignature() {
    if (!this.signaturePad.isEmpty()) {
      const dataURL = this.signaturePad.toDataURL(); // Convert the signature to a data URL
      this.inputTarget.value = dataURL; // Store the data URL in the hidden input
    }
  }
}
