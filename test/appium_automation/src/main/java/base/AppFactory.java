package base;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.ios.IOSDriver;
import org.openqa.selenium.remote.DesiredCapabilities;

import java.net.MalformedURLException;
import java.net.URL;

public class AppFactory {

    public static AppiumDriver<MobileElement> driver;
    public static DesiredCapabilities cap;

    public static void Android_Flutter_LaunchApp() throws MalformedURLException {
        cap = new DesiredCapabilities();
        cap.setCapability("platformName", "Android");
        cap.setCapability("deviceName", "Pixle 4");
        cap.setCapability("platformVersion", "12.0");
        cap.setCapability("automationName", "UiAutomator2");
        //cap.setCapability("appPackage", "com.android.calculator2");
        //cap.setCapability("appActivity", ".Calculator");
        cap.setCapability("appPackage", "live.hms.flutter");
        cap.setCapability("appActivity", ".MainActivity");
        //cap.setCapability("app", "/Users/ronitroy/Appium_extra/app-release.apk ");
        cap.setCapability("avd", "Pixel_4_API_31");
        driver = new AndroidDriver<MobileElement>(new URL("http://0.0.0.0:4723/wd/hub"), cap);
        AppDriver.setDriver(driver);
        System.out.println("Android Flutter driver is set");
    }

    public static void iOS_Flutter_LaunchApp() throws MalformedURLException {
        cap = new DesiredCapabilities();
        cap.setCapability("platformName", "iOS");
        cap.setCapability("deviceName", "iPhone 13");
        cap.setCapability("automationName", "XCUITest");
        cap.setCapability("platformVersion", "15.2");
        //cap.setCapability("usePrebuiltWDA", true);
        //cap.setCapability("bundleId", "com.SamadiPour.SimpleCalculator");
        //cap.setCapability("bundleId", "com.example.apple-samplecode.UICatalog");
        //cap.setCapability("bundleId", "com.apple.MobileAddressBook");
        //cap.setCapability("bundleId", "io.cloudgrey.the-app");
        //cap.setCapability("app", "/Users/ronitroy/GitHub/appium_automation/ios_automation/build/Release-iphonesimulator/ios_automation.app");
        cap.setCapability("appium:bundleId", "live.100ms.flutter");
        cap.setCapability("noReset", true);
        driver = new IOSDriver<MobileElement>(new URL("http://127.0.0.1:4723/wd/hub"), cap);
        AppDriver.setDriver(driver);
        System.out.println("iOS Flutter driver is set");
    }

    public static void closeApp(){
        driver.quit();
    }

}
