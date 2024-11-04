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
pin 'tesseract', to: "https://cdn.jsdelivr.net/npm/tesseract.js@5.1.1/dist/tesseract.min.js", preload: true
pin 'apexcharts', to: "https://cdn.jsdelivr.net/npm/apexcharts@4.0.0/dist/apexcharts.min.js", preload: true
pin "signature_pad", preload: true # @5.0.3
pin "swiper"
pin "ui-carousel"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
