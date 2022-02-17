package Flutter.testcase.MeetingRoomTest.BottomToolBarTest;

import Flutter.pageobject.MeetingRoomPage.BottomToolBar.RaiseHand;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class RaiseHandTest {

    @Test
    public void Test_RaiseHand() throws InterruptedException {
        System.out.println("Verify Raise Hand Feature");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        RaiseHand raiseHand = new RaiseHand();

        pageFlow.goto_meetingRoom_camOn_micOn();
        Assert.assertTrue(raiseHand.raiseHandBtn.isDisplayed());

        raiseHand.click_raiseHandBtn();
        Assert.assertTrue(raiseHand.raiseHandOnNotifictaion.isDisplayed());
        String raise_hand_flag = raiseHand.raiseHandOnNotifictaion.getAttribute("content-desc");
        String raise_hand_text = "Raised Hand ON";
        Assert.assertEquals(raise_hand_flag, raise_hand_text);

        raiseHand.click_raiseHandBtn();
        Assert.assertTrue(raiseHand.raiseHandOffNotifictaion.isDisplayed());
        raise_hand_flag = raiseHand.raiseHandOffNotifictaion.getAttribute("content-desc");
        raise_hand_text = "Raised Hand OFF";
        Assert.assertEquals(raise_hand_flag, raise_hand_text);

        pageFlow.leave_room();
    }

}
