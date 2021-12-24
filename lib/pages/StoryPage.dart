import 'package:eattlystefan/models/Story.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

enum UrlType { IMAGE, UNKNOWN, VIDEO }

class StoryPage extends StatefulWidget {
  final List<List<Story>> stories;
  final List<Story> selectedUserStories;

  StoryPage({this.stories, this.selectedUserStories});
  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  PageController pageController;
  var firstPage;

  @override
  void initState() {
    super.initState();
    print(widget.stories.length);
    for (final stories in widget.stories) {
      if (stories[0].ownerId == widget.selectedUserStories[0].ownerId) {
        firstPage = stories;
      }
    }
    final initialPage = widget.stories.indexOf(firstPage);
    print('selectedUserStories: ${widget.selectedUserStories[0].aboutStory}');
    pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: pageController,
        children: widget.stories
            .map((story) => StoryWidget(
                  allStories: widget.stories,
                  storiesOfAuser: story,
                  pageController: pageController,
                ))
            .toList());
  }
}

class StoryWidget extends StatefulWidget {
  final List<Story> storiesOfAuser;
  final List<List<Story>> allStories;
  final PageController pageController;

  StoryWidget({this.storiesOfAuser, this.pageController, this.allStories});
  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyItems = <StoryItem>[];
  StoryController controller;

  UrlType getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg") {
      return UrlType.IMAGE;
    } else {
      return UrlType.UNKNOWN;
    }
  }

  void addStoryItems() {
    for (final story in widget.storiesOfAuser) {
      var urlType = getUrlType(story.url);
      switch (urlType) {
        case UrlType.IMAGE:
          storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: controller,
            caption: story.aboutStory,
            duration: Duration(
              seconds: 5,
            ),
          ));
          break;

        case UrlType.VIDEO:
          storyItems.add(StoryItem.pageVideo(
            story.url,
            controller: controller,
          ));
          break;

        case UrlType.UNKNOWN:
          storyItems.add(StoryItem.text(
              title: story.aboutStory, backgroundColor: Colors.green));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller = StoryController();
    addStoryItems();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleCompleted() {
    widget.pageController.nextPage(
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeIn,
    );

    final currentIndex = widget.allStories.indexOf(widget.storiesOfAuser);
    final isLastPage = widget.allStories.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Material(
          type: MaterialType.transparency,
          child: StoryView(
            storyItems: storyItems,
            controller: controller,
            onComplete: handleCompleted,
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            },
            onStoryShow: (storyItem) {
              final index = storyItems.indexOf(storyItem);

              if (index > 0) {
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }
}
