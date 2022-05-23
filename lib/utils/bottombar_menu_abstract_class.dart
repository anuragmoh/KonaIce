abstract class BottomBarMenu {
  void changeIndex(dynamic index);
}

class BottomBarMenuClass extends BottomBarMenu {
  @override
  void changeIndex(index) {
    print("bottomabrMenuClass$index");
  }
}
