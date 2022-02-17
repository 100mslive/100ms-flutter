package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class AudioView extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(accessibility = "Audio View")
    public WebElement audioViewBtn;

    @iOSXCUITFindBy(accessibility = "Video View")
    @AndroidFindBy(accessibility = "Video View")
    public WebElement videoViewBtn;

    public void click_audioViewBtn() throws InterruptedException {
        Assert.assertTrue(audioViewBtn.isDisplayed());
        audioViewBtn.click();
        Thread.sleep(3000);
    }

    public void click_videoViewBtn() throws InterruptedException {
        Assert.assertTrue(videoViewBtn.isDisplayed());
        videoViewBtn.click();
        Thread.sleep(3000);
    }
}
