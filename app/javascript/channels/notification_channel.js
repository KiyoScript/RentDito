import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  received(data) {
    const notificationList = document.getElementById("notification-list")
    const notificationCount = document.getElementById("notification-count")
    const newNotificationCount = document.getElementById("new-notification-count")
    const noNotificationMessage = document.getElementById("no-notification-message")

    // Function to determine the icon and color based on notification type
    const getIconAndColor = (type) => {
      switch (type) {
        case "Ticket":
          return { icon: "bx bx-wrench", color: "bg-label-info" };
        case "TicketClosed":
          return { icon: "bx bx-check-circle", color: "bg-label-success" };
        case "TicketCreated":
          return { icon: "bx bx-wrench", color: "bg-label-primary" };
        case "NewBilling":
          return { icon: "bx bx-money", color: "bg-label-info" };
        default:
          return { icon: "bx bx-info-circle", color: "bg-label-primary" };
      }
    }

    const { icon, color } = getIconAndColor(data.type);

    notificationList.insertAdjacentHTML("afterbegin", `
      <li class="list-group-item list-group-item-action dropdown-notifications-item">
          <div class="d-flex">
              <div class="flex-shrink-0 me-3">
                <div class="avatar">
                  <span class="avatar-initial rounded-circle ${color}">
                    <i class="${icon}"></i>
                  </span>
                </div>
              </div>
              <div class="flex-grow-1">
                <h6 class="small mb-0 fw-bold">${data.message}</h6>
                <small class="text-muted">just now</small>
              </div>
              <div class="flex-shrink-0 dropdown-notifications-actions">
                <a href="javascript:void(0)" class="dropdown-notifications-read" data-id="${data.id}">
                  <span class="badge badge-dot bg-primary"></span>
                </a>
              </div>
            </div>
          </li>
    `);

    if (typeof(noNotificationMessage) != 'undefined' && noNotificationMessage != null) {
      noNotificationMessage.remove();
    }

    const count = parseInt(notificationCount.textContent, 10) || 0;
    notificationCount.textContent = count + 1;
    newNotificationCount.textContent = `${count + 1} New`;
  }
})
