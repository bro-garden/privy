// app/javascript/controllers/expiration_controller.js
import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="expiration"
export default class extends Controller {
  static targets = ["expirationType", "expirationLimit"];

  connect() {
    this.updateExpirationTypeOptions();
  }

  updateExpirationTypeOptions() {
    
    const limitOptionsList = this.expirationLimitTarget.querySelector("select");
    const expirationTypeOptionsList = this.expirationTypeTarget.querySelector("select");
    
    const limit = parseInt(limitOptionsList.value, 10);
    const expirationType = expirationTypeOptionsList.value;

    const singularOptions = [
      "hour",
      "day",
      "week",
      "month",
      "visit"
    ];
    const pluralOptions = [
      "hours",
      "days",
      "weeks",
      "months",
      "visits"
    ];

    expirationTypeOptionsList.innerHTML = "";

    const options = limit === 1 ? singularOptions : pluralOptions;
    const optionIndex = expirationType === "" ? 0 : Math.max(singularOptions.indexOf(expirationType), pluralOptions.indexOf(expirationType));

    options.forEach(type => {
      const option = document.createElement("option");
      option.value = type;
      option.text = type.charAt(0).toUpperCase() + type.slice(1);
      expirationTypeOptionsList.appendChild(option);
    });

    expirationTypeOptionsList.value = options[optionIndex] || options[0];
  }
}
