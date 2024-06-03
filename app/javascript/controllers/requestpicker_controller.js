import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
// slots = ["2024-06-17","2024-06-17","2024-06-24","2024-06-24","2024-07-01","2024-07-01","2024-07-08","2024-07-08","2024-07-15","2024-07-15"]

// Connects to data-controller="requestpicker"
export default class extends Controller {

  connect() {
    const listingId = this.element.dataset.requestpickerListingId;

    const url = `/listings/${listingId}/availabilities`
    const fetchAvailableDates = async(url) => {
      try {
        const response = await fetch(url)
        const slots = await response.json()
        console.log(slots);
        return slots
      } catch (error) {
        console.error('Error:', error)
      }
    }

    fetchAvailableDates(url)
    .then(slots => {
      flatpickr(this.element, {
      dateFormat: "Y-m-d",
      enable: slots['date_slots'],
      onChange: function(selectedDates, dateStr, instance) {
        getTimeslots(selectedDates, dateStr, instance, slots['time_slots']);
      }
    })
  })

    function getTimeslots(selectedDates, dateStr, instance, timeslots) {
      console.log("Callback triggered!");
      console.log(timeslots);
      // console.log('the callback returns the selected dates', selectedDates)
      // console.log('but returns it also as a string', dateStr)
      // console.log('and the flatpickr instance', instance)
    }
  }
}
