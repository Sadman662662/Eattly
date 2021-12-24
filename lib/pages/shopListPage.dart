import 'package:eattlystefan/models/ingredient.dart';
import 'package:eattlystefan/models/recipe.dart';
import 'package:eattlystefan/models/shoppingList.dart';
import 'package:eattlystefan/models/shoppingListItem.dart';
import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopListPage extends StatefulWidget {
  final Recipe recipe;

  ShopListPage({this.recipe});
  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  var _shoppingList = <ShoppingList>[];
  var shoppingListItem;

  @override
  void initState() {
    // TODO: implement initState
    // getIngredients();
  }

  // getIngredients() async {
  //   var fireStore = FirebaseFirestore.instance;
  //   await fireStore
  //       .collection("ingredients")
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     print("Length: " + snapshot.docChanges.length.toString());

  //     snapshot.docs.forEach((element) {
  //       setState(() {
  //         var a = ShoppingList.fromMap(element.data());
  //         _shoppingList.add(a);

  //         print("Name: ${a.itemName}");
  //       });
  //     });
  //   });
  // }

  delteShoppingListItem(String documentId) async {
    firebaseFirestoreInstance
        .collection('shoppingList')
        .doc(currentUser.id)
        .collection('shoppingList')
        .doc(documentId)
        .delete();
    showToast();
  }

  showDialogForDeletingShoppingListItem(String postId) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(
                              "Do you want to delete the item",
                              maxLines: 2,
                              style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          height: 40.0,
                          minWidth: 100.0,
                          child: RaisedButton(
                            child: Text(
                              "Yes",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () async {
                              delteShoppingListItem(postId);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ButtonTheme(
                          height: 40.0,
                          minWidth: 100.0,
                          child: RaisedButton(
                            child: Text(
                              "No",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: 'Shoppinglist item has been deleted successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Shoping List",
            style: textStyle(greenColor, 18.0, FontWeight.w500),
          ),
          iconTheme: IconThemeData(color: greenColor),
        ),
        body: StreamBuilder(
          stream: firebaseFirestoreInstance
              .collection('shoppingList')
              .doc(currentUser.id)
              .collection('shoppingList')
              .snapshots(),
          builder: (context, snapshots) {
            // var recipe = Ingredient.fromDocument2(snapshots.data);
            List<ShoppingListItem> shoppingLists = [];
            List<String> ingredientPostIds = [];
            if (snapshots.hasData) {
              snapshots.data.documents.forEach((document) {
                ingredientPostIds.add(document.id);
                shoppingListItem = ShoppingListItem.fromDocument(document);
                shoppingLists.add(shoppingListItem);
              });
            }
            if (!snapshots.hasData) {
              return Center(
                child: Text('Shopping List is empty'),
              );
            }

            return ListView.builder(
                itemCount: shoppingLists.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) => Container(
                      // height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                shoppingLists[index].name,
                                style: textStyle(
                                    Colors.black, 16.0, FontWeight.w500),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showDialogForDeletingShoppingListItem(
                                      ingredientPostIds[index]);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 20.0,
                          ),
                          (shoppingLists[index].stringIngredients != null)
                              ? Container(
                                  // height: 120,
                                  child: Column(
                                    children: [
                                      Text(shoppingLists[index]
                                          .stringIngredients)
                                    ],
                                  ),
                                )
                              : IngradientList(
                                  shoppingLIst:
                                      shoppingLists[index].ingredientList),
                        ],
                      ),
                    ));
          },
        ));
  }
}

class IngradientList extends StatelessWidget {
  const IngradientList({
    Key key,
    @required this.shoppingLIst,
  }) : super(key: key);

  final List<Ingredient> shoppingLIst;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: shoppingLIst.length,
        itemBuilder: (_, index) {
          return Container(
            height: 120.0,
            width: 90.0,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      child: Image.network(
                        shoppingLIst[index].imageUrl,
                        height: 60,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(height: 5.0),
                  Expanded(
                      child: Text(
                          '${shoppingLIst[index].amount.toString()}  ${shoppingLIst[index].unit}')),
                  Expanded(
                      child: Text(
                    shoppingLIst[index].name,
                    style: textStyle(Colors.black54, 12.0, FontWeight.w500),
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
