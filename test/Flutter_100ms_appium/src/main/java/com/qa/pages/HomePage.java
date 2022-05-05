package com.qa.pages;

import com.qa.BaseTest;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

import org.testng.Assert;

public class HomePage extends BaseTest {

    //Landing Page
    @iOSXCUITFindBy(accessibility = "Enter Room URL")
    @AndroidFindBy(className = "android.widget.EditText")
    public static MobileElement meetingUrlField;

    //Add later
    @iOSXCUITFindBy(accessibility = "removeText")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.widget.EditText/android.widget.Button")
    public MobileElement crossBtn;

    @iOSXCUITFindBy(accessibility = "joinButton")
    @AndroidFindBy(accessibility = "Join Meeting")
    public MobileElement joinMeetingBtn;

    public void clear_meeting_url(){
        String platform = BaseTest.selectPlatform();
        if(platform.equalsIgnoreCase("Android")){
            meetingUrlField.clear();
        }else
        if(platform.equalsIgnoreCase("iOS")){
            meetingUrlField.clear();
            meetingUrlField.clear();
        }
    }

    public HomePage put_meeting_url(String meetingUrl) throws InterruptedException {
//        clear(meetingUrlField);
        meetingUrlField.clear();
        sendKeys(meetingUrlField, meetingUrl, "login with " + meetingUrl);
      return this;
    }

    public HomePage goto_enterName(String meetingUrl) throws InterruptedException {
      put_meeting_url(meetingUrl);
      click(joinMeetingBtn);
      return this;
    }

    //HomePage Participant name Popup
    @iOSXCUITFindBy(accessibility = "Enter your Name")
    @AndroidFindBy(xpath = "//android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public MobileElement participantNameField;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public MobileElement nameOKbtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public MobileElement nameCancelbtn;

    public HomePage put_participant_name(String name) throws InterruptedException {
      Thread.sleep(2000);
        clear(participantNameField);
      sendKeys(participantNameField, name, "Participant name- " + name);
      return this;
    }

    public PreviewPage goto_previewPage(String meetingUrl, String name) throws InterruptedException {
      goto_enterName(meetingUrl);
      put_participant_name(name);
      click(nameOKbtn);
//      accept_permission();
      Thread.sleep(5000);
      return new PreviewPage();
    }

    //HomePage OS permission
    @AndroidFindBy(id = "com.android.permissioncontroller:id/permission_allow_foreground_only_button")
    public MobileElement permissionCamMic;

    public void accept_permission() throws InterruptedException {
        String platform = BaseTest.selectPlatform();
        if (platform.equalsIgnoreCase("Android")) {
          Assert.assertTrue(permissionCamMic.isDisplayed());
          permissionCamMic.click();
            Thread.sleep(2000);
            permissionCamMic.click();
          Thread.sleep(2000);
        } else if (platform.equalsIgnoreCase("iOS")) {}
    }
}
