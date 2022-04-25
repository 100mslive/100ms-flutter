package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class Record extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Record")
    @AndroidFindBy(accessibility = "Record")
    public MobileElement recordBtn;

    @iOSXCUITFindBy(accessibility = "Recording")
    @AndroidFindBy(xpath = "//android.widget.Button[@content-desc='Recording ']")
    public MobileElement recordingBtn;

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
    @AndroidFindBy(accessibility = "b beam")
    public MobileElement beamBot;

    @iOSXCUITFindBy(accessibility = "Recording Started")
    @AndroidFindBy(accessibility = "Recording Started")
    public MobileElement recordingStartedNotification;

    @iOSXCUITFindBy(accessibility = "Recording Stopped")
    @AndroidFindBy(accessibility = "Recording Stopped")
    public MobileElement recordingStoppedNotification;

}
