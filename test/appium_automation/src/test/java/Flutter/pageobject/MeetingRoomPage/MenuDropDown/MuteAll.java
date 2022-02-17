package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class MuteAll extends PagesCommon {

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Mute All")
    public WebElement muteAllBtn;

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Successfully Muted All")
    public WebElement muteAllNotification;

    public void click_muteAllBtn() throws InterruptedException {
        Assert.assertTrue(muteAllBtn.isDisplayed());
        muteAllBtn.click();
        Thread.sleep(3000);
    }
}
