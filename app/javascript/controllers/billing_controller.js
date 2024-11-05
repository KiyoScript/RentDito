import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="billing"
export default class extends Controller {
  static targets = ['startDateField','waterStartDateField', 'waterEndDateField', 'endDateField', 'dueDateField']

  generateEndDateValue() {
    const startDate = this.startDateFieldTarget.value

    if (startDate) {
      let startDateObj = new Date(startDate)

      startDateObj.setDate(startDateObj.getDate() + 30)
      let endDateFormatted = startDateObj.toISOString().split('T')[0]

      this.endDateFieldTarget.value = endDateFormatted

      let endDateObj = new Date(this.endDateFieldTarget.value)
      endDateObj.setDate(endDateObj.getDate() + 3)
    }

    const waterStartDate = this.waterStartDateFieldTarget.value

    if (waterStartDate) {

      let waterStartDateObj = new Date(waterStartDate)

      waterStartDateObj.setDate(waterStartDateObj.getDate() + 30)
      let waterEndDateFormatted = waterStartDateObj.toISOString().split('T')[0]

      this.waterEndDateFieldTarget.value = waterEndDateFormatted

      let waterEndDateObj = new Date(this.waterEndDateFieldTarget.value)
      waterEndDateObj.setDate(waterEndDateObj.getDate() + 3)

      waterEndDateObj.setHours(20, 0, 0, 0)

      const dueDateFormatted = this._formatDateToLocal(waterEndDateObj);

      this.dueDateFieldTarget.value = dueDateFormatted
    }
  }


  //Private Method
  _formatDateToLocal(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const hours = String(date.getHours()).padStart(2, '0')
    const minutes = String(date.getMinutes()).padStart(2, '0')

    return `${year}-${month}-${day}T${hours}:${minutes}`
  }
}
