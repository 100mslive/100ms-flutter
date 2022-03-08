package com.qa.pages.MeetingRoomPage.HamBurger;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class ChangeName extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Change Name")
    @AndroidFindBy(accessibility = "Change Name")
    public WebElement changeNameBtn;

    @iOSXCUITFindBy(accessibility = "Change Name")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public WebElement changeNamePopup;

    @iOSXCUITFindBy(accessibility = "Change Name")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public WebElement changeNameField;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public WebElement changeNameOkBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public WebElement changeNameCancelBtn;

    public void click_changeNameBtn() throws InterruptedException {
        Assert.assertTrue(changeNameBtn.isDisplayed());
        changeNameBtn.click();
        Thread.sleep(3000);
    }

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "Name Changed to Ronit New Name" )
    public static WebElement nameChange_Notification;

    public void click_changeNameOkBtn() throws InterruptedException {
        Assert.assertTrue(changeNameOkBtn.isDisplayed());
        changeNameOkBtn.click();
        Thread.sleep(3000);
    }

    public void click_changeNameCancelBtn() throws InterruptedException {
        Assert.assertTrue(changeNameCancelBtn.isDisplayed());
        changeNameCancelBtn.click();
        Thread.sleep(3000);
    }

    public void put_change_name(String txt){
        Assert.assertTrue(changeNameField.isDisplayed());
        changeNameField.sendKeys(txt);
    }
}
