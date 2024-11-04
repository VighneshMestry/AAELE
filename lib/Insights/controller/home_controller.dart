import 'dart:developer';

import 'package:aaele/Insights/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(ref: ref, homeRepository: ref.read(homeRepositoryProvider));
});

class HomeController extends StateNotifier<bool> {
  final Ref _ref;
  final HomeRepository _homeRepository;

  HomeController({
    required Ref ref,
    required HomeRepository homeRepository,
  })  : _ref = ref,
        _homeRepository = homeRepository,
        super(false);

  Future<String> getNotesForMeeting(int meetId) async {
    state = true;
    final notes = await _homeRepository.getNotesForMeeting(meetId);
    log("Controller");
    state = false;
    return notes;
  }
}
