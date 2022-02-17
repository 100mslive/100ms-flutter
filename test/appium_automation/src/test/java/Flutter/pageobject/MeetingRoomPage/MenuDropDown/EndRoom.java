package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class EndRoom extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "End Room")
    @AndroidFindBy(accessibility = "End Room")
    public WebElement endRoomBtn;

    public void click_endRoomBtn() throws InterruptedException {
        Assert.assertTrue(endRoomBtn.isDisplayed());
        endRoomBtn.click();
        Thread.sleep(3000);
    }
}
