package com.qa.tests;

import com.qa.BaseTest;
import com.qa.pages.HomePage;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.PreviewPage;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class PreviewPageTest extends BaseTest {

    HomePage homePage;
    PreviewPage previewPage;
    JSONObject meetingDetail;
    LeaveRoom leaveRoom;
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
      homePage = new HomePage();
      leaveRoom = new LeaveRoom();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
      sa.assertAll();
      LeaveRoom leaveRoom = new LeaveRoom();
      leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_PreviewPage() throws InterruptedException {
        System.out.println("Verify Preview page locators");
        homePage.goto_previewPage(meetingDetail.getJSONObject("valid").getString("meeting_url"), meetingDetail.getJSONObject("valid").getString("username"));
        Thread.sleep(2000);

//        sa.assertTrue(previewPage.videoTile.isDisplayed());
//        assertTrue(previewPage.camBtn.isDisplayed(), "camBtn", "isDisplayed");
//        assertTrue(previewPage.micBtn.isDisplayed(), "micBtn", "isDisplayed");
        assertTrue(previewPage.joinNowBtn.isDisplayed(), "joinNowBtn", "isDisplayed");
//        sa.assertTrue(previewPage.backBtn.isDisplayed());
//        sa.assertTrue(previewPage.previewPageHeading.isDisplayed());
//        click(previewPage.camBtn,"camBtn");
//        click(previewPage.micBtn,"micBtn");
        click(previewPage.joinNowBtn,"joinNowBtn");
        assertTrue(leaveRoom.leaveRoomBtn.isDisplayed(), "leaveRoomBtn", "isDisplayed");
    }

}
