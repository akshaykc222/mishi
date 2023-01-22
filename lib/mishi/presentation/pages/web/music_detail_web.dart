import 'package:flutter/material.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';

class MusicDetailWeb extends StatefulWidget {
  final MusicEntity musicEntity;

  const MusicDetailWeb({Key? key, required this.musicEntity}) : super(key: key);

  @override
  State<MusicDetailWeb> createState() => _MusicDetailWebState();
}

class _MusicDetailWebState extends State<MusicDetailWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController iconAnimationController;
  // final controller = Get.find<MusicDetailControllerWeb>();
  late String name;
  late String desc;
  late String image;
  late String smallImage;
  late MusicEntity entity;
  @override
  void initState() {
    entity = widget.musicEntity;
    name = widget.musicEntity.musicName;
    desc = widget.musicEntity.musicDescription;
    image = widget.musicEntity.largeImageUrl;
    smallImage = widget.musicEntity.smallImageUrl;
    iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    // controller.getAllCompositions(widget.musicEntity.musicId);
    super.initState();
  }

  @override
  void dispose() {
    // for (var element in controller.compositionAudioPlayers) {
    //   element.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
