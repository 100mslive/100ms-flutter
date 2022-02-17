package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class Participants extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Participants")
    @AndroidFindBy(accessibility = "Participants")
    public WebElement participantListBtn;

    public void click_participantListBtn() throws InterruptedException {
        Assert.assertTrue(participantListBtn.isDisplayed());
        participantListBtn.click();
        Thread.sleep(3000);
    }
}
