package com.qa.tests.MeetingRoomTest.BottomToolBarTest;

import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.BottomToolBar.ScreenShare;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class ScreenShareTest extends BaseTest {

    ScreenShare screenShare;
  MeetingRoom meetingRoom;
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
    public void beforeMethod(Method m){
      closeApp();
      launchApp();
      utils.log().info("\n" + "****** starting test:" + m.getName() + "******" + "\n");
      sa = new SoftAssert();
      screenShare = new ScreenShare();
      meetingRoom = new MeetingRoom();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
      LeaveRoom leaveRoom = new LeaveRoom();
      leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_ScreenShare() throws InterruptedException {
        System.out.println("Verify Screen share");
        Thread.sleep(2000);
      meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
          meetingDetail.getJSONObject("valid").getString("username"),
          meetingDetail.getJSONObject("camera").getString("ON"),
          meetingDetail.getJSONObject("mic").getString("ON"));

        sa.assertTrue(screenShare.expand.isDisplayed());
        click(screenShare.expand);
        sa.assertTrue(screenShare.screenShareBtn.isDisplayed());
        click(screenShare.screenShareBtn);

        sa.assertTrue(screenShare.screenShareCancelBtn.isDisplayed());
        click(screenShare.screenShareCancelBtn);

//      boolean x = screenShare.screenShareTile.isDisplayed();
//        System.out.println(x);
//        //not able to check as the xpath is not unique & ss-xpath still exists when screen share is stopped
//        sa.assertFalse(screenShare.screenShareTile.isDisplayed());

//        sa.assertFalse(screenShare.screenShareLogo.isDisplayed());
      sa.assertTrue(screenShare.expand.isDisplayed());
      click(screenShare.expand);
      click(screenShare.expand);
      click(screenShare.screenShareBtn);
      sa.assertTrue(screenShare.screenShareStartNowBtn.isDisplayed());
      click(screenShare.screenShareStartNowBtn);

      click(screenShare.expand);
      sa.assertTrue(screenShare.screenShareTile.isDisplayed());

//      sa.assertTrue(screenShare.screenShareOnNotifictaion.isDisplayed());
//      String flag = screenShare.screenShareOnNotifictaion.getAttribute("content-desc");
//      String screen_share_text = getStrings().get("screen_share_started");;
//      sa.assertEquals(flag, screen_share_text);

      Thread.sleep(5000);
      click(screenShare.expand);
      click(screenShare.screenShareBtn);
      click(screenShare.expand);
//      sa.assertTrue(screenShare.screenShareOffNotifictaion.isDisplayed());
//      flag = screenShare.screenShareOffNotifictaion.getAttribute("content-desc");
//      screen_share_text = getStrings().get("screen_share_stopped");;
//      sa.assertEquals(flag, screen_share_text);

    }

}
