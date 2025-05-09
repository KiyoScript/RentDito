import { Controller } from "@hotwired/stimulus"
// Connects to data-controller='wizard-form'
export default class extends Controller {
  static targets = [
    'wizardValidationForm'
  ]

  connect() {
    document.addEventListener('turbo:load', () => {

      const firstCN  = new Cleave(".first-contact-number", {
        blocks: [4, 3, 4],
        numericOnly: true,
      });

      const thirdCN  = new Cleave(".third-contact-number", {
        blocks: [4, 3, 4],
        numericOnly: true,
      });

      const secondCN  = new Cleave(".second-contact-number", {
        blocks: [4, 3, 4],
        numericOnly: true,
      });

      const fourthCN  = new Cleave(".fourth-contact-number", {
        blocks: [4, 3, 4],
        numericOnly: true,
      });


      const wizardValidation = this.element
      const wizardValidationForm = this.wizardValidationFormTarget




      if(wizardValidation !== undefined && wizardValidation !== null){


        const personalInfo = wizardValidationForm.querySelector('#personal-info-validation')
        // const accountDetails = wizardValidationForm.querySelector('#account-details-validation')
        const emergencyContacts = wizardValidationForm.querySelector('#emergency-contacts-validation')
        const wizardValidationNext = [].slice.call(wizardValidationForm.querySelectorAll('.btn-next'))
        const wizardValidationPrev = [].slice.call(wizardValidationForm.querySelectorAll('.btn-prev'))

        let validationStepper = new Stepper(wizardValidation, {
          linear: true
        })

        //Personal Info
        const personalInfoValidation = FormValidation.formValidation(personalInfo, {
          fields: {
            "user[firstname]": {
              validators: {
                notEmpty: {
                  message: 'The first name is required.'
                }
              }
            },
            "user[lastname]": {
              validators: {
                notEmpty: {
                  message: 'The last name is required.'
                }
              }
            },
            "user[phone_number]": {
              validators: {
                notEmpty: {
                  message: 'The phone number is required.'
                }
              }
            },
            "user[date_of_birth]": {
              validators: {
                notEmpty: {
                  message: 'The date of birth is required.'
                }
              }
            },
            "user[age]": {
              validators: {
                notEmpty: {
                  message: 'The age is required.'
                }
              }
            },
          },
          plugins: {
            trigger: new FormValidation.plugins.Trigger(),
            bootstrap5: new FormValidation.plugins.Bootstrap5({
              eleValidClass: ''
            }),
            autoFocus: new FormValidation.plugins.AutoFocus(),
            submitButton: new FormValidation.plugins.SubmitButton()
          }
        }).on('core.form.valid', function() {
          // Jump to the next step when all fields in the current step are valid
          validationStepper.next();
        })


        // // Account Details
        // const accountDetailsValidation = FormValidation.formValidation(accountDetails, {
        //   fields: {
        //     "user[email]": {
        //       validators: {
        //         notEmpty: {
        //           message: 'The Email is required'
        //         },
        //         emailAddress: {
        //           message: 'The value is not a valid email address'
        //         }
        //       }
        //     },
        //     "user[password]": {
        //       validators: {
        //         notEmpty: {
        //           message: 'The Password is required'
        //         }
        //       }
        //     },
        //     "user[password_confirmation]": {
        //       validators: {
        //         notEmpty: {
        //           message: "The Confirm Password is required"
        //         },
        //         identical: {
        //           compare: function() {
        //             return accountDetails.querySelector('[name="user[password]"]').value;
        //           },
        //           message: 'The password and its confirm are not the same'
        //         }
        //       }
        //     }
        //   },
        //   plugins: {
        //     trigger: new FormValidation.plugins.Trigger(),
        //     bootstrap5: new FormValidation.plugins.Bootstrap5({
        //       eleValidClass: ''
        //     }),
        //     autoFocus: new FormValidation.plugins.AutoFocus(),
        //     submitButton: new FormValidation.plugins.SubmitButton()
        //   }
        // }).on('core.form.valid', function() {
        //   // Jump to the next step when all fields in the current step are valid
        //   validationStepper.next();
        // })


        const emergencyContactsValidation = FormValidation.formValidation(emergencyContacts, {
          fields: {
            "user[first_contact_name]": {
              validators: {
                notEmpty: {
                  message: 'The contact name is required.'
                }
              }
            },
            "user[first_contact_number]": {
              validators: {
                notEmpty: {
                  message: 'The contact number is required'
                },
                stringLength: {
                  min: 13,
                  max: 13,
                  message: 'The contact number must be 11 digits.'
                }
              }
            },
            "user[third_contact_number]": {
              validators: {
                notEmpty: {
                  message: 'The second contact number is required.'
                },
                stringLength: {
                  min: 13,
                  max: 13, // Maximum length
                  message: 'The contact number must be 11 digits.'
                }
              }
            },
            "user[first_relationship]": {
              validators: {
                notEmpty: {
                  message: "The relationship is required."
                }
              }
            },
            "user[second_contact_name]": {
              validators: {
                notEmpty: {
                  message: 'The contact name is required.'
                }
              }
            },
            "user[second_contact_number]": {
              validators: {
                notEmpty: {
                  message: 'The contact number is required.'
                },
                stringLength: {
                  min: 13,
                  max: 13, // Maximum length
                  message: 'The contact number must be between 11 digits.'
                }
              }
            },
            "user[fourth_contact_number]": {
              validators: {
                notEmpty: {
                  message: 'The second contact number is required.'
                },
                stringLength: {
                  min: 13,
                  max: 13, // Maximum length
                  message: 'The contact number must be between 11 digits.'
                }
              }
            },
            "user[second_relationship]": {
              validators: {
                notEmpty: {
                  message: "The relationship is required."
                }
              }
            }
          },
          plugins: {
            trigger: new FormValidation.plugins.Trigger(),
            bootstrap5: new FormValidation.plugins.Bootstrap5({
              eleValidClass: ''
            }),
            autoFocus: new FormValidation.plugins.AutoFocus(),
            submitButton: new FormValidation.plugins.SubmitButton()
          }
        }).on('core.form.valid', function() {
           wizardValidationForm.submit()
        })

        wizardValidationNext.forEach(item => {
          item.addEventListener('click', event => {
            // When click the Next button, we will validate the current step
            switch (validationStepper._currentIndex) {
              case 0:
                personalInfoValidation.validate();
                break

              case 1:
                validationStepper.next();
                break

              case 2:
                emergencyContactsValidation.validate();
                break;

              default:
                break
            }
          })
        })


        wizardValidationPrev.forEach(item => {
          item.addEventListener('click', event => {
            switch (validationStepper._currentIndex) {
              case 2:
                validationStepper.previous();
                break

              case 1:
                validationStepper.previous();
                break

              case 0:

              default:
                break
            }
          })
        })
      }
    })
  }
}
