import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:redditify/models/post.dart';
import 'package:redditify/services/play_audio_service.dart';

class PlayerState with ChangeNotifier {
  final PlayAudioService _playAudioService = PlayAudioService();
  bool _isPlaying = false;
  List<Post> _playlist = [];
  String _playlistName;
  int _currentSongIndex;
  AudioPlayerState _audioPlayerState;
  String _currentSongTitle;

  PlayAudioService get playAudioService => _playAudioService;
  bool get isPlaying => _isPlaying;
  List<Post> get playlist => List.from(_playlist);
  String get playlistName => _playlistName;
  int get currentSongIndex => _currentSongIndex;
  AudioPlayerState get audioPlayerState => _audioPlayerState;
  String get currentSongTitle => _currentSongTitle;

  bool get canPlayPrevious => _playlist.isNotEmpty && _currentSongIndex > 0;
  bool get canPlayNext =>
      _playlist.isNotEmpty && _currentSongIndex < _playlist.length;

  PlayerState() {
    _playAudioService.audioPlayer.onPlayerStateChanged
        .listen((AudioPlayerState state) {
      _audioPlayerState = state;
      notifyListeners();
    });
  }

  Future<void> playSong(String youtubeUrl, String title) async {
    _playlist = [];
    _currentSongTitle = title;
    _isPlaying = true;
    notifyListeners();

    await _playAudioService.playAudio(youtubeUrl);
  }

  Future<void> playSongList(List<Post> playlist) async {
    _playlist = playlist;
    _currentSongIndex = 0;
    _currentSongTitle = _playlist[_currentSongIndex].title;
    _playAudioService.playAudio(_playlist.first.url);
    _isPlaying = true;
    notifyListeners();
    _playAudioService.audioPlayer.onPlayerCompletion.listen((event) {
      if (canPlayNext) {
        try {
          playNextSong();
        } catch (e) {
          print("unable to load song");
          playNextSong();
        }
      } else {
        stopAudio();
      }
    });
  }

  Future<void> stopAudio() async {
    _playAudioService.audioPlayer.stop();
    _currentSongIndex = 0;
    _playlist = [];
    _currentSongTitle = null;
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> playNextSong() async {
    if (canPlayNext) {
      _currentSongIndex++;
      _currentSongTitle = _playlist[_currentSongIndex].title;
      notifyListeners();
      _playAudioService.playAudio(_playlist[_currentSongIndex].url);
    }
  }

  Future<void> playPreviousSong() async {
    if (canPlayPrevious) {
      _currentSongIndex--;
      _currentSongTitle = _playlist[_currentSongIndex].title;
      notifyListeners();
      _playAudioService.playAudio(_playlist[_currentSongIndex].url);
    }
  }

  Future<void> pauseAudio() async {
    _playAudioService.audioPlayer.pause();
  }

  Future<void> resumeAudio() async {
    _playAudioService.audioPlayer.resume();
  }

  void setPlaylistName(String name) {
    _playlistName = name;
    notifyListeners();
  }
}
