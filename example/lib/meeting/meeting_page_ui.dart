import 'package:flutter/widgets.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';


class MeetingPageUI extends StatefulWidget {
  int index;
  List<HMSTrack> filteredList;
  double itemHeight;
  double itemWidth;
  Map<String, HMSTrackUpdate> map;

  MeetingPageUI(
      {required this.index,
      required this.filteredList,
      required this.itemWidth,
      required this.itemHeight,
      required this.map})
      : super();

  @override
  State<MeetingPageUI> createState() => _MeetingPageUIState();
}

class _MeetingPageUIState extends State<MeetingPageUI> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    print("Orientation $orientation}");
    return (widget.index < widget.filteredList.length && widget.filteredList[widget.index].source != "SCREEN")
        ? ((orientation == Orientation.portrait)
            ? Column(
                children: [
                  Row(
                    children: [
                      //if (index * 4 < filteredList.length)
                      VideoTile(
                          tileIndex: widget.index * 4,
                          filteredList: widget.filteredList,
                          itemHeight: widget.itemHeight,
                          itemWidth: widget.itemWidth,
                          map: widget.map),
                      //if (index * 4 + 1 < filteredList.length)
                      VideoTile(
                          tileIndex: widget.index * 4 + 1,
                          filteredList: widget.filteredList,
                          itemHeight: widget.itemHeight,
                          itemWidth: widget.itemWidth,
                          map: widget.map),
                    ],
                  ),
                  Row(
                    children: [
                      //if (index * 4 + 2 < filteredList.length)
                      VideoTile(
                          tileIndex: widget.index * 4 + 2,
                          filteredList: widget.filteredList,
                          itemHeight: widget.itemHeight,
                          itemWidth: widget.itemWidth,
                          map: widget.map),
                      //if (index * 4 + 3 < filteredList.length)
                      VideoTile(
                          tileIndex: widget.index * 4 + 3,
                          filteredList: widget.filteredList,
                          itemHeight: widget.itemHeight,
                          itemWidth: widget.itemWidth,
                          map: widget.map),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      VideoTile(
                          tileIndex: widget.index * 2,
                          filteredList: widget.filteredList,
                          itemHeight: widget.itemHeight * 2 - 50,
                          itemWidth: widget.itemWidth,
                          map: widget.map),
                      VideoTile(
                          tileIndex: widget.index * 2 + 1,
                          filteredList: widget.filteredList,
                          itemHeight: widget.itemHeight * 2 - 50,
                          itemWidth: widget.itemWidth,
                          map: widget.map),
                    ],
                  ),
                ],
              ))
        : Container(
            child: VideoTile(
                tileIndex: 0,
                filteredList: widget.filteredList,
                itemHeight: widget.itemHeight * 2,
                itemWidth: widget.itemWidth * 2,
                map: widget.map),
          );
  }
}
