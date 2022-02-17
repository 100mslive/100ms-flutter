package Flutter.pageobject;

import base.AppDriver;
import base.PlatformSelector;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class HomePage extends PagesCommon{

    //Landing Page
    @iOSXCUITFindBy(accessibility = "Enter Room URL")
    @AndroidFindBy(className = "android.widget.EditText")
    public static WebElement meetingUrlField;

    //@iOSXCUITFindBy(accessibility = "The App")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.widget.EditText/android.widget.Button")
    public WebElement crossBtn;

    @iOSXCUITFindBy(accessibility = "Join Meeting")
    @AndroidFindBy(xpath = "//android.widget.Button[@content-desc='Join Meeting']")
    public WebElement joinMeetingBtn;

    public void clear_meeting_url(){
        String platform = PlatformSelector.selectPlatform();
        if(platform.equalsIgnoreCase("Android")){
            meetingUrlField.clear();
        }else
        if(platform.equalsIgnoreCase("iOS")){
            meetingUrlField.clear();
            meetingUrlField.clear();
        }
    }

    public void put_meeting_url(String txt){
        Assert.assertTrue(meetingUrlField.isDisplayed());
        meetingUrlField.sendKeys(txt);
    }

    public void click_crossBtn() throws InterruptedException {
        Assert.assertTrue(crossBtn.isDisplayed());
        crossBtn.click();
        Thread.sleep(2000);
    }

    public void click_joinMeetingBtn() throws InterruptedException {
        Assert.assertTrue(joinMeetingBtn.isDisplayed());
        joinMeetingBtn.click();
        Thread.sleep(2000);
    }

    //HomePage Participant name Popup
    @iOSXCUITFindBy(accessibility = "Enter your Name")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public WebElement participantNameField;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public WebElement nameOKbtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public WebElement nameCancelbtn;

    public void put_participant_name(String txt){
        Assert.assertTrue(participantNameField.isDisplayed());
        participantNameField.sendKeys(txt);
    }

    public void click_okBtn() throws InterruptedException {
        Assert.assertTrue(nameOKbtn.isDisplayed());
        nameOKbtn.click();
        Thread.sleep(2000);
    }

    //HomePage OS permission
    @AndroidFindBy(id = "com.android.permissioncontroller:id/permission_allow_foreground_only_button")
    public WebElement permissionCamMic;

    public void accept_permission() throws InterruptedException {
        String platform = PlatformSelector.selectPlatform();
        if (platform.equalsIgnoreCase("Android")) {
            Assert.assertTrue(permissionCamMic.isDisplayed());
            permissionCamMic.click();
            Thread.sleep(2000);
        } else if (platform.equalsIgnoreCase("iOS")) {
            //nothing to add as iOS does not have these permissions
        }
    }
}
