package Flutter.pageobject;

import base.AppDriver;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebDriver;

public class PreviewPage extends PagesCommon{

    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.widget.FrameLayout")
    public WebElement videoTile;

    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[4]")
    public WebElement camBtn;

    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[5]")
    public WebElement micBtn;

    @AndroidFindBy(accessibility = "Join Now")
    public WebElement joinNowBtn;

    @AndroidFindBy(accessibility = "Back")
    public WebElement backBtn;

    public void click_camBtn() throws InterruptedException {
        camBtn.click();
        Thread.sleep(3000);
    }

    public void click_micBtn() throws InterruptedException {
        micBtn.click();
        Thread.sleep(3000);
    }

    public void click_joinNowBtn() throws InterruptedException {
        joinNowBtn.click();
        Thread.sleep(3000);
    }

    public void click_backBtn() throws InterruptedException {
        backBtn.click();
        Thread.sleep(3000);
    }

}
