package Flutter.testcase.MeetingRoomTest.MenuDropDownTest;

import Flutter.pageobject.HomePage;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.AudioVideo;
import Flutter.pageobject.MeetingRoomPage.BottomToolBar.LeaveRoom;
import Flutter.pageobject.MeetingRoomPage.MenuDropDown.AudioView;
import Flutter.pageobject.MeetingRoomPage.MenuDropDown.EndRoom;
import Flutter.pageobject.MeetingRoomPage.TopToolBar;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AudioVideoViewTest {

    @Test
    public void Test_AudioView_VideoView() throws InterruptedException {
        System.out.println("Verify End Room for all");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        AudioView audioView = new AudioView();
        AudioVideo audioVideo = new AudioVideo();
        TopToolBar topToolBar = new TopToolBar();

        pageFlow.goto_meetingRoom_menuDropDown();
        Assert.assertTrue(audioView.audioViewBtn.isDisplayed());
        audioView.click_audioViewBtn();

        String camBtn_flag = audioVideo.camBtn.getAttribute("clickable");
        String camBtn_ended_text = "false";
        Assert.assertEquals(camBtn_flag, camBtn_ended_text);

        topToolBar.click_menuBtn();
        Assert.assertTrue(audioView.videoViewBtn.isDisplayed());
        audioView.click_videoViewBtn();

        camBtn_flag = audioVideo.camBtn.getAttribute("clickable");
        camBtn_ended_text = "true";
        Assert.assertEquals(camBtn_flag, camBtn_ended_text);

        pageFlow.leave_room();
    }

}
