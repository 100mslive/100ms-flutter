package Flutter.testcase.MeetingRoomTest;

import Flutter.pageobject.HomePage;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.AudioVideo;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.LeaveRoom;
import Flutter.pageobject.MeetingRoomPage.TopToolBar;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class TopToolBarTest {

    @Test
    public void Test_BackBtn() throws InterruptedException {
        System.out.println("Verify Name space Visible");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        TopToolBar topToolBar = new TopToolBar();
        LeaveRoom leaveRoom = new LeaveRoom();
        HomePage homePage = new HomePage();

        pageFlow.goto_meetingRoom_camOn_micOn();

        Assert.assertTrue(topToolBar.backBtn.isDisplayed());
        topToolBar.click_backBtn();
        Assert.assertTrue(leaveRoom.leaveRoomPopup.isDisplayed());

        Assert.assertTrue(leaveRoom.leaveRoomPopupText.isDisplayed());
        String leave_room_flag = leaveRoom.leaveRoomPopupText.getAttribute("content-desc");
        String leave_room_text = "Leave Room?";
        Assert.assertEquals(leave_room_flag, leave_room_text);

        Assert.assertTrue(leaveRoom.leaveRoomCancelBtn.isDisplayed());
        leaveRoom.click_leaveRoomCancelBtn();
        Assert.assertTrue(topToolBar.backBtn.isDisplayed());
        //add more button checks later

        leaveRoom.click_leaveRoomBtn();
        Assert.assertTrue(leaveRoom.leaveRoomYesBtn.isDisplayed());
        leaveRoom.click_leaveRoomYesBtn();

        String meeting_ended_flag = leaveRoom.meetingEndedNotification.getAttribute("content-desc");
        String meeting_ended_text = "Meeting Ended";
        Assert.assertEquals(meeting_ended_flag, meeting_ended_text);

        Assert.assertTrue(homePage.joinMeetingBtn.isDisplayed());
    }

}
