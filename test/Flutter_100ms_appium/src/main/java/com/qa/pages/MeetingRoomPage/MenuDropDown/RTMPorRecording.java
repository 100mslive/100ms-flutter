package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;

public class RTMPorRecording extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Record")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[4]")
    public WebElement startRtmpRecordBtn;

    @iOSXCUITFindBy(accessibility = "Recording")
    @AndroidFindBy(xpath = "//android.view.ViewGroup[5]")
    public WebElement stopRtmpRecordBtn;

    @iOSXCUITFindBy(accessibility = "")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public WebElement recordPopup;

    @iOSXCUITFindBy(accessibility = "")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public WebElement recordMeetingUrl;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public WebElement recordOKBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public WebElement recordCancelBtn;

    @iOSXCUITFindBy(accessibility = "b beam")
    @AndroidFindBy(accessibility = "B Beam")
    public WebElement beamBot;

    @iOSXCUITFindBy(accessibility = "Recording Started")
    @AndroidFindBy(accessibility = "Recording Started")
    public WebElement recordingStartedNotification;

    @iOSXCUITFindBy(accessibility = "Recording Stopped")
    @AndroidFindBy(accessibility = "Recording Stopped")
    public WebElement recordingStoppedNotification;

}
