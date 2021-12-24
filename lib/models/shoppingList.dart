class ShoppingList{
  String itemName;
  String url;

  ShoppingList({this.itemName,this.url});

  ShoppingList.fromMap(Map snapshot)
      : itemName = snapshot['itemName'] ?? '',
        url = snapshot['url'] ?? '';

}