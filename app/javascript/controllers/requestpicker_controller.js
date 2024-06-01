import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
// slots = ["2024-06-17","2024-06-17","2024-06-24","2024-06-24","2024-07-01","2024-07-01","2024-07-08","2024-07-08","2024-07-15","2024-07-15"]

// Connects to data-controller="requestpicker"
export default class extends Controller {

  connect() {
    // const fetchAvailableDates = () => {
    //   const url = '/listings/availability'
    //   fetch(url)
    //   .then(response => { response.json() })
    //   .then(data => { console.log(data.dates) })
        // flatpickr(this.element, {
        //   dateFormat: "Y-m-d",
        //   enable: data.dates
        // })
      // })
    //   .catch(error => console.error('Error:', error));
    // }
    // fetchAvailableDates()

    const url = '/listings/availability'
    const fetchAvailableDates = async(url) => {
      try {
        const response = await fetch(url)
        const data = await response.json()
        return data
      } catch (error) {
        console.error('Error:', error)
      }
    }

    fetchAvailableDates(url)
    .then(data => {
      flatpickr(this.element, {
      dateFormat: "Y-m-d",
      enable: data
    })
  })
  }
}
