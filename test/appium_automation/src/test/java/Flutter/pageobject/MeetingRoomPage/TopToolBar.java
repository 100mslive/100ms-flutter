package Flutter.pageobject.MeetingRoomPage;

import Flutter.pageobject.PagesCommon;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class TopToolBar extends PagesCommon {

    //Landing Page
    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility = "Back")
    public static WebElement backBtn;

    //todos
    @iOSXCUITFindBy(accessibility = "Audio")
    @AndroidFindBy(accessibility = "Audio")
    public WebElement headingCta;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeButton[2]")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]/android.widget.Button[2]")
    public WebElement speakerBtn;

    @iOSXCUITFindBy(accessibility = "Show menu")
    @AndroidFindBy(accessibility = "Show menu")
    public WebElement menuBtn;

    public void click_backBtn() throws InterruptedException {
        Assert.assertTrue(backBtn.isDisplayed());
        backBtn.click();
        Thread.sleep(3000);
    }

    public void check_headingCta() throws InterruptedException {
        Assert.assertTrue(headingCta.isDisplayed());

        Thread.sleep(3000);
    }

    public void click_speakerBtn() throws InterruptedException {
        Assert.assertTrue(speakerBtn.isDisplayed());
        speakerBtn.click();
        Thread.sleep(3000);
    }

    public void click_menuBtn() throws InterruptedException {
        Assert.assertTrue(menuBtn.isDisplayed());
        menuBtn.click();
        Thread.sleep(3000);
    }

}
