package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.MobileElement;
import org.testng.Assert;

public class Participants extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Participants")
    @AndroidFindBy(accessibility = "Participants")
    public MobileElement participantListBtn;

    public void click_participantListBtn() throws InterruptedException {
        Assert.assertTrue(participantListBtn.isDisplayed());
        participantListBtn.click();
        Thread.sleep(3000);
    }
}
