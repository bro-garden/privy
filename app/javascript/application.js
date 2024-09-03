import "@hotwired/turbo-rails"
import "./custom"
import { Application } from "@hotwired/stimulus"
import ClipboardController from "controllers/clipboard_controller"
import ExpirationController from "./controllers/expiration_controller"

const application = Application.start();
application.register("clipboard", ClipboardController)
application.register("expiration", ExpirationController)

window.Stimulus = application;
