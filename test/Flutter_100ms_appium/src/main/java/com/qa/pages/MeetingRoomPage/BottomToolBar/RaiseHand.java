package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class RaiseHand extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "raiseHand")
    @AndroidFindBy(accessibility = "raiseHand")
    public MobileElement raiseHandBtn;

    @iOSXCUITFindBy(accessibility = "Raised Hand ON")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[4]/android.widget.HorizontalScrollView/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.TextView")
    public MobileElement raiseHandOnTile;

}
