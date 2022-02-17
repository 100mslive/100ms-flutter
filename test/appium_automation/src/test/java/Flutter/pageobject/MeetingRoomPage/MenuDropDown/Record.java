package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class Record extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Record")
    @AndroidFindBy(accessibility = "Record")
    public WebElement recordBtn;

    @iOSXCUITFindBy(accessibility = "Recording")
    @AndroidFindBy(xpath = "//android.widget.Button[@content-desc='Recording ']")
    public WebElement recordingBtn;

    @iOSXCUITFindBy(accessibility = "")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public WebElement recordPopup;

    @iOSXCUITFindBy(accessibility = "")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public WebElement recordMeetingUrl;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public WebElement recordOKBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public WebElement recordCancelBtn;

    @iOSXCUITFindBy(accessibility = "b beam")
    @AndroidFindBy(accessibility = "b beam")
    public WebElement beamBot;

    @iOSXCUITFindBy(accessibility = "Recording Started")
    @AndroidFindBy(accessibility = "Recording Started")
    public WebElement recordingStartedNotification;

    @iOSXCUITFindBy(accessibility = "Recording Stopped")
    @AndroidFindBy(accessibility = "Recording Stopped")
    public WebElement recordingStoppedNotification;

    public void click_recordBtn() throws InterruptedException {
        Assert.assertTrue(recordBtn.isDisplayed());
        recordBtn.click();
        Thread.sleep(3000);
    }

    public void click_recordingBtn() throws InterruptedException {
        Assert.assertTrue(recordingBtn.isDisplayed());
        recordingBtn.click();
        Thread.sleep(3000);
    }

    public void click_recordOkBtn() throws InterruptedException {
        Assert.assertTrue(recordOKBtn.isDisplayed());
        recordOKBtn.click();
        Thread.sleep(3000);
    }

    public void click_recordCancelBtn() throws InterruptedException {
        Assert.assertTrue(recordCancelBtn.isDisplayed());
        recordCancelBtn.click();
        Thread.sleep(3000);
    }
}
