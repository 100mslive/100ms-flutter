package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class SetLayout extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
    public WebElement setLayoutBtn;

    @iOSXCUITFindBy(accessibility = "Video View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.TextView")
    public WebElement layoutModalPopup;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.Spinner")
    public WebElement dropDownArrow;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
    public WebElement normalBtn;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
    public WebElement audioBtn;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]/android.view.ViewGroup[1]")
    public WebElement cancelBtn;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]/android.view.ViewGroup[2]")
    public WebElement setBtn;

    public void click_setLayoutBtn() throws InterruptedException {
        Assert.assertTrue(setLayoutBtn.isDisplayed());
        setLayoutBtn.click();
        Thread.sleep(3000);
    }

    public void click_dropDownArrow() throws InterruptedException {
      Assert.assertTrue(dropDownArrow.isDisplayed());
      dropDownArrow.click();
      Thread.sleep(3000);
    }

    public void click_normalBtn() throws InterruptedException {
      Assert.assertTrue(normalBtn.isDisplayed());
      normalBtn.click();
      Thread.sleep(3000);
    }

    public void click_audioBtn() throws InterruptedException {
      Assert.assertTrue(audioBtn.isDisplayed());
      audioBtn.click();
      Thread.sleep(3000);
    }

    public void click_cancelBtn() throws InterruptedException {
      Assert.assertTrue(cancelBtn.isDisplayed());
      cancelBtn.click();
      Thread.sleep(3000);
    }
    public void click_setBtn() throws InterruptedException {
        Assert.assertTrue(setBtn.isDisplayed());
        setBtn.click();
        Thread.sleep(3000);
    }
}
