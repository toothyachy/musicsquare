import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="timepicker"
export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      noCalendar: true,
      dateFormat: "H:i",
      enableTime: true,
      mode: "range"
  })
  }
}
