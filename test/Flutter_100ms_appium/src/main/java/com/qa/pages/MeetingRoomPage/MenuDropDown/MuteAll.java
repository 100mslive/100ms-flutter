package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;

public class MuteAll extends MeetingRoom {

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Mute All")
    public MobileElement muteAllBtn;

    //@iOSXCUITFindBy(accessibility = "Mute All")
    @AndroidFindBy(accessibility = "Successfully Muted All")
    public MobileElement muteAllNotification;

}
