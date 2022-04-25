package com.qa.pages.MeetingRoomPage.MenuDropDown;

<<<<<<< HEAD
import com.qa.BaseTest;
=======
import com.qa.pages.MeetingRoomPage.MeetingRoom;
>>>>>>> newapp
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

<<<<<<< HEAD
public class SendLogs extends BaseTest {
=======
public class SendLogs extends MeetingRoom {
>>>>>>> newapp

    @iOSXCUITFindBy(accessibility = "Send Logs")
    @AndroidFindBy(accessibility = "Send Logs")
    public static WebElement sendLogsBtn;

    public void click_sendLogsBtn() throws InterruptedException {
        Assert.assertTrue(sendLogsBtn.isDisplayed());
        sendLogsBtn.click();
        Thread.sleep(3000);
    }

}
