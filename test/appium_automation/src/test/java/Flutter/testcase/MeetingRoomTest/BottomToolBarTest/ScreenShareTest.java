package Flutter.testcase.MeetingRoomTest.BottomToolBarTest;

import Flutter.pageobject.MeetingRoomPage.BottomToolBar.RaiseHand;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.ScreenShare;
import Flutter.pageobject.PageFlowFunc;
import base.AppDriver;
import org.testng.Assert;
import org.testng.annotations.Test;

public class ScreenShareTest {

    @Test
    public void Test_ScreenShare() throws InterruptedException {
        System.out.println("Verify Screen share");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        ScreenShare screenShare = new ScreenShare();

        pageFlow.goto_meetingRoom_camOn_micOn();
        Assert.assertTrue(screenShare.screenShareBtn.isDisplayed());
        screenShare.click_screenShareBtn();

        Assert.assertTrue(screenShare.screenShareCancelBtn.isDisplayed());
        screenShare.click_screenShareCancelBtn();
        boolean x = screenShare.screenShareTile.isDisplayed();
        System.out.println(x);
        //not able to check as the xpath is not unique & ss-xpath still exists when screen share is stopped
        Assert.assertFalse(screenShare.screenShareTile.isDisplayed());

        screenShare.click_screenShareBtn();
        Assert.assertTrue(screenShare.screenShareStartNowBtn.isDisplayed());
        screenShare.click_screenShareStartNowBtn();
        Assert.assertFalse(screenShare.screenShareTile.isDisplayed());

        pageFlow.leave_room();

    }

}
