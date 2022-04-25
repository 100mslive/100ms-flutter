package com.qa.tests.MeetingRoomTest.BottomToolBarTest;

import com.qa.BaseTest;
import com.qa.pages.HomePage;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.BottomToolBar.RaiseHand;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.pages.PageFlowFunc;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.Assert;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class RaiseHandTest extends BaseTest {

    MeetingRoom meetingRoom;
    RaiseHand raiseHand;
    JSONObject meetingDetail;
    TestUtils utils = new TestUtils();
    SoftAssert sa;

    @BeforeClass
    public void beforeClass() throws Exception {
      InputStream datais = null;
      try {
        String dataFileName = "data/meetingDetail.json";
        datais = getClass().getClassLoader().getResourceAsStream(dataFileName);
        JSONTokener tokener = new JSONTokener(datais);
        meetingDetail = new JSONObject(tokener);
      } catch(Exception e) {
        e.printStackTrace();
        throw e;
      } finally {
        if(datais != null) {
          datais.close();
        }
      }
    }

    @AfterClass
    public void afterClass() {
    }

    @BeforeMethod
    public void beforeMethod(Method m) throws InterruptedException {
      closeApp();
      launchApp();
      utils.log().info("\n" + "****** starting test:" + m.getName() + "******" + "\n");
      sa = new SoftAssert();
      meetingRoom = new MeetingRoom();
      raiseHand = new RaiseHand();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
      LeaveRoom leaveRoom = new LeaveRoom();
<<<<<<< HEAD
      leaveRoom.leave_endRoomForAll();
=======
      leaveRoom.leave_withoutEndingRoom();
>>>>>>> newapp
    }

    @Test
    public void Test_RaiseHand() throws InterruptedException {
        System.out.println("Verify Raise Hand Feature");
        Thread.sleep(2000);
<<<<<<< HEAD
      meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
        meetingDetail.getJSONObject("valid").getString("username"),
        meetingDetail.getJSONObject("camera").getString("ON"),
        meetingDetail.getJSONObject("mic").getString("ON"));


        sa.assertTrue(raiseHand.raiseHandBtn.isDisplayed());

      click(raiseHand.raiseHandBtn);
        sa.assertTrue(raiseHand.raiseHandOnTile.isDisplayed());

      click(raiseHand.raiseHandOnTile);
=======
        meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
            meetingDetail.getJSONObject("valid").getString("username"),
            meetingDetail.getJSONObject("camera").getString("ON"),
            meetingDetail.getJSONObject("mic").getString("ON"));

        sa.assertTrue(raiseHand.raiseHandBtn.isDisplayed());

        click(raiseHand.raiseHandBtn);
        sa.assertTrue(raiseHand.raiseHandOnNotifictaion.isDisplayed());
        String raise_hand_flag = raiseHand.raiseHandOnNotifictaion.getAttribute("content-desc");
        String raise_hand_text = getStrings().get("raise_hand_on");;
        sa.assertEquals(raise_hand_flag, raise_hand_text);

        Thread.sleep(2000);
        click(raiseHand.raiseHandBtn);
        sa.assertTrue(raiseHand.raiseHandOffNotifictaion.isDisplayed());
        raise_hand_flag = raiseHand.raiseHandOffNotifictaion.getAttribute("content-desc");
        raise_hand_text = getStrings().get("raise_hand_off");
        sa.assertEquals(raise_hand_flag, raise_hand_text);
>>>>>>> newapp

//        Add negative case
//        Assert.assertFalse(raiseHand.raiseHandOnTile.isDisplayed());
    }

}
