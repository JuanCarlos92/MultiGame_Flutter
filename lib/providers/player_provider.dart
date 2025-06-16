import 'package:flutter/material.dart';
import '../models/response/player_response.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerResponse? _player;

  PlayerResponse? get player => _player;

  void setPlayer(PlayerResponse player) {
    _player = player;
    notifyListeners();
  }

  void clearPlayer() {
    _player = null;
    notifyListeners();
  }

  bool get isLoggedIn => _player != null;
}