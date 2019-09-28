import 'package:flutter/foundation.dart';
import 'package:redditify/models/post.dart';
import 'package:redditify/services/play_audio_service.dart';

class PlayerState with ChangeNotifier {
  final PlayAudioService _playAudioService = PlayAudioService();
  bool _isPlaying = false;
  List<Post> _playlist = [];
  int _currentSongIndex;

  PlayAudioService get playAudioService => _playAudioService;
  bool get isPlaying => _isPlaying;
  List<Post> get playlist => List.from(_playlist);
  int get currentSongIndex => _currentSongIndex;

  Future<void> playSong(String youtubeUrl) async {
    _isPlaying = true;
    notifyListeners();

    await _playAudioService.playAudio(youtubeUrl);
  }

  Future<void> playSongList(List<Post> playlist) async {
    _playlist = playlist;
    _currentSongIndex = 0;
    _playAudioService.playAudio(_playlist.first.url);
    _isPlaying = true;
    notifyListeners();
    _playAudioService.audioPlayer.onPlayerCompletion.listen((event) {
      _currentSongIndex++;
      _playAudioService.playAudio(_playlist[_currentSongIndex].url);
    });
  }

  Future<void> stopAudio() async {
    _playAudioService.audioPlayer.stop();
    _isPlaying = false;
    notifyListeners();
  }
}
