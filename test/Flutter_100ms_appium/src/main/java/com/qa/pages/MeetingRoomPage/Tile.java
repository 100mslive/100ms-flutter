package com.qa.pages.MeetingRoomPage;

import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;

public class Tile extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "Ronit (You)" )
    public static MobileElement myTile;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "Ronit New Name (You)" )
    public static MobileElement myTile_nameChange;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(xpath =  "//android.view.View[@content-desc='Ronit Roy (You)']/android.widget.FrameLayout" )
    public static MobileElement VideoTile_myTile;

    @iOSXCUITFindBy(accessibility = "Unmute video")
    @AndroidFindBy(accessibility =  "Unmute video" )
    public static MobileElement peer_unmute_video;

    @iOSXCUITFindBy(accessibility = "Unmute audio")
    @AndroidFindBy(accessibility =  "Unmute audio" )
    public static MobileElement peer_unmute_audio;

    @iOSXCUITFindBy(accessibility = "Remove Peer")
    @AndroidFindBy(accessibility =  "Remove Peer" )
    public static MobileElement peer_remove_peer;


}
