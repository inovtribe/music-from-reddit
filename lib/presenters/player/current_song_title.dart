import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditify/states/player_state.dart';
import 'package:redditify/utils/colors.dart';

class CurrentSongTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(
      builder: (context, state, _) {
        return Expanded(
          flex: 8,
          child: Text(
            state.currentSongTitle ?? "No current song playing.",
            textAlign: TextAlign.center,
            style: TextStyle(color: lightGreyColor),
          ),
        );
      },
    );
  }
}
