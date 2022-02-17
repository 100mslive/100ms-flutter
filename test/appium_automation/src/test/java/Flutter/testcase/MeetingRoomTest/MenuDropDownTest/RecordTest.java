package Flutter.testcase.MeetingRoomTest.MenuDropDownTest;

import Flutter.pageobject.MeetingRoomPage.BottomToolBar.LeaveRoom;
import Flutter.pageobject.MeetingRoomPage.MenuDropDown.Record;
import Flutter.pageobject.MeetingRoomPage.TopToolBar;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class RecordTest {

    @Test
    public void Test_RaiseHand() throws InterruptedException {
        System.out.println("Verify Recording in Room");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        Record record = new Record();
        TopToolBar topToolBar = new TopToolBar();

        pageFlow.goto_meetingRoom_menuDropDown();
        Assert.assertTrue(record.recordBtn.isDisplayed());

        record.click_recordBtn();
        Assert.assertTrue(record.recordPopup.isDisplayed());

        Assert.assertTrue(record.recordMeetingUrl.isDisplayed());
        String beam_url_flag = record.recordMeetingUrl.getText();
        String beam_url_text = pageFlow.meeting_url.replace("meeting" , "preview") + "?token=beam_recording, Enter RTMP Url";
        Assert.assertEquals(beam_url_flag, beam_url_text);

        Assert.assertTrue(record.recordCancelBtn.isDisplayed());
        record.click_recordCancelBtn();
        //add a false check || not working with assertfalse
        //Assert.assertFalse(record.recordingStartedNotification.isDisplayed());

        topToolBar.click_menuBtn();
        record.click_recordBtn();

        record.click_recordOkBtn();
        Thread.sleep(15000);
//        Add a check as below is not working due to non detection of id od beam tile
//        Assert.assertTrue(record.beamBot.isDisplayed());
//        String beam_flag = record.beamBot.getAttribute("content-desc");
//        String beam_text = "b beam";
//        Assert.assertEquals(beam_flag, beam_text);

        Assert.assertTrue(record.recordingStartedNotification.isDisplayed());
        String record_flag = record.recordingStartedNotification.getAttribute("content-desc");
        String record_text = "Recording Started";
        Assert.assertEquals(record_flag, record_text);

        topToolBar.click_menuBtn();
        record.click_recordingBtn();

        Assert.assertTrue(record.recordingStoppedNotification.isDisplayed());
        record_flag = record.recordingStoppedNotification.getAttribute("content-desc");
        record_text = "Recording Stopped";
        Assert.assertEquals(record_flag, record_text);

        pageFlow.leave_room();
    }

}
