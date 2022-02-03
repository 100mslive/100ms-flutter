package ReactNative.pageobject;

import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;

public class LandingPage extends PagesCommon {

    @iOSXCUITFindBy(accessibility = "Enter Room URL")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.EditText")
    public WebElement meetingUrlField;

    @iOSXCUITFindBy(accessibility = "The App")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.widget.EditText/android.widget.Button")
    public WebElement crossBtn;

    @iOSXCUITFindBy(accessibility = "Join Meeting")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup")
    public WebElement joinMeetingBtn;

    public void put_meeting_url(String txt) {
        meetingUrlField.sendKeys(txt);
    }

    public void click_crossBtn() throws InterruptedException {
        crossBtn.click();
        Thread.sleep(3000);
    }

    public void click_joinMeetingBtn() throws InterruptedException {
        joinMeetingBtn.click();
        Thread.sleep(3000);
    }


//    public void verifySavedText(String input) {
//        String platform = (String)((RemoteWebDriver) AppDriver.getDriver())
//                .getCapabilities()
//                .getCapability("platformName");
//
//        if(platform.equalsIgnoreCase("android")){
//            Assert.assertTrue(AppDriver.getDriver().findElement(By.xpath("//android.widget.TextView[@content-desc='"+input+"']")).isDisplayed());
//        }else
//        if(platform.equalsIgnoreCase("ios")){
//            Assert.assertEquals(echoSavedText.getAttribute("value"), input);
//        }
//    }

}
