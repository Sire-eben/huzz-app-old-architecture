class Notifications {
  String? message, image, time, date;
  Notifications({this.message, this.image, this.time, this.date});
}

List<Notifications> notificationList = [
  Notifications(
      message:
          'You are currently owed N2400 by customers. Click to send reminders and recover your money.',
      image: 'assets/images/notification.svg',
      time: '10:42 AM',
      date: 'NOV. 29'),
  Notifications(
      message: 'You currently owe N25000. Click to see more information.',
      image: 'assets/images/notification.svg',
      time: '10:42 AM',
      date: 'NOV. 29'),
  Notifications(
      message: 'Mr Tunde accepted your invite to join Huzz Technologies',
      image: 'assets/images/notification.svg',
      time: '10:42 AM',
      date: 'NOV. 29'),
];
