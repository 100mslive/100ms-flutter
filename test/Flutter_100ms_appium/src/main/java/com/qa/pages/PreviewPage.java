package com.qa.pages;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;

public class PreviewPage extends HomePage {

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeOther[@name='platform_view[0]']/XCUIElementTypeOther/XCUIElementTypeOther")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.widget.FrameLayout")
    public MobileElement videoTile;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[4]")
    @AndroidFindBy(xpath = "//android.view.View[4]")
    public MobileElement camBtn;

    @iOSXCUITFindBy(accessibility = "previewMuteAudio")
    @AndroidFindBy(xpath = "//android.view.View[5]")
    public MobileElement micBtn;

    @iOSXCUITFindBy(accessibility = "previewModalJoin")
    @AndroidFindBy(accessibility = "Join Now")
    public MobileElement joinNowBtn;

    @iOSXCUITFindBy(accessibility = "previewModalJoin")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.view.ViewGroup[2]")
    public MobileElement previewList;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility = "Back")
    public WebElement backBtn;

    @iOSXCUITFindBy(accessibility = "Preview")
    @AndroidFindBy(accessibility = "Preview")
    public WebElement previewPageHeading;

    public MeetingRoom goto_meetingRoom_mic_cam(String meetingUrl, String name, String cam,String mic) throws InterruptedException {
      goto_previewPage(meetingUrl, name);
      if(cam.equalsIgnoreCase("on") && mic.equalsIgnoreCase("off"))
        click(micBtn);
      else if(cam.equalsIgnoreCase("off") && mic.equalsIgnoreCase("on"))
        click(camBtn);
      else if(cam.equalsIgnoreCase("off") && mic.equalsIgnoreCase("off"))
      {click(micBtn); click(camBtn);}

      click(joinNowBtn);
<<<<<<< HEAD
=======
      Thread.sleep(2000);
>>>>>>> newapp
      return new MeetingRoom();
    }
}
