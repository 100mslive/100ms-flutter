package com.qa.pages.MeetingRoomPage.BottomToolBar;


import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

//import org.openqa.selenium.WebElement;
//import org.testng.Assert;
//
//public class LeaveRoom extends MeetingRoom {
//
//    @iOSXCUITFindBy(accessibility = "leaveMeeting")
//    @AndroidFindBy(accessibility = "leaveMeeting")
//    public MobileElement leaveRoomBtn;
//
//    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther")
//    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup")
//    public MobileElement leaveRoomPopup;
//
//    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther")
//    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView")
//    public MobileElement leaveRoomPopupText;
//
//    @iOSXCUITFindBy(accessibility = "Leave Room?")
//    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
//    public MobileElement leaveWithoutEndingRoom;
//
//    @iOSXCUITFindBy(accessibility = "Yes")
//    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[3]")
//    public MobileElement endRoomForAll;
//
//    @iOSXCUITFindBy(accessibility = "Yes")
//    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]")
//    public MobileElement leaveRoomCancelBtn;
//
//    //make a function to press leave room buttton
//    public LeaveRoom leave_withoutEndingRoom() {
//      click(leaveRoomBtn);
//      click(leaveWithoutEndingRoom);
//      return this;
//    }
//
//    public LeaveRoom leave_endRoomForAll() throws InterruptedException {
//      click(leaveRoomBtn);
//      Thread.sleep(2000);
//      click(endRoomForAll);
//      return this;
//    }


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
//    public LeaveRoom leave_endRoomForAll() throws InterruptedException {
//        click(leaveRoomBtn);
//        Thread.sleep(2000);
//        click(endRoomForAll);
//        return this;
//    }
//
//    @iOSXCUITFindBy(accessibility = "Yes")
//    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[3]")
//    public MobileElement endRoomForAll;

}
