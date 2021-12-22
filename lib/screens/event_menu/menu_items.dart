
class MenuItems {
  String itemName;
  double price;
  bool isItemSelected;
  bool isItemHasExtras;
  int selectedItemQuantity;
  List<String>? extraContents;
  List<String>? selectedExtras;

  MenuItems({required this.itemName, required this.price, this.isItemSelected = false,
             this.isItemHasExtras = false, this.selectedItemQuantity = 0, this.extraContents});

   double get totalPrice => price * selectedItemQuantity;
}