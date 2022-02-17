package Flutter.pageobject.MeetingRoomPage.BottomToolBar;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class LeaveRoom extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Leave Or End")
    @AndroidFindBy(accessibility = "Leave Or End")
    public WebElement leaveRoomBtn;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public WebElement leaveRoomPopup;

    @iOSXCUITFindBy(accessibility = "Leave Room?")
    @AndroidFindBy(accessibility = "Leave Room?")
    public WebElement leaveRoomPopupText;

    @iOSXCUITFindBy(accessibility = "Yes")
    @AndroidFindBy(accessibility = "Yes")
    public WebElement leaveRoomYesBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public WebElement leaveRoomCancelBtn;

    @iOSXCUITFindBy(accessibility = "Meeting Ended")
    @AndroidFindBy(accessibility = "Meeting Ended")
    public WebElement meetingEndedNotification;

    public void click_leaveRoomBtn() throws InterruptedException {
        Assert.assertTrue(leaveRoomBtn.isDisplayed());
        leaveRoomBtn.click();
        Thread.sleep(3000);
    }

    public void click_leaveRoomYesBtn() throws InterruptedException {
        Assert.assertTrue(leaveRoomYesBtn.isDisplayed());
        leaveRoomYesBtn.click();
        Thread.sleep(3000);
    }

    public void click_leaveRoomCancelBtn() throws InterruptedException {
        Assert.assertTrue(leaveRoomCancelBtn.isDisplayed());
        leaveRoomCancelBtn.click();
        Thread.sleep(3000);
    }
}
