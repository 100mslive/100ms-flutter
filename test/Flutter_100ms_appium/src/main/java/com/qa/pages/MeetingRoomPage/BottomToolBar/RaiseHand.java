package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class RaiseHand extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Raised Hand ON")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[4]/android.widget.HorizontalScrollView/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.TextView")
    public MobileElement raiseHandOnTile;

    @iOSXCUITFindBy(accessibility = "RaiseHand")
    @AndroidFindBy(accessibility = "RaiseHand")
    public MobileElement raiseHandBtn;

    @iOSXCUITFindBy(accessibility = "Raised Hand ON")
    @AndroidFindBy(accessibility = "Raised Hand ON")
    public MobileElement raiseHandOnNotifictaion;

    @iOSXCUITFindBy(accessibility = "Raised Hand OFF")
    @AndroidFindBy(accessibility = "Raised Hand OFF")
    public MobileElement raiseHandOffNotifictaion;

    @iOSXCUITFindBy(accessibility = "Raised Hand OFF")
    @AndroidFindBy(accessibility = "Expand")
    public MobileElement expand;

}
