package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class BRB extends BaseTest {

    @iOSXCUITFindBy(accessibility = "BRB BRB")
    @AndroidFindBy(accessibility = "BRB BRB")
    public MobileElement brbBtn;


}
