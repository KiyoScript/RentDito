import { Application } from "@hotwired/stimulus"
import "@hotwired/strada"

import MenuController from "./menu-controller.js"
import BridgeFormController from "./bridge/form_controller.js"
import BridgeMenuController from "./bridge/menu_controller.js"
import BridgeOverflowMenuController from "./bridge/overflow_menu_controller.js"

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