package base;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.RemoteWebDriver;

public class PlatformSelector {

    public static String selectPlatform(){
        String platform = (String)((RemoteWebDriver) AppDriver.getDriver())
                .getCapabilities()
                .getCapability("platformName");
        return platform;
    }
}
