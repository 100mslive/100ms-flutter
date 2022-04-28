package com.qa.pages.MeetingRoomPage.BottomToolBar;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;

public class Chat extends BaseTest {

    @iOSXCUITFindBy(accessibility = "sendMessage")
    @AndroidFindBy(accessibility = "sendMessage")
    public WebElement chatBtn;

    @iOSXCUITFindBy(accessibility = "Everyone")
    @AndroidFindBy(accessibility = "Everyone")
    public WebElement chatRoleBtn;

    @iOSXCUITFindBy(accessibility = "Everyone")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.widget.EditText")
    public WebElement chatEnterMsgBtn;

    @iOSXCUITFindBy(accessibility = "Everyone")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View[3]")
    public WebElement chatSendBtn;

    //need a unique xpath
    @iOSXCUITFindBy(accessibility = "Everyone")
    @AndroidFindBy(accessibility = "Everyone")
    public WebElement chatCrossBtn;

}
