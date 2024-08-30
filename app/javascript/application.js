import "@hotwired/turbo-rails"
import "./custom"
import { Application } from "@hotwired/stimulus"
import HelloController from "controllers/hello_controller"

const application = Application.start()
application.register("hello", HelloController)
