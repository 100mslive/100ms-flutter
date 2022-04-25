package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class LeaveRoom extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Leave Or End")
    @AndroidFindBy(accessibility = "Leave Or End")
    public MobileElement leaveRoomBtn;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public MobileElement leaveRoomPopup;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther")
    @AndroidFindBy(accessibility = "Leave Room?")
    public MobileElement leaveRoomPopupText;

    @iOSXCUITFindBy(accessibility = "Yes")
    @AndroidFindBy(accessibility = "Yes")
    public MobileElement leaveRoomYesBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public MobileElement leaveRoomCancelBtn;

    @iOSXCUITFindBy(accessibility = "Meeting Ended")
    @AndroidFindBy(accessibility = "Meeting Ended")
    public MobileElement meetingEndedNotification;

    //make a function to press leave room buttton
    public LeaveRoom leave_withoutEndingRoom() throws InterruptedException {
        click(leaveRoomBtn);
        Thread.sleep(2000);
        click(leaveRoomYesBtn);
         return this;
    }

}
