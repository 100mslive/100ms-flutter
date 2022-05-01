package com.qa.pages.MeetingRoomPage;

import com.qa.pages.PreviewPage;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class MeetingRoom extends PreviewPage {

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "Ronit Roy (You)" )
    public static MobileElement myTile;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "Ronit New Name (You)" )
    public static MobileElement myTile_nameChange;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "//android.view.View[@content-desc='Ronit Roy (You)']/android.widget.FrameLayout" )
    public static MobileElement VideoTile_myTile;


}
