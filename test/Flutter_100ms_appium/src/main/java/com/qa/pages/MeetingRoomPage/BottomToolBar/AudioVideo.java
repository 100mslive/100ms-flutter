package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class AudioVideo extends BaseTest {

    @iOSXCUITFindBy(accessibility = "videoMute")
    @AndroidFindBy(accessibility = "videoMute")
    public static WebElement camBtn;

    @iOSXCUITFindBy(accessibility = "audioMute")
    @AndroidFindBy(accessibility = "audioMute")
    public WebElement micBtn;

    public void click_camBtn() throws InterruptedException {
        Assert.assertTrue(camBtn.isDisplayed());
        camBtn.click();
        Thread.sleep(3000);
    }

    public void click_micBtn() throws InterruptedException {
        Assert.assertTrue(micBtn.isDisplayed());
        micBtn.click();
        Thread.sleep(3000);
    }

}
