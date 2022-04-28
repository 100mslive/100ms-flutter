package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.testng.Assert;

public class SendLogs extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Send Logs")
    @AndroidFindBy(accessibility = "Send Logs")
    public static MobileElement sendLogsBtn;

    public void click_sendLogsBtn() throws InterruptedException {
        Assert.assertTrue(sendLogsBtn.isDisplayed());
        sendLogsBtn.click();
        Thread.sleep(3000);
    }

}
