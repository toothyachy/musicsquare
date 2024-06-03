import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="music"
export default class extends Controller {
  static targets = ["audio", "button"]
  connect() {

  }

  togglePlayPause(e) {
    e.preventDefault()
    console.log(this.audioTarget.duration);
    if (this.audioTarget.paused) {
      this.audioTarget.play()
      this.buttonTarget.textContent = 'Pause'
    } else {
      this.audioTarget.pause()
      this.buttonTarget.textContent = 'Play'
    }

    setTimeout(() => {
      this.buttonTarget.textContent = 'Play'
    }, this.audioTarget.duration * 1000 );
  }
}
