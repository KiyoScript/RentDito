import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-property-unit"
export default class extends Controller {
  connect() {
    let formRepeater = $(".form-repeater")

    formRepeater.on('submit', function(e) {
      e.preventDefault();
    });

    let uniqueIdCounter = 0;

    formRepeater.repeater({
      show: function() {
        uniqueIdCounter++;
        let newItem = $(this);

        let formControls = newItem.find('.form-control');
        let formLabels = newItem.find('.form-label');

        formControls.each(function(index) {
          let newId = `property_unit_${uniqueIdCounter}_${index}`;
          $(this).attr('id', newId);
          $(formLabels[index]).attr('for', newId);
        });

        $(this).slideDown();
      }
    })
  }
}
