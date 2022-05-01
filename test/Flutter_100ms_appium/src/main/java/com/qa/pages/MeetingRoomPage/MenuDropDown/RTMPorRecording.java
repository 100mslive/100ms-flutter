package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.MobileElement;


public class RTMPorRecording extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Record")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[4]")
    public MobileElement startRtmpRecordBtn;

    @iOSXCUITFindBy(accessibility = "Recording")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[5]")
    public MobileElement stopRtmpRecordBtn;

    @iOSXCUITFindBy(accessibility = "")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public MobileElement recordPopup;

    @iOSXCUITFindBy(accessibility = "")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public MobileElement recordMeetingUrl;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public MobileElement recordOKBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public MobileElement recordCancelBtn;

    @iOSXCUITFindBy(accessibility = "b beam")
    @AndroidFindBy(accessibility = "B Beam")
    public MobileElement beamBot;

    @iOSXCUITFindBy(accessibility = "Recording Started")
    @AndroidFindBy(accessibility = "Recording Started")
    public MobileElement recordingStartedNotification;

    @iOSXCUITFindBy(accessibility = "Recording Stopped")
    @AndroidFindBy(accessibility = "Recording Stopped")
    public MobileElement recordingStoppedNotification;

}
