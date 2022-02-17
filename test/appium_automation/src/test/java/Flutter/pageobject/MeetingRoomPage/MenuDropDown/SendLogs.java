package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class SendLogs extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Send Logs")
    @AndroidFindBy(accessibility = "Send Logs")
    public static WebElement sendLogsBtn;

    public void click_sendLogsBtn() throws InterruptedException {
        Assert.assertTrue(sendLogsBtn.isDisplayed());
        sendLogsBtn.click();
        Thread.sleep(3000);
    }

}
