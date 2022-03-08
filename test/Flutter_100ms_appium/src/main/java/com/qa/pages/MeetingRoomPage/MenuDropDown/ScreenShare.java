package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class ScreenShare extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[8]")
    public MobileElement screenShareBtn;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(id = "android:id/button1")
    public MobileElement screenShareStartNowBtn;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(id = "android:id/button2")
    public MobileElement screenShareCancelBtn;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]")
    public MobileElement screenShareTile;

    @iOSXCUITFindBy(accessibility = "Share")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView[2]")
    public MobileElement screenShareLogo;

//    public void ss_start_now_permission() throws InterruptedException {
//        String platform = PlatformSelector.selectPlatform();
//        if (platform.equalsIgnoreCase("Android")) {
//            Assert.assertTrue(screenShareStartNowBtn.isDisplayed());
//            screenShareStartNowBtn.click();
//            Thread.sleep(3000);
//        } else if (platform.equalsIgnoreCase("iOS")) {
//            //to add ios logic
//        }
//    }
//
//    public void ss_cancel_permission() throws InterruptedException {
//        String platform = PlatformSelector.selectPlatform();
//        if (platform.equalsIgnoreCase("Android")) {
//            Assert.assertTrue(screenShareCancelBtn.isDisplayed());
//            screenShareCancelBtn.click();
//            Thread.sleep(3000);
//        } else if (platform.equalsIgnoreCase("iOS")) {
//            //to add ios logic
//        }
//    }
}
