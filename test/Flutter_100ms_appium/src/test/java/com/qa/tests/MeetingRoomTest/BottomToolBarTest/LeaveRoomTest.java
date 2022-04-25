package com.qa.tests.MeetingRoomTest.BottomToolBarTest;

import com.qa.BaseTest;
import com.qa.pages.HomePage;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
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

public class LeaveRoomTest extends BaseTest {

  HomePage homePage;
  MeetingRoom meetingRoom;
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
      leaveRoom = new LeaveRoom();
      homePage = new HomePage();
    }

    @AfterMethod
    public void afterMethod() {
      sa.assertAll();
    }

    @Test
    public void Test_LeaveRoom_Cancel() throws InterruptedException {
        System.out.println("Verify Participant Leave Room cancel option");
        Thread.sleep(2000);
      meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
        meetingDetail.getJSONObject("valid").getString("username"),
        meetingDetail.getJSONObject("camera").getString("ON"),
        meetingDetail.getJSONObject("mic").getString("ON"));

      waitForVisibility(leaveRoom.leaveRoomBtn);
      sa.assertTrue(leaveRoom.leaveRoomBtn.isDisplayed());
        click(leaveRoom.leaveRoomBtn);
        sa.assertTrue(leaveRoom.leaveRoomPopup.isDisplayed());

      waitForVisibility(leaveRoom.leaveRoomPopupText);
      sa.assertTrue(leaveRoom.leaveRoomPopupText.isDisplayed());
        String leave_room_heading = leaveRoom.leaveRoomPopupText.getAttribute("content-desc");
        String flag = getStrings().get("Leave_room_heading");;
        Assert.assertEquals(leave_room_heading, flag);

        sa.assertTrue(leaveRoom.leaveRoomCancelBtn.isDisplayed());
      click(leaveRoom.leaveRoomCancelBtn);
        sa.assertTrue(leaveRoom.leaveRoomBtn.isDisplayed());
        //add more button checks later
      leaveRoom.leave_withoutEndingRoom();
    }

  @Test
  public void Test_LeaveRoom_LeaveWithoutEndingRoom() throws InterruptedException {
    System.out.println("Verify Participant Leave Room LeaveWithoutEndingRoom option");
    Thread.sleep(2000);
    meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
      meetingDetail.getJSONObject("valid").getString("username"),
      meetingDetail.getJSONObject("camera").getString("ON"),
      meetingDetail.getJSONObject("mic").getString("ON"));

    waitForVisibility(leaveRoom.leaveRoomBtn);
    sa.assertTrue(leaveRoom.leaveRoomBtn.isDisplayed());
    click(leaveRoom.leaveRoomBtn);
    sa.assertTrue(leaveRoom.leaveRoomYesBtn.isDisplayed());
    click(leaveRoom.leaveRoomYesBtn);
    Thread.sleep(2000);
    sa.assertTrue(homePage.joinMeetingBtn.isDisplayed());
  }

//  @Test
//  public void Test_LeaveRoom_EndRoomForAll() throws InterruptedException {
//    System.out.println("Verify Participant Leave Room EndRoomForAll option");
//
//    meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
//      meetingDetail.getJSONObject("valid").getString("username"),
//      meetingDetail.getJSONObject("camera").getString("ON"),
//      meetingDetail.getJSONObject("mic").getString("ON"));
//
////    Thread.sleep(2000);
//    waitForVisibility(leaveRoom.leaveRoomBtn);
//    sa.assertTrue(leaveRoom.leaveRoomBtn.isDisplayed());
//    click(leaveRoom.leaveRoomBtn);
//    Thread.sleep(2000);
////    waitForVisibility(leaveRoom.endRoomForAll);
//
////    sa.assertTrue(leaveRoom.endRoomForAll.isDisplayed());
////    click(leaveRoom.endRoomForAll);
//    Thread.sleep(2000);
////    waitForVisibility(homePage.joinMeetingBtn);
//
//    sa.assertTrue(homePage.joinMeetingBtn.isDisplayed());
//  }

}
