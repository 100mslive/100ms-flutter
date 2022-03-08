package com.qa.tests.MeetingRoomTest;

import com.qa.BaseTest;
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
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class TopToolBarTest extends BaseTest {

    MeetingRoom meetingRoom;
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
    public void beforeMethod(Method m) throws InterruptedException {
      closeApp();
      launchApp();
      utils.log().info("\n" + "****** starting test:" + m.getName() + "******" + "\n");
      sa = new SoftAssert();
      meetingRoom = new MeetingRoom();
      topToolBar = new TopToolBar();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
      LeaveRoom leaveRoom = new LeaveRoom();
      leaveRoom.leave_endRoomForAll();
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
    }

    @Test
    public void Test_MenuBtn() throws InterruptedException {
      System.out.println("Verify MenuBtn");
      Thread.sleep(2000);
      PageFlowFunc pageFlow = new PageFlowFunc();
      TopToolBar topToolBar = new TopToolBar();

      meetingRoom = meetingRoom.goto_meetingRoom_mic_cam(meetingDetail.getJSONObject("valid").getString("meeting_url"),
        meetingDetail.getJSONObject("valid").getString("username"),
        meetingDetail.getJSONObject("camera").getString("ON"),
        meetingDetail.getJSONObject("mic").getString("ON"));

      waitForVisibility(topToolBar.menuBtn);
      sa.assertTrue(topToolBar.menuBtn.isDisplayed());
      click(topToolBar.menuBtn);

      Thread.sleep(2000);
      sa.assertTrue(topToolBar.settingPopupHeading.isDisplayed());
      default_back();

    }

}
