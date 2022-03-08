package com.qa.pages.MeetingRoomPage;

import com.qa.BaseTest;
import com.qa.pages.PreviewPage;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class TopToolBar extends PreviewPage {

    @iOSXCUITFindBy(accessibility = "Audio")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView")
    public MobileElement headingCta;

    @iOSXCUITFindBy(accessibility = "Show menu")
    @AndroidFindBy(xpath = "  //android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.TextView")
    public MobileElement switchCamBtn;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeButton[2]")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]/android.widget.TextView")
    public MobileElement speakerBtn;

    @iOSXCUITFindBy(accessibility = "Show menu")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[3]/android.widget.TextView")
    public static MobileElement menuBtn;

    @iOSXCUITFindBy(accessibility = "Show menu")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup")
    public MobileElement settingPopupHeading;

    public TopToolBar goto_meetingRoom_menuPage(String meetingUrl, String name, String cam, String mic) throws InterruptedException {
      goto_meetingRoom_mic_cam(meetingUrl, name, cam, mic);
      Thread.sleep(2000);
      click(menuBtn);
      return new TopToolBar();
    }

}
