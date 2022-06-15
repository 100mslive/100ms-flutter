package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;

public class MuteAll extends MeetingRoom {

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Mute")
    public MobileElement muteBtn;

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public MobileElement mutePopup;

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(xpath = "//android.view.View[2]/android.view.View/android.widget.CheckBox")
    public MobileElement muteAllCheckbox;

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Mute")
    public MobileElement muteAllBtn;


    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Successfully Muted All")
    public MobileElement muteAllNotification;

}
