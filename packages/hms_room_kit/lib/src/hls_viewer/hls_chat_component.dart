///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[HLSChatComponent] is a component that is used to show the chat
class HLSChatComponent extends StatefulWidget {
  final double? height;
  const HLSChatComponent({super.key, this.height});

  @override
  State<HLSChatComponent> createState() => _HLSChatComponentState();
}

class _HLSChatComponentState extends State<HLSChatComponent> {
  TextEditingController messageTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    messageTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ///This function scrolls to the end of the list
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut));
  }

  ///This function sends the message
  void _sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;
    meetingStore.sendBroadcastMessage(message);
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: widget.height ?? MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            ///Chat Header
            Expanded(
              child: Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.messages, meetingStore.messages.length),
                  builder: (context, data, _) {
                    _scrollToEnd();
                    return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: data.item1.length,
                        itemBuilder: (_, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HMSTitleText(
                                text: data.item1[index].sender?.name ??
                                    "Anonymous",
                                textColor: Colors.white,
                                fontSize: 14,
                                lineHeight: 20,
                                letterSpacing: 0.1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SelectableLinkify(
                                text: data.item1[index].message,
                                onOpen: (link) async {
                                  Uri url = Uri.parse(link.url);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                                options: const LinkifyOptions(humanize: false),
                                style: HMSTextStyle.setTextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  letterSpacing: 0.25,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              )
                            ],
                          );
                        });
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HMSThemeColors.surfaceDim),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  if (messageTextController.text.trim().isEmpty) {
                    Utilities.showToast("Message can't be empty");
                    return;
                  }
                  _sendMessage();
                },
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                style: HMSTextStyle.setTextStyle(
                    color: HMSThemeColors.onSurfaceHighEmphasis,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    fontSize: 14,
                    letterSpacing: 0.25),
                controller: messageTextController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (messageTextController.text.trim().isEmpty) {
                            Utilities.showToast("Message can't be empty");
                          }
                          _sendMessage();
                        },
                        icon: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/send_message.svg",
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                              messageTextController.text.isEmpty
                                  ? HMSThemeColors.onSurfaceLowEmphasis
                                  : HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                        )),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: HMSThemeColors.primaryDefault),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    hintStyle: HMSTextStyle.setTextStyle(
                        color: HMSThemeColors.onSurfaceLowEmphasis,
                        fontSize: 14,
                        height: 0.6,
                        letterSpacing: 0.25,
                        fontWeight: FontWeight.w400),
                    contentPadding: const EdgeInsets.only(
                        left: 16, right: 8, top: 0, bottom: 0),
                    hintText: "Send a message..."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
