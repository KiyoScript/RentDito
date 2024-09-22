import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="load-properties"
export default class extends Controller {
  static targets = ["room", "deck"];

  connect() {
    this.propertySelect = this.element.querySelector("[name='tenant[property_id]']")
    this.propertyUnitSelect = this.element.querySelector("#user_property_unit")
    this.roomSelect = this.element.querySelector("#user_room")

    if (this.propertySelect) {
      this.propertySelect.addEventListener("change", this.loadPropertyUnits.bind(this))
    }

    if (this.propertyUnitSelect) {
      this.propertyUnitSelect.addEventListener("change", this.loadRooms.bind(this))
    }
  }

  loadPropertyUnits(event) {
    const propertyId = event.target.value

    if (propertyId) {
      fetch(`/dashboard/properties/${propertyId}/property_units`)
        .then(response => response.json())
        .then(data => {
          this.updatePropertyUnits(data)
        })
        .catch(error => {
          console.error("Error fetching property units:", error)
        })
    } else {
      this.clearPropertyUnits()
      this.clearRooms()
      this.clearDecks()
    }
  }

  loadRooms(event) {
    const propertyUnitId = event.target.value

    if (propertyUnitId) {
      fetch(`/dashboard/property_units/${propertyUnitId}/rooms`)
        .then(response => response.json())
        .then(data => {
          this.updateRooms(data)
        })
        .catch(error => {
          console.error("Error fetching rooms:", error)
        })
    } else {
      this.clearRooms()
      this.clearDecks()
    }
  }

  loadDecks(event) {
    const roomId = event.target.value;
    if (!roomId) {
      this.clearDecks();
      return;
    }

    fetch(`/dashboard/rooms/${roomId}/decks`)
      .then(response => response.json())
      .then(data => {
        this.updateDeckOptions(data.decks);
      })
      .catch(error => console.error("Error fetching decks:", error));
  }

  updatePropertyUnits(propertyUnits) {
    if (this.propertyUnitSelect) {
      this.propertyUnitSelect.innerHTML = "<option value=''>Choose Property Code</option>"

      propertyUnits.forEach((unit) => {
        const option = document.createElement("option")
        option.value = unit.id
        option.textContent = unit.name
        this.propertyUnitSelect.appendChild(option)
      })
    } else {
      console.error("Property unit select element not found.")
    }
  }

  updateRooms(rooms) {
    if (this.roomSelect) {
      this.roomSelect.innerHTML = "<option value=''>Choose Room</option>"

      rooms.forEach((room) => {
        const option = document.createElement("option")
        option.value = room.id
        option.textContent = room.name
        this.roomSelect.appendChild(option)
      })

      if (rooms.length === 0) {
        const noRoomOption = document.createElement("option");
        noRoomOption.value = "";
        noRoomOption.textContent = "No room available";
        this.roomSelect.appendChild(noRoomOption);
      }
    } else {
      console.error("Room select element not found.")
    }
  }

  updateDeckOptions(decks) {
    this.deckTarget.innerHTML = "";

    decks.forEach(deck => {
      const option = document.createElement("option");
      option.value = deck;
      option.textContent = deck.charAt(0).toUpperCase() + deck.slice(1);
      this.deckTarget.appendChild(option);
    });

    if (decks.length === 0) {
      const noDeckOption = document.createElement("option");
      noDeckOption.value = "";
      noDeckOption.textContent = "No bedspace available";
      this.deckTarget.appendChild(noDeckOption);
    }
  }

  clearPropertyUnits() {
    if (this.propertyUnitSelect) {
      this.propertyUnitSelect.innerHTML = "<option value=''>Choose Property Unit</option>"
    }
  }

  clearRooms() {
    if (this.roomSelect) {
      this.roomSelect.innerHTML = "<option value=''>Choose Room</option>"
    }
  }

  clearDecks() {
    if (this.deckTarget) {
      this.deckTarget.innerHTML = "<option value=''>Choose Deck</option>"
    }
  }
}
