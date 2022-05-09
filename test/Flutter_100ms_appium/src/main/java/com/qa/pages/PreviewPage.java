package com.qa.pages;

import com.aventstack.extentreports.Status;
import com.qa.pages.MeetingRoomPage.MeetingRoom;
import com.qa.reports.ExtentReport;
import com.qa.utils.TestUtils;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;

public class PreviewPage extends HomePage {

    TestUtils utils = new TestUtils();

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeOther[@name='platform_view[0]']/XCUIElementTypeOther/XCUIElementTypeOther")
    @AndroidFindBy(xpath = "//android.view.View[1]/android.widget.FrameLayout")
    public MobileElement videoTile;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[4]")
    @AndroidFindBy(xpath = "//android.view.View[2]")
    public MobileElement camBtn;

    @iOSXCUITFindBy(accessibility = "previewMuteAudio")
    @AndroidFindBy(xpath = "//android.view.View[3]")
    public MobileElement micBtn;

    @iOSXCUITFindBy(accessibility = "previewModalJoin")
    @AndroidFindBy(accessibility = "Join Now")
    public MobileElement joinNowBtn;

    @iOSXCUITFindBy(accessibility = "previewModalJoin")
    @AndroidFindBy(xpath = "//android.widget.Button[1]")
    public MobileElement previewList;

    @iOSXCUITFindBy(accessibility = "previewModalJoin")
    @AndroidFindBy(xpath = "//android.view.View/android.widget.ImageView")
    public MobileElement networkBar;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility = "Back")
    public MobileElement backBtn;

    @iOSXCUITFindBy(accessibility = "Preview")
    @AndroidFindBy(accessibility = "Preview")
    public MobileElement previewPageHeading;

    public MeetingRoom goto_meetingRoom_mic_cam(String meetingUrl, String name, String cam,String mic) throws InterruptedException {
      goto_previewPage(meetingUrl, name);
      if(cam.equalsIgnoreCase("on") && mic.equalsIgnoreCase("off"))
        click(micBtn, "micBtn");
      else if(cam.equalsIgnoreCase("off") && mic.equalsIgnoreCase("on"))
        click(camBtn, "camBtn");
      else if(cam.equalsIgnoreCase("off") && mic.equalsIgnoreCase("off"))
      {click(micBtn, "micBtn"); click(camBtn,"camBtn");}

      click(joinNowBtn,"joinNowBtn");
      Thread.sleep(2000);
      utils.log().info("In Meeting Room" );
      ExtentReport.getTest().log(Status.INFO, "In Meeting Room");
      return new MeetingRoom();
    }
}
