import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

// Connects to data-controller="notifications"
export default class extends Controller {
  static targets = ["getNotificationId"]

  async markAsRead(event) {
    const url = event.currentTarget.dataset.url;

    const request = new FetchRequest("PATCH", url, { responseKind: "json" });

    try {
      const response = await request.perform();

      if (response.ok) {
        console.info("Success")
      } else {
        console.error("Failed to mark notification as read:", response.statusText);
      }
    } catch (error) {
      console.error("Error marking notification as read:", error);
    }
  }
}
