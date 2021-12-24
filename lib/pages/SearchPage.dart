import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/pages/recipe_detail_screen.dart';
import 'package:flutter/material.dart';

import './HomePage.dart';
import './ProfilePage.dart';
import '../models/User.dart';
import '../widgets/PostTileWidget.dart';
import '../widgets/PostWidget.dart';
import '../widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureUserSearchResults;

  QuerySnapshot postSnapshot;
  String _searchText = "";
  bool searchRecipes = false;
  Widget selectedOption = SizedBox();

  List<Post> postsList = [];
  List<GridTile> gridTilesList = [];

  List<PostResult> allPosts = [];
  List<PostResult> searchPostResult = [];

  void initState() {
    super.initState();
    getAllUsersPosts();
  }

  _SearchPageState() {
    searchTextEditingController.addListener(() {
      setState(() {
        if (searchTextEditingController.text.isEmpty) {
          _searchText = "";
          futureUserSearchResults = null;
          searchPostResult.clear();
        } else {
          _searchText = searchTextEditingController.text;
        }
      });
    });
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  controlSearching(String str) async {
    if (str != null) {
      if (searchRecipes) {
        searchPostResult.clear();

        setState(() {
          allPosts.forEach((element) {
            if (element.eachPost.name.contains(str)) {
              searchPostResult.add(element);
            }
          });
        });
      } else {
        Future<QuerySnapshot> allUsers = usersReference
            .where("profileName", isGreaterThanOrEqualTo: str)
            .get();

        setState(() {
          futureUserSearchResults = allUsers;
        });
      }
    }
  }

  Future<void> getAllUsersPosts() async {
    postsList.clear();
    gridTilesList.clear();
    allPosts.clear();

    postsReference.get().then((QuerySnapshot snapshot) async {
      snapshot.docs.forEach((DocumentSnapshot doc) async {
        postSnapshot =
            await postsReference.doc(doc.id).collection('usersPosts').get();

        setState(() {
          postsList = postSnapshot.docs
              .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
              .toList();

//          postsList.sort((b, a) => a.timestamp.compareTo(b.timestamp));

          postsList.forEach((eachPost) {
            arrangePostsAlphabetical(eachPost);

            gridTilesList.add(
              GridTile(
                child: PostTile(eachPost),
              ),
            );
          });
        });
      });
    });
  }

  arrangePostsAlphabetical(Post eachPost) {
    setState(() {
      final postResult = PostResult(eachPost);

      allPosts.sort((b, a) => -a.eachPost.name.compareTo(b.eachPost.name));
      allPosts.add(postResult);
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Color(0xFF1B5E20),
      title: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontFamily: "Rubik",
        ),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: emptyTheTextFormField,
          ),
        ),
        onFieldSubmitted: controlSearching,
        onChanged: controlSearching,
      ),
    );
  }

  Widget displayRecentPostsScreen() {
    return RefreshIndicator(
      onRefresh: getAllUsersPosts,
      child: gridTilesList.length == 0
          ? circularProgress()
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor,
                        fontFamily: "Rubik",
                      ),
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2)),
                        hintText: "Search here...",
                        hintStyle: TextStyle(color: Color(0xFF232323)),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: emptyTheTextFormField,
                        ),
                      ),
                      onFieldSubmitted: controlSearching,
                      onChanged: controlSearching,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gridTilesList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return gridTilesList[index];
                        }),
                  ],
                ),
              ),
            ),
    );
  }

  displayUsersFoundScreen() {
    return FutureBuilder(
      future: futureUserSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<UserResult> searchUsersResult = [];
          dataSnapshot.data.documents.forEach((document) {
            Users eachUser = Users.fromDocument(document);
            UserResult userResult = UserResult(eachUser);
            searchUsersResult.add(userResult);
          });

          return Expanded(
            child: ListView(children: searchUsersResult),
          );
        }
      },
    );
  }

  Widget displayPostsFoundScreen() {
    return Expanded(
      child: searchPostResult == null
          ? circularProgress()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  searchPostResult.length != 0
                      ? Column(
                          children: List.generate(
                            searchPostResult.length,
                            (index) => searchPostResult[index],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          child: Center(
                              child: Text(
                            "No Recipe found",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          )),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: Text("Recipes you may like"),
                  ),
                  Column(
                    children: List.generate(
                      allPosts.length,
                      (index) => allPosts[index],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  recipesAction() {
    return GestureDetector(
      onTap: () {
        setState(() {
          searchRecipes = searchRecipes ? false : true;
          controlSearching(_searchText);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.fastfood),
          ),
          title: Text(
            "Search Recipes",
            style: TextStyle(
              color: Color(0xFF1B5E20),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Rubik",
            ),
          ),
          trailing: Switch(
            value: searchRecipes,
            onChanged: (value) {
              setState(() {
                searchRecipes = value;
                controlSearching(_searchText);
              });
            },
            activeTrackColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  Widget getSelectedOption() {
    return selectedOption =
        searchRecipes ? displayPostsFoundScreen() : displayUsersFoundScreen();
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _searchText.isEmpty
          ? displayRecentPostsScreen()
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
                      fontFamily: "Rubik",
                    ),
                    controller: searchTextEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      hintText: "Search here...",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: emptyTheTextFormField,
                      ),
                    ),
                    onFieldSubmitted: controlSearching,
                    onChanged: controlSearching,
                  ),
                ),
                recipesAction(),
                getSelectedOption(),
              ],
            ),
    );
  }
}

class UserResult extends StatelessWidget {
  final Users eachUser;

  UserResult(this.eachUser);

  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userProfileId: userProfileId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  displayUserProfile(context, userProfileId: eachUser.id),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(
                  eachUser.profileName,
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubik",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostResult extends StatelessWidget {
  final Post eachPost;

  PostResult(this.eachPost);

  displayFullPost(context) {
    Navigator.of(context).pushNamed(RecipeDetailScreen.routeName, arguments: {
      'userId': eachPost.ownerId,
      'postId': eachPost.postId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => displayFullPost(context),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF1B5E20),
                  backgroundImage: CachedNetworkImageProvider(eachPost.url),
                ),
                title: Text(
                  eachPost.name,
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubik",
                  ),
                ),
                subtitle: Text(eachPost.profileName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
