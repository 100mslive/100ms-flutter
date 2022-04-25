package com.qa.tests.MeetingRoomTest.MenuDropDownTest;

import com.qa.BaseTest;
import com.qa.pages.HomePage;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.EndRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.MuteAll;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class EndRoomTest extends BaseTest {

    TopToolBar topToolBar;
    EndRoom endRoom;
    LeaveRoom leaveRoom;
    HomePage homePage;
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
        topToolBar = new TopToolBar();
        endRoom = new EndRoom();
        leaveRoom = new LeaveRoom();
        homePage = new HomePage();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
        sa.assertAll();
//        leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_EndRoom() throws InterruptedException {
        System.out.println("Verify End Room for all");
        Thread.sleep(2000);
        topToolBar = topToolBar.goto_meetingRoom_menuPage(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));


        sa.assertTrue(endRoom.endRoomBtn.isDisplayed());
        click(endRoom.endRoomBtn);

        String meeting_ended_flag = leaveRoom.meetingEndedNotification.getAttribute("content-desc");
        String meeting_ended_text = "Meeting Ended";
        sa.assertEquals(meeting_ended_flag, meeting_ended_text);

        sa.assertTrue(homePage.joinMeetingBtn.isDisplayed());
    }

}
