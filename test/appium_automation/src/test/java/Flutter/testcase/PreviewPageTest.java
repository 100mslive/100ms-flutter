package Flutter.testcase;

import Flutter.pageobject.MeetingRoomPage.BottomToolBar.AudioVideo;
import Flutter.pageobject.PageFlowFunc;
import Flutter.pageobject.PreviewPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class PreviewPageTest {

    @Test
    public void Test_PreviewPage() throws InterruptedException {
        System.out.println("Verify Participants Preview Page");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        PreviewPage previewPage = new PreviewPage();
        AudioVideo bottomToolBar = new AudioVideo();

        pageFlow.goto_preview_page();

        Assert.assertTrue(previewPage.backBtn.isDisplayed());
        Assert.assertTrue(previewPage.previewPageHeading.isDisplayed());
        Assert.assertTrue(previewPage.videoTile.isDisplayed());
        Assert.assertTrue(previewPage.camBtn.isDisplayed());
        Assert.assertTrue(previewPage.micBtn.isDisplayed());
        Assert.assertTrue(previewPage.joinNowBtn.isDisplayed());

        previewPage.click_camBtn();
        previewPage.click_micBtn();
        previewPage.click_joinNowBtn();

        bottomToolBar.camBtn.isDisplayed();
        bottomToolBar.micBtn.isDisplayed();

    }

}
