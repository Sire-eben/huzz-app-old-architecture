import 'package:get/get.dart';

class HomeRepository extends GetxController {
  final _onBoardingRegSelectedIndex = 0.obs;
  int get onBoardingRegSelectedIndex => _onBoardingRegSelectedIndex.value;

  void selectOnboardSelectedNext() {
    _onBoardingRegSelectedIndex(onBoardingRegSelectedIndex + 1);
  }

  void selectedOnboardSelectedPrevious() {
    _onBoardingRegSelectedIndex(onBoardingRegSelectedIndex - 1);
  }

  void gotoIndex(int index) {
    _onBoardingRegSelectedIndex(index);
  }
}
