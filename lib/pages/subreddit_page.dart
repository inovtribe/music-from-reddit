import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditify/presenters/player/player_bottom_sheet.dart';
import 'package:redditify/presenters/player/player_button_visibility.dart';
import 'package:redditify/presenters/posts/posts_count.dart';
import 'package:redditify/presenters/posts/posts_list.dart';
import 'package:redditify/presenters/subreddits/subreddit_sort_wrap.dart';
import 'package:redditify/states/global_state.dart';
import 'package:redditify/states/subreddits_state.dart';
import 'package:sailor/sailor.dart';

class SubredditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String subreddit = Sailor.param<String>(context, 'subreddit');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SubredditsState>.value(
          value: Provider.of<GlobalState>(context).subredditsState,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("r/$subreddit"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Column(
            children: <Widget>[
              SubredditSortWrap(),
              PlayerButtonVisibility(),
              PostsCount(),
              PostsList(),
              
            ],
          ),
        ),
        bottomSheet: PlayerBottomSheet(),
      ),
    );
  }
}
