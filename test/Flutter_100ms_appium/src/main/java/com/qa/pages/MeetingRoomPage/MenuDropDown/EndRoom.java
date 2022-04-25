package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.TopToolBar;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class EndRoom extends TopToolBar {

    @iOSXCUITFindBy(accessibility = "End Room")
    @AndroidFindBy(accessibility = "End Room")
    public MobileElement endRoomBtn;

    public EndRoom end_room_for_all() throws InterruptedException {
        click(menuBtn);
        Thread.sleep(2000);
        click(endRoomBtn);
        return this;
    }
}
