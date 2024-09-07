// app/javascript/application.js
import "@hotwired/turbo-rails";
import "plain-scripts/simplemde_initializer";
import "@rails/actiontext"
import { Application } from "@hotwired/stimulus";
import ClipboardController from "controllers/clipboard_controller";
import ExpirationController from "controllers/expiration_controller";

console.log('Hello from immprada');

const application = Application.start();
application.register("clipboard", ClipboardController);
application.register("expiration", ExpirationController);

window.Stimulus = application;
