class OnBoardingModel {
  String? asset;
  String? title;
  String? body;
  OnBoardingModel({this.asset, this.title, this.body});

  static List<OnBoardingModel> values = [
    OnBoardingModel(
      asset: 'assets/images/Group 3804.png',
      title: 'Give your business a boost ',
      body:
          'Access free tools for bookkeeping, invoicing, customer management, inventory, debt recovery, analytics, and more.',
    ),
    OnBoardingModel(
      asset: 'assets/images/Group 3805.png',
      title: 'Offline capability for peace of mind',
      body:
          'Continue to manage your business when you are offline or out of data. Your data automatically syncs to the cloud when you are back online.',
    ),
    OnBoardingModel(
      asset: 'assets/images/Group 3806.png',
      title: 'The app for the Entrepreneur',
      body:
          'Set up multiple businesses. Invite your coworkers to collaboratively manage your business. It’s easy. It’s smart. It’s the Huzz app. ',
    ),
  ];
}
