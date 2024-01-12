///Package imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[PinChatWidget] renders the pinned message widget
class PinChatWidget extends StatefulWidget {
  final Color? backgroundColor;

  const PinChatWidget({Key? key, this.backgroundColor}) : super(key: key);

  @override
  State<PinChatWidget> createState() => _PinChatWidgetState();
}

class _PinChatWidgetState extends State<PinChatWidget> {
  int currentPage = 0;
  PageController? _pageController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void setCurrentPage(int page) {
    if (page >= 3) {
      page = 0;
    }
    setState(() {
      currentPage = page;
      _pageController?.jumpToPage(currentPage);
    });
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///If there are no pinnedMessage we render an empty SizedBox
    ///else we render the pinned message widget
    return Selector<MeetingStore, Tuple2<List<dynamic>, int>>(
        selector: (_, meetingStore) => Tuple2(
            meetingStore.pinnedMessages.reversed.toList(),
            meetingStore.pinnedMessages.length),
        builder: (_, data, __) {
          return data.item2 == 0
              ? const SizedBox()
              : GestureDetector(
                  onTap: () => toggleExpand(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          height: MediaQuery.of(context).size.height *
                              (isExpanded ? 0.13 : 0.09),
                          width:
                              (HMSRoomLayout.chatData?.allowPinningMessages ??
                                      false)
                                  ? MediaQuery.of(context).size.width * 0.83
                                  : MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: widget.backgroundColor ??
                                  HMSThemeColors.surfaceDefault),
                          duration: const Duration(milliseconds: 0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (data.item2 > 1)
                                  DotsIndicator(
                                    axis: Axis.vertical,
                                    mainAxisSize: MainAxisSize.min,
                                    dotsCount: data.item2,
                                    position: currentPage >= data.item2
                                        ? 0
                                        : currentPage,
                                    decorator: DotsDecorator(
                                      spacing: const EdgeInsets.only(
                                          bottom: 3.0, right: 8),
                                      size: Size(2.0, isExpanded ? 24 : 9.0),
                                      activeSize:
                                          Size(2.0, isExpanded ? 24 : 9.0),
                                      color:
                                          HMSThemeColors.onSurfaceLowEmphasis,
                                      activeColor:
                                          HMSThemeColors.onSurfaceHighEmphasis,
                                      activeShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                    ),
                                    onTap: (position) =>
                                        setCurrentPage(position),
                                  ),
                                Expanded(
                                  child: PageView.builder(
                                    scrollDirection: Axis.vertical,
                                    controller: _pageController,
                                    itemCount: data.item2,
                                    physics: const PageScrollPhysics(),
                                    onPageChanged: (value) =>
                                        setCurrentPage(value),
                                    itemBuilder: (context, index) =>
                                        SelectableLinkify(
                                      maxLines: 3,
                                      scrollPhysics: isExpanded
                                          ? const BouncingScrollPhysics()
                                          : const NeverScrollableScrollPhysics(),
                                      text: data.item1[index]["text"],
                                      onOpen: (link) async {
                                        Uri url = Uri.parse(link.url);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      },
                                      onTap: () => toggleExpand(),
                                      options:
                                          const LinkifyOptions(humanize: false),
                                      style: HMSTextStyle.setTextStyle(
                                        fontSize: 14.0,
                                        color: HMSThemeColors
                                            .onSurfaceHighEmphasis,
                                        letterSpacing: 0.25,
                                        height: 20 / 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      linkStyle: HMSTextStyle.setTextStyle(
                                          fontSize: 14.0,
                                          color: HMSThemeColors.primaryDefault,
                                          letterSpacing: 0.25,
                                          height: 20 / 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (HMSRoomLayout.chatData?.allowPinningMessages ??
                            false)
                          GestureDetector(
                            onTap: () => context
                                .read<MeetingStore>()
                                .unpinMessage(data.item1[currentPage]["id"]),
                            child: SvgPicture.asset(
                              "packages/hms_room_kit/lib/src/assets/icons/unpin.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onSurfaceMediumEmphasis,
                                  BlendMode.srcIn),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
        });
  }
}
