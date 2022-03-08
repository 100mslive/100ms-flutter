package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class Cancel extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Participants")
    @AndroidFindBy(accessibility = "Participants")
    public WebElement participantListBtn;

    public void click_participantListBtn() throws InterruptedException {
        Assert.assertTrue(participantListBtn.isDisplayed());
        participantListBtn.click();
        Thread.sleep(3000);
    }
}
