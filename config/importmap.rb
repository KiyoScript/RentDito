# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "helpers"
pin "config"
pin "jquery"
pin "popper"
pin "bootstrap"
pin "perfect-scrollbar"
pin "menu"
pin "main"
pin "toastr"
pin "jquery-repeater"
pin "bs-stepper"
pin "popular"
pin "bootstrap5"
pin "autofocus"
pin "cleave"
pin "cleave-phone"
pin "dropzone", to: "https://unpkg.com/dropzone@6.0.0-beta.1/dist/dropzone-min.js", preload: true
pin "cropper", to: "https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.1/cropper.min.js", preload: true
pin "signature_pad", preload: true # @5.0.3
