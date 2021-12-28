
class MenuItems {
  String itemName;
  double price;
  bool isItemSelected;
  bool isItemHasExtras;
  int selectedItemQuantity;
  List<FoodExtras> selectedExtras = [];
  List<FoodExtras>? extraContents;

  MenuItems({required this.itemName, required this.price, this.isItemSelected = false,
             this.isItemHasExtras = false, this.selectedItemQuantity = 0, this.extraContents});

   double get totalPrice => price * selectedItemQuantity;
 }

class FoodExtras {
  String contentName;
  double price;
  int selectedItemQuantity;
  bool isItemSelected;


  FoodExtras({required this.contentName, required this.price, this.selectedItemQuantity = 0, this.isItemSelected = false});

  double get totalPrice => price * selectedItemQuantity;

}