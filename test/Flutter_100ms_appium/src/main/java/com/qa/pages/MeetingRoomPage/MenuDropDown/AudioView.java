package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class AudioView extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(accessibility = "Audio View")
    public MobileElement audioViewBtn;

    @iOSXCUITFindBy(accessibility = "Video View")
    @AndroidFindBy(accessibility = "Video View")
    public MobileElement videoViewBtn;

}
