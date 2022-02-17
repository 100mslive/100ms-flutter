package Flutter.pageobject.MeetingRoomPage.MenuDropDown;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class ActiveSpeakerMode extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Active Speaker Mode")
    @AndroidFindBy(accessibility = "Active Speaker Mode")
    public WebElement activeSpeakerModeBtn;

    public void click_activeSpeakerModeBtn() throws InterruptedException {
        Assert.assertTrue(activeSpeakerModeBtn.isDisplayed());
        activeSpeakerModeBtn.click();
        Thread.sleep(3000);
    }
}
