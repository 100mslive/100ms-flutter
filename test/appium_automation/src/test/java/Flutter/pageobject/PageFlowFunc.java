package Flutter.pageobject;

import Flutter.pageobject.MeetingRoomPage.BottomToolBar.LeaveRoom;
import Flutter.pageobject.MeetingRoomPage.TopToolBar;
import Flutter.pageobject.PagesCommon;

public class PageFlowFunc extends PagesCommon{
    public String meeting_url = "https://ronitroy-xyz.app.100ms.live/meeting/kfg-ahl-lxm";
    public String participant_name = "Ronit Roy";

    public void goto_enter_participant_name_page() throws InterruptedException {
        HomePage homePage = new HomePage();

        homePage.clear_meeting_url();
        homePage.put_meeting_url(meeting_url);
        homePage.click_joinMeetingBtn();
    }

    public void goto_preview_page() throws InterruptedException {
        HomePage homePage = new HomePage();

        homePage.clear_meeting_url();
        homePage.put_meeting_url(meeting_url);
        homePage.click_joinMeetingBtn();
        homePage.put_participant_name(participant_name);
        homePage.click_okBtn();
        homePage.accept_permission();
        homePage.accept_permission();
    }

    public void goto_meetingRoom_camOff_micOff() throws InterruptedException {
        HomePage homePage = new HomePage();
        PreviewPage previewPage = new PreviewPage();

        homePage.clear_meeting_url();
        homePage.put_meeting_url(meeting_url);
        homePage.click_joinMeetingBtn();
        homePage.put_participant_name(participant_name);
        homePage.click_okBtn();
        homePage.accept_permission();
        homePage.accept_permission();

        previewPage.click_camBtn();
        previewPage.click_micBtn();
        previewPage.click_joinNowBtn();
    }

    public void goto_meetingRoom_camOn_micOn() throws InterruptedException {
        HomePage homePage = new HomePage();
        PreviewPage previewPage = new PreviewPage();

        homePage.clear_meeting_url();
        homePage.put_meeting_url(meeting_url);
        homePage.click_joinMeetingBtn();
        homePage.put_participant_name(participant_name);
        homePage.click_okBtn();
        homePage.accept_permission();
        homePage.accept_permission();

        previewPage.click_joinNowBtn();
    }

    public void goto_meetingRoom_menuDropDown() throws InterruptedException {
        HomePage homePage = new HomePage();
        PreviewPage previewPage = new PreviewPage();
        TopToolBar topToolBar = new TopToolBar();

        homePage.clear_meeting_url();
        homePage.put_meeting_url(meeting_url);
        homePage.click_joinMeetingBtn();
        homePage.put_participant_name(participant_name);
        homePage.click_okBtn();
        homePage.accept_permission();
        homePage.accept_permission();
        previewPage.click_joinNowBtn();
        topToolBar.click_menuBtn();
    }

    public void leave_room() throws InterruptedException {
        LeaveRoom leaveRoom = new LeaveRoom();
        leaveRoom.click_leaveRoomBtn();
        leaveRoom.click_leaveRoomYesBtn();
    }
}
