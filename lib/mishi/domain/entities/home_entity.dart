import 'package:equatable/equatable.dart';

import 'music_entity.dart';

class HomeMusic extends Equatable {
  final String? tag;

  final int? tagOrder;
  final List<MusicEntity> data;

  const HomeMusic({required this.tag, required this.data, this.tagOrder});

  @override
  List<Object?> get props => [tag];
}
