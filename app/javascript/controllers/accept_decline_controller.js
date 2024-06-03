import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accept-decline"
export default class extends Controller {
  connect() {
    console.log("Connected!");
  }
}
