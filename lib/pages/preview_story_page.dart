import 'package:eattlystefan/models/Story.dart';
import 'package:eattlystefan/pages/HomePage.dart';
import 'package:eattlystefan/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviewStorypage extends StatefulWidget {
  @override
  _PreviewStorypageState createState() => _PreviewStorypageState();
}

class _PreviewStorypageState extends State<PreviewStorypage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: header(context, strTitle: "Preview Story"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                  stream: storyReference
                      .doc(currentUser.id)
                      .collection('userStories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    var stories = [];
                    if (snapshot.hasData) {
                      stories = snapshot.data.documents
                          .map((snapshot) => Story.fromDocument(snapshot))
                          .toList();
                    }

                    return (snapshot.hasData)
                        ? GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            // padding: EdgeInsets.all(8),
                            itemCount: stories.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) => StoryItem(
                                  story: stories[index],
                                ))

                        // ListView.builder(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     shrinkWrap: true,
                        //     itemCount: stories.length,
                        //     itemBuilder: (context, index) => StoryItem(
                        //           story: stories[index],
                        //         ))

                        : Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                            ),
                          );
                  }),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryItem extends StatefulWidget {
  final dynamic story;
  StoryItem({this.story});

  @override
  _StoryItemState createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  int totalStories = 0;

  delteStory(dynamic story) async {
    await storyReference
        .doc(currentUser.id)
        .collection('userStories')
        .doc(story.storyId)
        .delete();
    showToast();
  }

  showDialogForDeletingStory() {
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
                              "Do you want to delete the story",
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
                              delteStory(widget.story);
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
      msg: 'Story has been deleted successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          widget.story.aboutStory,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: 260,
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: FadeInImage(
                        placeholder: AssetImage('assets/image_loading.png'),
                        image: NetworkImage(widget.story.url),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: showDialogForDeletingStory,
            ),
          )
        ],
      ),
    );

    // ListTile(
    //   leading: ClipRRect(
    //     borderRadius: BorderRadius.circular(10),
    //     child: Container(
    //       width: 80,
    //       height: 80,
    //       decoration: BoxDecoration(
    //           image: DecorationImage(
    //               image: NetworkImage(widget.story.url), fit: BoxFit.fill)),
    //     ),
    //   ),
    //   title: Text(widget.story.aboutStory),
    //   subtitle: IconButton(
    //     icon: Icon(Icons.delete),
    //     onPressed: showDialogForDeletingStory,
    //   ),
    // );
  }
}
