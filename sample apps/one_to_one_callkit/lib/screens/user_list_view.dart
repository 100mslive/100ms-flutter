///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:one_to_one_callkit/call_type.dart';
import 'package:one_to_one_callkit/services/app_utilities.dart';
import 'package:one_to_one_callkit/services/user_data_model.dart';
import 'package:one_to_one_callkit/services/user_data_store.dart';

///[UserListView] class is used to show the list of users
class UserListView extends StatefulWidget {
  final AppUtilities? appUtilities;

  const UserListView({super.key, required this.appUtilities});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HMSTitleText(
            text: "New Call",
            textColor: HMSThemeColors.onSurfaceHighEmphasis,
            fontSize: 24,
            lineHeight: 32,
          ),
          const SizedBox(
            height: 16,
          ),

          ///This renders the search box
          SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                fillColor: HMSThemeColors.surfaceDefault,
                hintText: '🔎 Search...',
                hintStyle: HMSTextStyle.setTextStyle(
                    color: HMSThemeColors.onSurfaceLowEmphasis,
                    height: 1.4,
                    fontSize: 14,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.w400),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: HMSThemeColors.primaryDefault),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (value) => {
                setState(() {
                  searchText = value;
                })
              },
              style: HMSTextStyle.setTextStyle(
                  color: HMSThemeColors.onSurfaceHighEmphasis),
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Selector<UserDataStore, Tuple2<int, List<UserDataModel>>>(
              selector: (_, userDataStore) =>
                  Tuple2(userDataStore.users.length, userDataStore.users),
              builder: (_, data, __) {
                final filteredUsers = data.item2
                    .where((user) => user.userName
                        .toLowerCase()
                        .contains(searchText.toLowerCase()))
                    .toList();
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        context.read<UserDataStore>().getUsers(),
                    child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: 8,
                            dense: true,
                            leading: CircleAvatar(
                              backgroundColor: HMSThemeColors.primaryDefault,
                              radius: 16,
                              child: data.item2[index].imgUrl == null
                                  ? HMSTitleText(
                                      text: user.userName[0],
                                      textColor:
                                          HMSThemeColors.onSurfaceHighEmphasis,
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                        user.imgUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            title: HMSTitleText(
                              text: user.userName,
                              textColor: HMSThemeColors.onSurfaceHighEmphasis,
                              fontSize: 12,
                              lineHeight: 20,
                              letterSpacing: 0.1,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      widget.appUtilities
                                          ?.sendMessage(user, CallType.audio);
                                    },
                                    icon: Icon(
                                      Icons.call_outlined,
                                      color: HMSThemeColors.primaryDefault,
                                      size: 24,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      widget.appUtilities
                                          ?.sendMessage(user, CallType.video);
                                    },
                                    icon: Icon(
                                      Icons.videocam_outlined,
                                      color: HMSThemeColors.primaryDefault,
                                      size: 24,
                                    ))
                              ],
                            ),
                          );
                        }),
                  ),
                );
              })
        ],
      ),
    );
  }
}
