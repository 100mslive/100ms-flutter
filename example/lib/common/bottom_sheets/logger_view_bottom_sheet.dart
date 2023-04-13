//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/service/constant.dart';
import 'package:provider/provider.dart';

class HMSLoggerViewBottomSheet extends StatefulWidget {
  @override
  State<HMSLoggerViewBottomSheet> createState() =>
      _HMSLoggerViewBottomSheetState();
}

class _HMSLoggerViewBottomSheetState extends State<HMSLoggerViewBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.81,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: themeBottomSheetColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Live Logs View",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/icons/close_button.svg",
                              width: 40,
                            ),
                            onPressed: () {
                              context
                                  .read<MeetingStore>()
                                  .filteredPeers
                                  .clear();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "WebRTC log level: ${Constant.webRTCLogLevel.name}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: themeDefaultColor,
                  ),
                ),
                Text(
                  "SDK log level: ${Constant.sdkLogLevel.name}",
                  style: GoogleFonts.inter(
                    color: themeDefaultColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Divider(
                    color: dividerColor,
                    height: 5,
                  ),
                ),
                Selector<MeetingStore, HMSLogList?>(
                    selector: (_, meetingStore) => meetingStore.applicationLogs,
                    builder: (_, data, __) {
                      if (data != null && data.hmsLog.length > 0) {
                        _scrollToEnd();
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.60,
                        child: (data == null || data.hmsLog.length == 0)
                            ? Container(
                                child: Center(
                                  child: SubtitleText(
                                      text: "No logs found",
                                      textColor: themeDefaultColor),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: data.hmsLog.length,
                                itemBuilder: (context, index) {
                                  return Text(data.hmsLog[index],
                                      softWrap: true,
                                      style: GoogleFonts.inter(
                                          height: 16 / 12,
                                          fontSize: 12,
                                          letterSpacing: 0.4,
                                          color: themeDefaultColor,
                                          fontWeight: FontWeight.w400));
                                }),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
