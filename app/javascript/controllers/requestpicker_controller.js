import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
// slots = ["2024-06-17","2024-06-17","2024-06-24","2024-06-24","2024-07-01","2024-07-01","2024-07-08","2024-07-08","2024-07-15","2024-07-15"]

// Connects to data-controller="requestpicker"
export default class extends Controller {

  static targets = ["flatpickr", "timeslotpicker"]

  connect() {
    const listingId = this.element.dataset.requestpickerListingId;
    const url = `/listings/${listingId}/availabilities`

    let { availSlots, dateSlots } = {}

    this.#fetchAvailableDates(url)
    .then(slots => {
      availSlots = slots["avail_slots"]
      dateSlots = slots["date_slots"]
      flatpickr(this.flatpickrTarget, {
        dateFormat: "Y-m-d",
        enable: dateSlots,
        onChange: (selectedDates, dateStr) => {
          this.#getTimeslots(selectedDates, dateStr, availSlots);
        }
      })
    })
  }

  async #fetchAvailableDates(url) {
    try {
      const response = await fetch(url)
      const slots = await response.json()
      console.log(slots);
      return slots
    } catch (error) {
      console.error('Error:', error)
    }
  }

  #getTimeslots(_, dateStr, availSlots) {
    const timeslots = availSlots.filter(i => i.date === dateStr).map(i => i.start_time);
    while (this.timeslotpickerTarget.firstChild) {
      this.timeslotpickerTarget.removeChild(this.timeslotpickerTarget.firstChild);
    }
    timeslots.forEach(timeslot => {
      const option = document.createElement("option");
      option.value = timeslot;
      option.textContent = timeslot.split('T')[1].slice(0,5);
      this.timeslotpickerTarget.appendChild(option);
    });
    this.timeslotpickerTarget.classList.toggle("d-none")
  }
}
