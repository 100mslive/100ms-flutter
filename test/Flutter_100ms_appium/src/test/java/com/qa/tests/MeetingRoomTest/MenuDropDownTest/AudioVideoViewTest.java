package com.qa.tests.MeetingRoomTest.MenuDropDownTest;

import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.BottomToolBar.AudioVideo;
import com.qa.pages.MeetingRoomPage.MenuDropDown.AudioView;
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

public class AudioVideoViewTest extends BaseTest {

    TopToolBar topToolBar;
    AudioView audioView;
    AudioVideo audioVideo;
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
        audioView = new AudioView();
        audioVideo = new AudioVideo();
        tile = new Tile();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
        sa.assertAll();
        EndRoom endRoom = new EndRoom();
        endRoom.end_room_for_all();
    }


    @Test
    public void Test_AudioView_VideoView() throws InterruptedException {
        System.out.println("Verify Audio Video View");
        Thread.sleep(2000);

        topToolBar = topToolBar.goto_meetingRoom_menuPage(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));

        sa.assertTrue(audioView.audioViewBtn.isDisplayed());
        click(audioView.audioViewBtn);

        Thread.sleep(2000);
        String camBtn_flag = audioVideo.camBtn.getAttribute("clickable");
        String camBtn_ended_text = getStrings().get("false");
        sa.assertEquals(camBtn_flag, camBtn_ended_text);

        click(topToolBar.menuBtn);
        sa.assertTrue(audioView.videoViewBtn.isDisplayed());
        click(audioView.videoViewBtn);

        camBtn_flag = audioVideo.camBtn.getAttribute("clickable");
        camBtn_ended_text = getStrings().get("true");
        sa.assertEquals(camBtn_flag, camBtn_ended_text);
    }

}
