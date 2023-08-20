import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class HLSChatComponent extends StatefulWidget {
  const HLSChatComponent({super.key});

  @override
  State<HLSChatComponent> createState() => _HLSChatComponentState();
}

class _HLSChatComponentState extends State<HLSChatComponent> {
  TextEditingController messageTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut));
  }

  void sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    String message = messageTextController.text;
    if (message.isEmpty) return;
    meetingStore.sendBroadcastMessage(message);
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 192,
        child: Column(
          children: [
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
                                style: GoogleFonts.inter(
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
              height: 40,
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HMSThemeColors.backgroundDim),
              child: TextField(
                cursorColor: HMSThemeColors.primaryDefault,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.inter(
                    color: HMSThemeColors.onSurfaceHighEmphasis),
                controller: messageTextController,
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: () {
                          if (messageTextController.text.isEmpty) {
                            Utilities.showToast("Message can't be empty");
                          }
                          sendMessage();
                        },
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/send_message.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceLowEmphasis,
                              BlendMode.srcIn),
                          fit: BoxFit.scaleDown,
                        )),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: HMSThemeColors.primaryDefault),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    hintStyle: GoogleFonts.inter(
                        color: HMSThemeColors.onSurfaceLowEmphasis,
                        fontSize: 14,
                        height: 0.8,
                        letterSpacing: 0.25,
                        fontWeight: FontWeight.w400),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    hintText: "Send a message..."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
