import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash-messages"
export default class extends Controller {
  connect() {

    const noticeMessage = this.element.dataset.notice;
    const alertMessage = this.element.dataset.alert;

    const formatMessage = (message) => {
      if (!message) return message;

      // Split the message into sentences, preserving punctuation and spaces
      const sentences = message
        .trim()
        .split(/([.!?])\s*/)
        .filter((s) => s.trim() !== ""); // Remove empty splits

      // Capitalize the first word of each sentence
      const formattedSentences = sentences.map((sentence, index) => {
        if (index % 2 === 0) { // Sentence part
          return sentence.charAt(0).toUpperCase() + sentence.slice(1).toLowerCase();
        }
        return sentence + " "; // Punctuation part with a trailing space
      });

      return formattedSentences.join("").trim(); // Join and remove extra trailing spaces
    };

    const ensureProperPunctuation = (message) => {
      if (!message) return message;

      // Ensure the message ends with a valid punctuation mark
      const punctuation = [".", "!", "?"];
      if (!punctuation.includes(message.slice(-1))) {
        return `${message}.`;
      }
      return message;
    };

    const processMessage = (message) => {
      if (!message || message.trim() === "") return null;

      const formattedMessage = formatMessage(message);
      return ensureProperPunctuation(formattedMessage);
    };

    if (noticeMessage) {
      const formattedNotice = processMessage(noticeMessage);
      toastr.success(formattedNotice);
    }

    if (alertMessage) {
      const formattedAlert = processMessage(alertMessage);
      toastr.error(formattedAlert);
    }
  }
}
