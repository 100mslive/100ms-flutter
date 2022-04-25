package com.qa.tests.MeetingRoomTest;

import com.qa.BaseTest;
<<<<<<< HEAD
import com.qa.pages.HomePage;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.Cancel;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.pages.PageFlowFunc;
import com.qa.pages.PreviewPage;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.Assert;
=======
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
>>>>>>> newapp
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class TopToolBarTest extends BaseTest {

    MeetingRoom meetingRoom;
    TopToolBar topToolBar;
<<<<<<< HEAD
=======
    LeaveRoom leaveRoom;
>>>>>>> newapp
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
<<<<<<< HEAD
=======
      leaveRoom = new LeaveRoom();
>>>>>>> newapp
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
<<<<<<< HEAD
      LeaveRoom leaveRoom = new LeaveRoom();
      leaveRoom.leave_endRoomForAll();
=======
>>>>>>> newapp
    }

    @Test
    public void Test_SpeakerBtn() throws InterruptedException {
        System.out.println("Verify SpeakerBtn");
        Thread.sleep(2000);

        meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
          meetingDetail.getJSONObject("valid").getString("username"),
          meetingDetail.getJSONObject("camera").getString("ON"),
          meetingDetail.getJSONObject("mic").getString("ON"));
        sa.assertTrue(topToolBar.speakerBtn.isDisplayed());
        click(topToolBar.speakerBtn);
<<<<<<< HEAD
=======

        leaveRoom.leave_withoutEndingRoom();
>>>>>>> newapp
    }

    @Test
    public void Test_MenuBtn() throws InterruptedException {
      System.out.println("Verify MenuBtn");
      Thread.sleep(2000);
<<<<<<< HEAD
      PageFlowFunc pageFlow = new PageFlowFunc();
      TopToolBar topToolBar = new TopToolBar();
=======
>>>>>>> newapp

      meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
        meetingDetail.getJSONObject("valid").getString("username"),
        meetingDetail.getJSONObject("camera").getString("ON"),
        meetingDetail.getJSONObject("mic").getString("ON"));

<<<<<<< HEAD
      waitForVisibility(topToolBar.menuBtn);
      sa.assertTrue(topToolBar.menuBtn.isDisplayed());
      click(topToolBar.menuBtn);

      Thread.sleep(2000);
      sa.assertTrue(topToolBar.settingPopupHeading.isDisplayed());
      default_back();
=======
        Thread.sleep(2000);
        sa.assertTrue(topToolBar.menuBtn.isDisplayed());
        click(topToolBar.menuBtn);

        Thread.sleep(2000);
//      sa.assertTrue(topToolBar.settingPopupHeading.isDisplayed());
        default_back();
        leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_BackBtn() throws InterruptedException {
        System.out.println("Verify Name space Visible");
        Thread.sleep(2000);

        meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));

        sa.assertTrue(topToolBar.backBtn.isDisplayed());
        click(topToolBar.backBtn);
        sa.assertTrue(leaveRoom.leaveRoomPopup.isDisplayed());

        sa.assertTrue(leaveRoom.leaveRoomPopupText.isDisplayed());
        String leave_room_flag = leaveRoom.leaveRoomPopupText.getAttribute("content-desc");
        String leave_room_text = "Leave Room?";
        sa.assertEquals(leave_room_flag, leave_room_text);

        sa.assertTrue(leaveRoom.leaveRoomCancelBtn.isDisplayed());
        click(leaveRoom.leaveRoomCancelBtn);
        sa.assertTrue(topToolBar.backBtn.isDisplayed());
        //add more button checks later

        click(leaveRoom.leaveRoomBtn);
        sa.assertTrue(leaveRoom.leaveRoomYesBtn.isDisplayed());
        click(leaveRoom.leaveRoomYesBtn);

        String meeting_ended_flag = leaveRoom.meetingEndedNotification.getAttribute("content-desc");
        String meeting_ended_text = "Meeting Ended";
        sa.assertEquals(meeting_ended_flag, meeting_ended_text);
>>>>>>> newapp

    }

}
