package com.qa.pages.MeetingRoomPage.MenuDropDown;

<<<<<<< HEAD
import com.qa.BaseTest;
=======
import com.qa.pages.MeetingRoomPage.MeetingRoom;
>>>>>>> newapp
import io.appium.java_client.pagefactory.AndroidFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

<<<<<<< HEAD
public class StartHls extends BaseTest {
=======
public class StartHls extends MeetingRoom {
>>>>>>> newapp

    //@iOSXCUITFindBy(accessibility = "Start HLS")
    @AndroidFindBy(accessibility = "Start HLS")
    public WebElement startHLSBtn;

    public void click_startHLSBtn() throws InterruptedException {
        Assert.assertTrue(startHLSBtn.isDisplayed());
        startHLSBtn.click();
        Thread.sleep(3000);
    }
}
