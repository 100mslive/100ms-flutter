package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.BaseTest;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class AudioVideo extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Video")
    @AndroidFindBy(accessibility = "Video")
    public static MobileElement camBtn;

    @iOSXCUITFindBy(accessibility = "Audio")
    @AndroidFindBy(accessibility = "Audio")
    public MobileElement micBtn;

}
