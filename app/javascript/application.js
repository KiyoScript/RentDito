// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "helpers"
import "config"
import "jquery"
import "popper"
import "bootstrap"
import "perfect-scrollbar"
import "menu"
import "main"
import "toastr"
import "jquery-repeater"
import "bs-stepper"
import "popular"
import "bootstrap5"
import "autofocus"
import "cleave"
import "cleave-phone"
import "swiper"
import "ui-carousel"
import "apexcharts"

document.addEventListener('turbo:load', () => {
  toastr.options = {
    closeButton: false,
    debug: false,
    newestOnTop: true,
    progressBar: false,
    positionClass: "toast-top-right",
    preventDuplicates: true,
    onclick: null,
    showDuration: "300",
    hideDuration: "1000",
    timeOut: "2000",
    extendedTimeOut: "1000",
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut"
  }
})


import "channels"
