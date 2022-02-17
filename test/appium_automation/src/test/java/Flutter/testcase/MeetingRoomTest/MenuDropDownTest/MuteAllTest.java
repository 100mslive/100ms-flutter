package Flutter.testcase.MeetingRoomTest.MenuDropDownTest;

import Flutter.pageobject.HomePage;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.LeaveRoom;
import Flutter.pageobject.MeetingRoomPage.MenuDropDown.EndRoom;
import Flutter.pageobject.MeetingRoomPage.MenuDropDown.MuteAll;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class MuteAllTest {

    @Test
    public void Test_MuteAll() throws InterruptedException {
        System.out.println("Verify mute all");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        MuteAll muteAll = new MuteAll();

        pageFlow.goto_meetingRoom_menuDropDown();
        Assert.assertTrue(muteAll.muteAllBtn.isDisplayed());
        muteAll.click_muteAllBtn();

        Assert.assertTrue(muteAll.muteAllNotification.isDisplayed());
        String mute_all_flag = muteAll.muteAllNotification.getAttribute("content-desc");
        String mute_all_text = "Successfully Muted All";
        Assert.assertEquals(mute_all_flag, mute_all_text);

        pageFlow.leave_room();
    }

}
