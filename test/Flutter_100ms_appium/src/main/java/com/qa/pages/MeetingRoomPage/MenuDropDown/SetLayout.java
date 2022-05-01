package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.BaseTest;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import io.appium.java_client.MobileElement;
import org.testng.Assert;

public class SetLayout extends BaseTest {

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
    public MobileElement setLayoutBtn;

    @iOSXCUITFindBy(accessibility = "Video View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.TextView")
    public MobileElement layoutModalPopup;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.Spinner")
    public MobileElement dropDownArrow;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
    public MobileElement normalBtn;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]")
    public MobileElement audioBtn;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]/android.view.ViewGroup[1]")
    public MobileElement cancelBtn;

    @iOSXCUITFindBy(accessibility = "Audio View")
    @AndroidFindBy(xpath = "//android.widget.FrameLayout/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup[2]/android.view.ViewGroup[2]")
    public MobileElement setBtn;

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
