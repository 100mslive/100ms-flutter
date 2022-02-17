package Flutter.testcase.MeetingRoomTest.BottomToolBarTest;

import Flutter.pageobject.HomePage;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.LeaveRoom;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.RaiseHand;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class LeaveRoomTest {

    @Test
    public void Test_RaiseHand() throws InterruptedException {
        System.out.println("Verify Participant Leave Room");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        LeaveRoom leaveRoom = new LeaveRoom();
        HomePage homePage = new HomePage();

        pageFlow.goto_meetingRoom_camOn_micOn();
        Assert.assertTrue(leaveRoom.leaveRoomBtn.isDisplayed());

        leaveRoom.click_leaveRoomBtn();
        Assert.assertTrue(leaveRoom.leaveRoomPopup.isDisplayed());

        Assert.assertTrue(leaveRoom.leaveRoomPopupText.isDisplayed());
        String leave_room_flag = leaveRoom.leaveRoomPopupText.getAttribute("content-desc");
        String leave_room_text = "Leave Room?";
        Assert.assertEquals(leave_room_flag, leave_room_text);

        Assert.assertTrue(leaveRoom.leaveRoomCancelBtn.isDisplayed());
        leaveRoom.click_leaveRoomCancelBtn();
        Assert.assertTrue(leaveRoom.leaveRoomBtn.isDisplayed());
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
