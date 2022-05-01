package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.MobileElement;
import org.testng.Assert;

public class ActiveSpeakerMode extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Active Speaker Mode")
    @AndroidFindBy(accessibility = "Active Speaker Mode")
    public MobileElement activeSpeakerModeBtn;

    public void click_activeSpeakerModeBtn() throws InterruptedException {
        Assert.assertTrue(activeSpeakerModeBtn.isDisplayed());
        activeSpeakerModeBtn.click();
        Thread.sleep(3000);
    }
}
