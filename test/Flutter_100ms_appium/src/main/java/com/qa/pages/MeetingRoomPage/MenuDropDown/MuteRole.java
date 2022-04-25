package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.pagefactory.AndroidFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class MuteRole extends MeetingRoom {

    //@iOSXCUITFindBy(accessibility = "Mute Roles")
    @AndroidFindBy(accessibility = "Mute Roles")
    public WebElement muteRolesBtn;

    public void click_muteRolesBtn() throws InterruptedException {
        Assert.assertTrue(muteRolesBtn.isDisplayed());
        muteRolesBtn.click();
        Thread.sleep(3000);
    }
}
