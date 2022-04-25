package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class ToggleCamera extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Toggle Camera")
    @AndroidFindBy(accessibility = "Toggle Camera")
    public WebElement toggleCamBtn;

    public void click_toggleCamBtn() throws InterruptedException {
        Assert.assertTrue(toggleCamBtn.isDisplayed());
        toggleCamBtn.click();
        Thread.sleep(3000);
    }
}
