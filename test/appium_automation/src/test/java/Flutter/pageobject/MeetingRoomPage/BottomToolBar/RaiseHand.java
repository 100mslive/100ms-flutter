package Flutter.pageobject.MeetingRoomPage.BottomToolBar;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class RaiseHand extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "RaiseHand")
    @AndroidFindBy(accessibility = "RaiseHand")
    public WebElement raiseHandBtn;

    @iOSXCUITFindBy(accessibility = "Raised Hand ON")
    @AndroidFindBy(accessibility = "Raised Hand ON")
    public WebElement raiseHandOnNotifictaion;

    @iOSXCUITFindBy(accessibility = "Raised Hand OFF")
    @AndroidFindBy(accessibility = "Raised Hand OFF")
    public WebElement raiseHandOffNotifictaion;

    public void click_raiseHandBtn() throws InterruptedException {
        Assert.assertTrue(raiseHandBtn.isDisplayed());
        raiseHandBtn.click();
        Thread.sleep(3000);
    }
}
