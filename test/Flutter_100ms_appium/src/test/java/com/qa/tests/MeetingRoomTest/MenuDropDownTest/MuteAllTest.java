package com.qa.tests.MeetingRoomTest.MenuDropDownTest;

import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.MuteAll;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class MuteAllTest extends BaseTest {

    TopToolBar topToolBar;
    MuteAll muteAll;
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
        muteAll = new MuteAll();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
        sa.assertAll();
        LeaveRoom leaveRoom = new LeaveRoom();
        leaveRoom.leave_withoutEndingRoom();
    }

    @Test
    public void Test_MuteAll() throws InterruptedException {
        System.out.println("Verify mute all");
        Thread.sleep(2000);
        topToolBar = topToolBar.goto_meetingRoom_menuPage(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));

        assertTrue(muteAll.muteBtn.isDisplayed(),"muteBtn","isDisplayed");
        click(muteAll.muteBtn,"muteBtn");

        assertTrue(muteAll.mutePopup.isDisplayed(),"mutePopup","isDisplayed");
        Thread.sleep(2000);

        assertTrue(muteAll.muteAllCheckbox.isDisplayed(),"muteAllBtn","isDisplayed");
        click(muteAll.muteAllCheckbox,"muteAllCheckbox");

        assertTrue(muteAll.muteAllBtn.isDisplayed(),"muteAllBtn","isDisplayed");
        click(muteAll.muteAllBtn,"muteAllBtn");


//        sa.assertTrue(muteAll.muteAllNotification.isDisplayed());
//        String mute_all_flag = muteAll.muteAllNotification.getAttribute("content-desc");
//        String mute_all_text = getStrings().get("mute_all_notification");
//        sa.assertEquals(mute_all_flag, mute_all_text);

    }

}
