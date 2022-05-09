package com.qa.tests.MeetingRoomTest;

import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class TopToolBarTest extends BaseTest {

    MeetingRoom meetingRoom;
    TopToolBar topToolBar;
    LeaveRoom leaveRoom;
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
      topToolBar = new TopToolBar();
      leaveRoom = new LeaveRoom();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
    }

    @Test
    public void Test_SpeakerBtn() throws InterruptedException {
        System.out.println("Verify SpeakerBtn");
        Thread.sleep(2000);

        meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
          meetingDetail.getJSONObject("valid").getString("username"),
          meetingDetail.getJSONObject("camera").getString("ON"),
          meetingDetail.getJSONObject("mic").getString("ON"));
        assertTrue(topToolBar.speakerBtn.isDisplayed(), "speakerBtn","isDisplayed");
        click(topToolBar.speakerBtn);
        leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_MenuBtn() throws InterruptedException {
      System.out.println("Verify MenuBtn");
      Thread.sleep(2000);

      meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
        meetingDetail.getJSONObject("valid").getString("username"),
        meetingDetail.getJSONObject("camera").getString("ON"),
        meetingDetail.getJSONObject("mic").getString("ON"));

        Thread.sleep(2000);
        assertTrue(topToolBar.menuBtn.isDisplayed(), "menuBtn", "isDisplayed");
        click(topToolBar.menuBtn);

//        Thread.sleep(2000);
//      sa.assertTrue(topToolBar.settingPopupHeading.isDisplayed());
        default_back();
        leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_BackBtn() throws InterruptedException {
        System.out.println("Verify BackBtn");
        Thread.sleep(2000);

        meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));

        assertTrue(topToolBar.backBtn.isDisplayed(), "backBtn", "isDisplayed");
        click(topToolBar.backBtn);
        assertTrue(leaveRoom.leaveRoomPopup.isDisplayed(), "leaveRoomPopup", "isDisplayed");

        assertTrue(leaveRoom.leaveRoomPopupText.isDisplayed(), "leaveRoomPopupText", "isDisplayed");
        String leave_room_flag = leaveRoom.leaveRoomPopupText.getAttribute("content-desc");
        String leave_room_text = "Leave Room?";
        sa.assertEquals(leave_room_flag, leave_room_text);

        assertTrue(leaveRoom.leaveRoomCancelBtn.isDisplayed(), "leaveRoomCancelBtn", "isDisplayed");
        click(leaveRoom.leaveRoomCancelBtn);
        assertTrue(topToolBar.backBtn.isDisplayed(), "backBtn", "isDisplayed");
        //add more button checks later

        click(leaveRoom.leaveRoomBtn);
        assertTrue(leaveRoom.leaveRoomYesBtn.isDisplayed(), "", "isDisplayed");
        click(leaveRoom.leaveRoomYesBtn);

//        String meeting_ended_flag = leaveRoom.meetingEndedNotification.getAttribute("content-desc");
//        String meeting_ended_text = "Meeting Ended";
//        sa.assertEquals(meeting_ended_flag, meeting_ended_text);

    }

}
