import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  connect() {
    flatpickr(this.element, {
        mode: "multiple",
        dateFormat: "Y-m-d",
        defaultDate: ["2016-10-20", "2016-11-04"]

    })
  }
}
