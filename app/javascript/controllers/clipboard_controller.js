import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "source", "triggerButton" ]

  copy() {
    const linkToCopy = this.sourceTarget.value
    const button = this.triggerButtonTarget
    const buttonInitialText = button.textContent

    navigator.clipboard.writeText(linkToCopy)
      .then(() => {
        button.textContent = 'Copied!'
        button.disabled = true
        setTimeout(() => {
          button.textContent = buttonInitialText
          button.disabled = false
        }, 2000)
      })
      .catch(err => {
        console.error('Failed to copy!', err)
      })
  }

  selectContent() {
    this.sourceTarget.select()
  }
}
