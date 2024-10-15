import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "containerToClear" ]

  connect() {
    setTimeout(() => {
      this.containerToClearTarget.innerHTML = "";
    }, 2000);
  }

  clearContainer() {
    this.containerToClearTarget.innerHTML = "";
  }
}
