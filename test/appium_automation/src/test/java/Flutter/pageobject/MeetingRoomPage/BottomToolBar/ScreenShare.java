package Flutter.pageobject.MeetingRoomPage.BottomToolBar;

import Flutter.pageobject.PagesCommon;
import base.PlatformSelector;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class ScreenShare extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(accessibility = "Share")
    public WebElement screenShareBtn;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(id = "android:id/button1")
    public WebElement screenShareStartNowBtn;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(id = "android:id/button2")
    public WebElement screenShareCancelBtn;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]")
    public WebElement screenShareTile;

    public void click_screenShareBtn() throws InterruptedException {
        Assert.assertTrue(screenShareBtn.isDisplayed());
        screenShareBtn.click();
        Thread.sleep(3000);
    }

    public void click_screenShareStartNowBtn() throws InterruptedException {
        Assert.assertTrue(screenShareStartNowBtn.isDisplayed());
        screenShareStartNowBtn.click();
        Thread.sleep(3000);
    }

    public void click_screenShareCancelBtn() throws InterruptedException {
        Assert.assertTrue(screenShareCancelBtn.isDisplayed());
        screenShareCancelBtn.click();
        Thread.sleep(3000);
    }

    public void ss_start_now_permission() throws InterruptedException {
        String platform = PlatformSelector.selectPlatform();
        if (platform.equalsIgnoreCase("Android")) {
            Assert.assertTrue(screenShareStartNowBtn.isDisplayed());
            screenShareStartNowBtn.click();
            Thread.sleep(3000);
        } else if (platform.equalsIgnoreCase("iOS")) {
            //to add ios logic
        }
    }

    public void ss_cancel_permission() throws InterruptedException {
        String platform = PlatformSelector.selectPlatform();
        if (platform.equalsIgnoreCase("Android")) {
            Assert.assertTrue(screenShareCancelBtn.isDisplayed());
            screenShareCancelBtn.click();
            Thread.sleep(3000);
        } else if (platform.equalsIgnoreCase("iOS")) {
            //to add ios logic
        }
    }
}
