package com.qa.tests.MeetingRoomTest.MenuDropDownTest;


import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.MenuDropDown.EndRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.Record;
import com.qa.pages.MeetingRoomPage.Tile;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class RecordTest extends BaseTest {

    TopToolBar topToolBar;
    Record record;
    Tile tile;
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
        record = new Record();
        tile = new Tile();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
        sa.assertAll();
        EndRoom endRoom = new EndRoom();
        endRoom.end_room_for_all();
    }

    @Test
    public void Test_Recording() throws InterruptedException {
        System.out.println("Verify Recording in Room");
        Thread.sleep(2000);

        topToolBar = topToolBar.goto_meetingRoom_menuPage(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));

        sa.assertTrue(record.recordBtn.isDisplayed());

        click(record.recordBtn);

        sa.assertTrue(record.recordPopup.isDisplayed());

        sa.assertTrue(record.recordMeetingUrl.isDisplayed());
        String beam_url_flag = record.recordMeetingUrl.getText();
        String beam_url_text = meetingDetail.getJSONObject("valid").getString("meeting_url").replace("meeting" , "preview") + getStrings().get("token_beam");
        sa.assertEquals(beam_url_flag, beam_url_text);

        sa.assertTrue(record.recordCancelBtn.isDisplayed());
        click(record.recordCancelBtn);

        //add a false check || not working with assertfalse
        //Assert.assertFalse(record.recordingStartedNotification.isDisplayed());

        click(topToolBar.menuBtn);
        click(record.recordBtn);

        click(record.recordOKBtn);
        Thread.sleep(15000);
//        Add a check as below is not working due to non detection of id od beam tile
//        Assert.assertTrue(record.beamBot.isDisplayed());
//        String beam_flag = record.beamBot.getAttribute("content-desc");
//        String beam_text = "b beam";
//        Assert.assertEquals(beam_flag, beam_text);

        sa.assertTrue(record.recordingStartedNotification.isDisplayed());

        String record_flag = getContextDesc(record.recordingStartedNotification, "Recording Notification- ");
        String record_text = getStrings().get("recording_started");
        sa.assertEquals(record_flag, record_text);

        click(topToolBar.menuBtn);
        click(record.recordingBtn);

        sa.assertTrue(record.recordingStoppedNotification.isDisplayed());
        record_flag = getContextDesc(record.recordingStoppedNotification, "Recording Notification- ");
        record_text = getStrings().get("recording_stopped");
        sa.assertEquals(record_flag, record_text);

    }

}
