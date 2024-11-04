import { Application } from "@hotwired/stimulus"
import "@hotwired/strada"

import MenuController from "https://rentdito-js.s3.ap-southeast-2.amazonaws.com/controllers/menu_controller.js"
import BridgeFormController from "https://rentdito-js.s3.ap-southeast-2.amazonaws.com/controllers/bridge/form_controller.js"
import BridgeMenuController from "https://rentdito-js.s3.ap-southeast-2.amazonaws.com/controllers/bridge/menu_controller.js"
import BridgeOverflowMenuController from "https://rentdito-js.s3.ap-southeast-2.amazonaws.com/controllers/bridge/overflow_menu_controller.js"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Register Controllers
Stimulus.register("menu", MenuController)

// Register Bridge Components
Stimulus.register("bridge--form", BridgeFormController)
Stimulus.register("bridge--menu", BridgeMenuController)
Stimulus.register("bridge--overflow-menu", BridgeOverflowMenuController)

export { application }
