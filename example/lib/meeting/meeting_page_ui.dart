import 'package:flutter/widgets.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';


class MeetingPageUI extends StatelessWidget {
  int index;
  List<HMSTrack> filteredList;
  Orientation orientation;
  double itemHeight;
  double itemWidth;
  Map<String, HMSTrackUpdate> map;

  MeetingPageUI(
      {required this.index,
      required this.filteredList,
      required this.orientation,
      required this.itemWidth,
      required this.itemHeight,
      required this.map})
      : super();

  @override
  Widget build(BuildContext context) {
    return (index < filteredList.length &&
            filteredList[index].source != "SCREEN")
        ? ((orientation == Orientation.portrait)
            ? Column(
                children: [
                  Row(
                    children: [
                      //if (index * 4 < filteredList.length)
                      VideoTile(
                          tileIndex: index * 4,
                          filteredList: filteredList,
                          itemHeight: itemHeight,
                          itemWidth: itemWidth,
                          map: map),
                      //if (index * 4 + 1 < filteredList.length)
                      VideoTile(
                          tileIndex: index * 4 + 1,
                          filteredList: filteredList,
                          itemHeight: itemHeight,
                          itemWidth: itemWidth,
                          map: map),
                    ],
                  ),
                  Row(
                    children: [
                      //if (index * 4 + 2 < filteredList.length)
                      VideoTile(
                          tileIndex: index * 4 + 2,
                          filteredList: filteredList,
                          itemHeight: itemHeight,
                          itemWidth: itemWidth,
                          map: map),
                      //if (index * 4 + 3 < filteredList.length)
                      VideoTile(
                          tileIndex: index * 4 + 3,
                          filteredList: filteredList,
                          itemHeight: itemHeight,
                          itemWidth: itemWidth,
                          map: map),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      VideoTile(
                          tileIndex: index * 2,
                          filteredList: filteredList,
                          itemHeight: itemHeight * 2 - 50,
                          itemWidth: itemWidth,
                          map: map),
                      VideoTile(
                          tileIndex: index * 2 + 1,
                          filteredList: filteredList,
                          itemHeight: itemHeight * 2 - 50,
                          itemWidth: itemWidth,
                          map: map),
                    ],
                  ),
                ],
              ))
        : Container(
            child: VideoTile(
                tileIndex: 0,
                filteredList: filteredList,
                itemHeight: itemHeight * 2,
                itemWidth: itemWidth * 2,
                map: map),
          );
  }
}
