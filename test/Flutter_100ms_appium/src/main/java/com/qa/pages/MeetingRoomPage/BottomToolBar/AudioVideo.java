package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class AudioVideo extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Video")
    @AndroidFindBy(accessibility = "Video")
    public static WebElement camBtn;

    @iOSXCUITFindBy(accessibility = "Audio")
    @AndroidFindBy(accessibility = "Audio")
    public WebElement micBtn;

}
