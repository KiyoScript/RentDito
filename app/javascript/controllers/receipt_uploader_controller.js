import { Controller } from "@hotwired/stimulus"
import 'tesseract'

// Connects to data-controller="receipt-uploader"
export default class extends Controller {
  static targets = ["submitButton", "amount", "referenceNumber", "dateTime", "receiptField", "loadingContainer", "successContainer", "errorContainer"]

  connect() {
    this.submitButtonTarget.disabled = true;
  }

  async upload(event) {
    const file = event.target.files[0];

    if (!file) return;

    this.resetFormFields();
    this.submitButtonTarget.disabled = true;

    this.loadingContainerTarget.classList.remove("d-none");

    const fileURL = URL.createObjectURL(file);
    const worker = await Tesseract.createWorker();

    try {
      const { data: { text } } = await worker.recognize(fileURL);
      console.log("Extracted Text: ", text);

      const referenceNumber = this.extractReferenceNumber(text);
      const amount = this.extractAmount(text);
      const dateTime = this.extractDateTime(text);

      this.setFieldValue(this.referenceNumberTarget, referenceNumber);
      this.setFieldValue(this.amountTarget, amount);
      this.setFieldValue(this.dateTimeTarget, dateTime);


      if (this.isValidReceipt(referenceNumber, amount, dateTime)) {
        this.submitButtonTarget.disabled = false;

        this.successContainerTarget.classList.remove('d-none');

        setTimeout(() => {
          this.successContainerTarget.classList.add('d-none');
        }, 3000);
      } else {
        this.errorContainerTarget.classList.remove('d-none');

        setTimeout(() => {
          this.errorContainerTarget.classList.add('d-none');
        }, 3000);
      }

    } catch (error) {
      console.error("Error processing image: ", error);
    } finally {
      this.loadingContainerTarget.classList.add("d-none");
      await worker.terminate();
    }
  }

  resetFormFields() {
    this.setFieldValue(this.referenceNumberTarget, '');
    this.setFieldValue(this.amountTarget, '');
    this.setFieldValue(this.dateTimeTarget, '');
  }

  setFieldValue(field, value) {
    if (field) {
      field.value = value;
    }
  }

  // Validate if the required fields are not empty
  isValidReceipt(referenceNumber, amount, dateTime) {
    return referenceNumber !== 'N/A' && amount !== '0.00' && dateTime !== 'N/A';
  }

  extractReferenceNumber(text) {
    const refMatch = text.match(/Ref(?:erence)?\s*No\.\s*(\d{4}\s*\d{3}\s*\d{6})/i);
    return refMatch ? refMatch[1] : 'N/A';
  }

  extractAmount(text) {
    const amountMatch = text.match(/(?:Amount|Total Amount Sent)\s*\$?([\d,]+\.\d{2})/i);
    return amountMatch ? parseFloat(amountMatch[1].replace(/,/g, '')) : 0.00;
  }


  extractDateTime(text) {
    const dateTimeMatch = text.match(/([A-Za-z]{3} \d{1,2}, \d{4} \d{1,2}:\d{2} [AP]M)/);

    if (dateTimeMatch) {
      const dateString = dateTimeMatch[0];
      console.log("Extracted Date String:", dateString);
      return this.formatDateToISO(dateString);
    }

    return '';
  }

  formatDateToISO(dateString) {
    const dateParts = dateString.split(' ');
    const month = dateParts[0]
    const day = dateParts[1].replace(',', '')
    const year = dateParts[2]
    const time = dateParts[3]
    const period = dateParts[4]

    const hours = period === "PM" && time.split(':')[0] !== "12"
                  ? parseInt(time.split(':')[0]) + 12
                  : period === "AM" && time.split(':')[0] === "12"
                  ? "00"
                  : time.split(':')[0];

    const minutes = time.split(':')[1];

    const isoString = `${year}-${this.getMonthNumber(month)}-${day}T${hours}:${minutes}`;

    return isoString;
  }

  getMonthNumber(month) {
    const monthMap = {
      Jan: '01',
      Feb: '02',
      Mar: '03',
      Apr: '04',
      May: '05',
      Jun: '06',
      Jul: '07',
      Aug: '08',
      Sep: '09',
      Oct: '10',
      Nov: '11',
      Dec: '12',
    };
    return monthMap[month];
  }


}
