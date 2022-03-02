import 'package:get/get.dart';

class HomeRespository extends GetxController {
  final _onboardingRegSelectedIndex = 0.obs;
  int get onboardingRegSelectedIndex => _onboardingRegSelectedIndex.value;

  void selectOnboardSelectedNext() {
    _onboardingRegSelectedIndex(onboardingRegSelectedIndex + 1);
  }

  void selectedOnboardSelectedPrevious() {
    _onboardingRegSelectedIndex(onboardingRegSelectedIndex - 1);
  }
  void gotoIndex(int index){
    _onboardingRegSelectedIndex(index);

  }
}
