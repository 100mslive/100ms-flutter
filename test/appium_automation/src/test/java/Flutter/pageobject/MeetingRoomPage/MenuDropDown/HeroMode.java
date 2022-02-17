package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class HeroMode extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Hero Mod")
    @AndroidFindBy(accessibility = "Hero Mode")
    public WebElement heroModeBtn;

    public void click_heroModeBtn() throws InterruptedException {
        Assert.assertTrue(heroModeBtn.isDisplayed());
        heroModeBtn.click();
        Thread.sleep(3000);
    }
}
