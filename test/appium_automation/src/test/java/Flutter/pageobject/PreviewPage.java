package Flutter.pageobject;

import base.AppDriver;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebDriver;

public class PreviewPage extends PagesCommon{

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeOther[@name='platform_view[0]']/XCUIElementTypeOther/XCUIElementTypeOther")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.widget.FrameLayout")
    public WebElement videoTile;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[4]")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[4]")
    public WebElement camBtn;

    @iOSXCUITFindBy(xpath = "//XCUIElementTypeApplication[@name='Flutter 100ms']/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]/XCUIElementTypeOther[5]")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[5]")
    public WebElement micBtn;

    @iOSXCUITFindBy(accessibility = "Join Now")
    @AndroidFindBy(accessibility = "Join Now")
    public WebElement joinNowBtn;

    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility = "Back")
    public WebElement backBtn;

    @iOSXCUITFindBy(accessibility = "Preview")
    @AndroidFindBy(accessibility = "Preview")
    public WebElement previewPageHeading;

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
