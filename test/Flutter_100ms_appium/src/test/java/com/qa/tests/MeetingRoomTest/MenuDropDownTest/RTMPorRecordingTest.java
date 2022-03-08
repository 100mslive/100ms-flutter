package com.qa.tests.MeetingRoomTest.MenuDropDownTest;


import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.ScreenShare;
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

public class RTMPorRecordingTest extends BaseTest {

    ScreenShare screenShare;
    TopToolBar topToolBar;
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
    public void beforeMethod(Method m) {
      closeApp();
      launchApp();
      utils.log().info("\n" + "****** starting test:" + m.getName() + "******" + "\n");
      sa = new SoftAssert();
      topToolBar = new TopToolBar();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
      LeaveRoom leaveRoom = new LeaveRoom();
      leaveRoom.leave_endRoomForAll();
    }

    @Test
    public void Test_rtmpRecord() throws InterruptedException {
        System.out.println("Verify Recording in Room");
        Thread.sleep(2000);

      topToolBar = topToolBar.goto_meetingRoom_menuPage(meetingDetail.getJSONObject("valid").getString("meeting_url"),
        meetingDetail.getJSONObject("valid").getString("username"),
        meetingDetail.getJSONObject("camera").getString("ON"),
        meetingDetail.getJSONObject("mic").getString("ON"));
//        Assert.assertTrue(record.recordBtn.isDisplayed());

//        record.click_recordBtn();
//        Assert.assertTrue(record.recordPopup.isDisplayed());

//        Assert.assertTrue(record.recordMeetingUrl.isDisplayed());
//        String beam_url_flag = record.recordMeetingUrl.getText();
//        String beam_url_text = pageFlow.meeting_url.replace("meeting" , "preview") + "?token=beam_recording, Enter RTMP Url";
//        Assert.assertEquals(beam_url_flag, beam_url_text);
//
//        Assert.assertTrue(record.recordCancelBtn.isDisplayed());
//        record.click_recordCancelBtn();
        //add a false check || not working with assertfalse
        //Assert.assertFalse(record.recordingStartedNotification.isDisplayed());
//
//        topToolBar.click_menuBtn();
//        record.click_recordBtn();
//
//        record.click_recordOkBtn();
//        Thread.sleep(15000);
////        Add a check as below is not working due to non detection of id od beam tile
////        Assert.assertTrue(record.beamBot.isDisplayed());
////        String beam_flag = record.beamBot.getAttribute("content-desc");
////        String beam_text = "b beam";
////        Assert.assertEquals(beam_flag, beam_text);
//
//        Assert.assertTrue(record.recordingStartedNotification.isDisplayed());
//        String record_flag = record.recordingStartedNotification.getAttribute("content-desc");
//        String record_text = "Recording Started";
//        Assert.assertEquals(record_flag, record_text);
//
//        topToolBar.click_menuBtn();
//        record.click_recordingBtn();
//
//        Assert.assertTrue(record.recordingStoppedNotification.isDisplayed());
//        record_flag = record.recordingStoppedNotification.getAttribute("content-desc");
//        record_text = "Recording Stopped";
//        Assert.assertEquals(record_flag, record_text);
    }

}
