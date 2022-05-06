package com.qa;

import com.aventstack.extentreports.Status;
import com.qa.reports.ExtentReport;
import com.qa.utils.TestUtils;
import io.appium.java_client.AppiumDriver;
import io.appium.java_client.FindsByAndroidUIAutomator;
import io.appium.java_client.InteractsWithApps;
import io.appium.java_client.MobileElement;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.pagefactory.AppiumFieldDecorator;
import io.appium.java_client.screenrecording.CanRecordScreen;
import io.appium.java_client.service.local.AppiumDriverLocalService;
import io.appium.java_client.service.local.AppiumServiceBuilder;
import io.appium.java_client.service.local.flags.GeneralServerFlag;
import org.apache.commons.codec.binary.Base64;
import org.apache.logging.log4j.ThreadContext;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import org.testng.ITestResult;
import org.testng.annotations.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.URL;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class BaseTest {
	protected static ThreadLocal <AppiumDriver> driver = new ThreadLocal<AppiumDriver>();
	protected static ThreadLocal <Properties> props = new ThreadLocal<Properties>();
	protected static ThreadLocal <HashMap<String, String>> strings = new ThreadLocal<HashMap<String, String>>();
	protected static ThreadLocal <String> platform = new ThreadLocal<String>();
	protected static ThreadLocal <String> dateTime = new ThreadLocal<String>();
	protected static ThreadLocal <String> deviceName = new ThreadLocal<String>();
	private static AppiumDriverLocalService server;
	TestUtils utils = new TestUtils();

	  public static AppiumDriver getDriver() {
		  return driver.get();
	  }

	  public void setDriver(AppiumDriver driver2) {
		  driver.set(driver2);
	  }

	  public Properties getProps() {
		  return props.get();
	  }

	  public void setProps(Properties props2) {
		  props.set(props2);
	  }

	  public HashMap<String, String> getStrings() {
		  return strings.get();
	  }

	  public void setStrings(HashMap<String, String> strings2) {
		  strings.set(strings2);
	  }

	  public String getPlatform() {
		  return platform.get();
	  }

	  public void setPlatform(String platform2) {
		  platform.set(platform2);
	  }

	  public String getDateTime() {
		  return dateTime.get();
	  }

	  public void setDateTime(String dateTime2) {
		  dateTime.set(dateTime2);
	  }

	  public String getDeviceName() {
		  return deviceName.get();
	  }

	  public void setDeviceName(String deviceName2) {
		  deviceName.set(deviceName2);
	  }

	public BaseTest() {
		PageFactory.initElements(new AppiumFieldDecorator(getDriver()), this);
	}

	@BeforeMethod
	public void beforeMethod() {
		((CanRecordScreen) getDriver()).startRecordingScreen();
	}

	//stop video capturing and create *.mp4 file
	@AfterMethod
	public synchronized void afterMethod(ITestResult result) throws Exception {
		String media = ((CanRecordScreen) getDriver()).stopRecordingScreen();

		Map <String, String> params = result.getTestContext().getCurrentXmlTest().getAllParameters();
		String dirPath = "videos" + File.separator + params.get("platformName") + "_" + params.get("deviceName")
		+ File.separator + getDateTime() + File.separator + result.getTestClass().getRealClass().getSimpleName();

		File videoDir = new File(dirPath);

		synchronized(videoDir){
			if(!videoDir.exists()) {
				videoDir.mkdirs();
			}
		}
		FileOutputStream stream = null;
		try {
			stream = new FileOutputStream(videoDir + File.separator + result.getName() + ".mp4");
			stream.write(Base64.decodeBase64(media));
			stream.close();
			utils.log().info("video path: " + videoDir + File.separator + result.getName() + ".mp4");
		} catch (Exception e) {
			utils.log().error("error during video capture" + e.toString());
		} finally {
			if(stream != null) {
				stream.close();
			}
		}
	}

	@BeforeSuite
	public void beforeSuite() throws Exception, Exception {
		ThreadContext.put("ROUTINGKEY", "ServerLogs");
		server = getAppiumService(); // -> If using Mac, uncomment this statement and comment below statement
//		server = getAppiumServerDefault(); // -> If using Windows, uncomment this statement and comment above statement
		if(!checkIfAppiumServerIsRunnning(4723)) {
			server.start();
			server.clearOutPutStreams(); // -> Comment this if you don't want to see server logs in the console
			utils.log().info("Appium server started");
		} else {
			utils.log().info("Appium server already running");
		}
	}

	public boolean checkIfAppiumServerIsRunnning(int port) throws Exception {
	    boolean isAppiumServerRunning = false;
	    ServerSocket socket;
	    try {
	        socket = new ServerSocket(port);
	        socket.close();
	    } catch (IOException e) {
	    	System.out.println("1");
	        isAppiumServerRunning = true;
	    } finally {
	        socket = null;
	    }
	    return isAppiumServerRunning;
	}

	@AfterSuite (alwaysRun = true)
	public void afterSuite() {
		  if(server.isRunning()){
			  server.stop();
			  utils.log().info("Appium server stopped");
		  }
	}

	// for Windows
//	public AppiumDriverLocalService getAppiumServerDefault() {
//		return AppiumDriverLocalService.buildDefaultService();
//	}

	// for Mac. Update the paths as per your Mac setup
	public AppiumDriverLocalService getAppiumService() {
		HashMap<String, String> environment = new HashMap<String, String>();
//		environment.put("PATH", "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin:/Users/ronitroy/Library/Android/sdk/tools:/Users/ronitroy/Library/Android/sdk/platform-tools:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin" + System.getenv("PATH"));
//		environment.put("ANDROID_HOME", "/Users/ronitroy/Library/Android/sdk"); //Uncomment for local

		environment.put("PATH", "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin:/Users/runner/Library/Android/sdk/tools:/Users/runner/Library/Android/sdk/platform-tools:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin" + System.getenv("PATH"));
		environment.put("ANDROID_HOME", "/Users/runner/Library/Android/sdk");

		return AppiumDriverLocalService.buildService(new AppiumServiceBuilder()
				.usingDriverExecutable(new File("/usr/local/bin/node"))
//				.withAppiumJS(new File("/Applications/Appium Server GUI.app/Contents/Resources/app/node_modules/appium/build/lib/main.js"))  //Uncomment for local
				.withAppiumJS(new File("/Users/runner/hostedtoolcache/node/11.15.0/x64/lib/node_modules/appium/build/lib/main.js"))
				.usingPort(4723)
				.withArgument(GeneralServerFlag.SESSION_OVERRIDE)
//				.withArgument(() -> "--allow-insecure","chromedriver_autodownload")
				.withEnvironment(environment)
				.withLogFile(new File("ServerLogs/server.log")));
	}

  @Parameters({"emulator", "platformName", /*"udid",*/ "deviceName", "systemPort",
	  "chromeDriverPort", "wdaLocalPort", "webkitDebugProxyPort"})
  @BeforeTest
  public void beforeTest(@Optional("androidOnly")String emulator, String platformName, /*String udid,*/ String deviceName,
		  @Optional("androidOnly")String systemPort, @Optional("androidOnly")String chromeDriverPort,
		  @Optional("iOSOnly")String wdaLocalPort, @Optional("iOSOnly")String webkitDebugProxyPort) throws Exception {
	  setDateTime(utils.dateTime());
	  setPlatform(platformName);
	  setDeviceName(deviceName);
	  URL url;
		InputStream inputStream = null;
		InputStream stringsis = null;
		Properties props = new Properties();
		AppiumDriver driver;

		String strFile = "logs" + File.separator + platformName + "_" + deviceName;
		File logFile = new File(strFile);
		if (!logFile.exists()) {
			logFile.mkdirs();
		}
		//route logs to separate file for each thread
		ThreadContext.put("ROUTINGKEY", strFile);
		utils.log().info("log path: " + strFile);

	  try {
		  props = new Properties();
		  String propFileName = "config.properties";
		  String xmlFileName = "strings/strings.xml";

		  utils.log().info("load " + propFileName);
		  inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);
		  props.load(inputStream);
		  setProps(props);

		  utils.log().info("load " + xmlFileName);
		  stringsis = getClass().getClassLoader().getResourceAsStream(xmlFileName);
		  setStrings(utils.parseStringXML(stringsis));

			DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
			desiredCapabilities.setCapability("platformName", platformName);
			desiredCapabilities.setCapability("deviceName", deviceName);
//			desiredCapabilities.setCapability("udid", udid);
			url = new URL(props.getProperty("appiumURL"));

			switch(platformName) {
			case "Android":
				desiredCapabilities.setCapability("automationName", props.getProperty("androidAutomationName"));
				desiredCapabilities.setCapability("appPackage", props.getProperty("androidAppPackage"));
				desiredCapabilities.setCapability("appActivity", props.getProperty("androidAppActivity"));
				if(emulator.equalsIgnoreCase("true")) {
					desiredCapabilities.setCapability("avd", deviceName);
					desiredCapabilities.setCapability("avdLaunchTimeout", 120000);
				}
				desiredCapabilities.setCapability("systemPort", systemPort);
				desiredCapabilities.setCapability("chromeDriverPort", chromeDriverPort);
				String androidAppUrl = System.getProperty("user.dir") + File.separator + "src" + File.separator + "test"
							+ File.separator + "resources" + File.separator + "app" + File.separator + "app-release.apk";
//				String androidAppUrl = getClass().getResource(props.getProperty("androidAppLocation")).getFile();
				utils.log().info("appUrl is" + androidAppUrl);
				desiredCapabilities.setCapability("app", androidAppUrl);
				desiredCapabilities.setCapability("noReset", "true");
				desiredCapabilities.setCapability("autoGrantPermissions", "true");
				driver = new AndroidDriver(url, desiredCapabilities);
				break;
			case "iOS":
				desiredCapabilities.setCapability("automationName", props.getProperty("iOSAutomationName"));
				String iOSAppUrl = System.getProperty("user.dir") + File.separator + "src" + File.separator + "test"
						+ File.separator + "resources" + File.separator + "app" + File.separator + "SwagLabsMobileApp.app";
			//	String iOSAppUrl = getClass().getResource(props.getProperty("iOSAppLocation")).getFile();
				utils.log().info("appUrl is" + iOSAppUrl);
				desiredCapabilities.setCapability("bundleId", props.getProperty("iOSBundleId"));
				desiredCapabilities.setCapability("wdaLocalPort", wdaLocalPort);
				desiredCapabilities.setCapability("webkitDebugProxyPort", webkitDebugProxyPort);
				desiredCapabilities.setCapability("app", iOSAppUrl);

				driver = new IOSDriver(url, desiredCapabilities);
				break;
			default:
				throw new Exception("Invalid platform! - " + platformName);
			}
			setDriver(driver);
			utils.log().info("driver initialized: " + driver);
	  } catch (Exception e) {
		  utils.log().fatal("driver initialization failure. ABORT!!!\n" + e.toString());
		  throw e;
	  } finally {
		  if(inputStream != null) {
			  inputStream.close();
		  }
		  if(stringsis != null) {
			  stringsis.close();
		  }
	  }
  }

  public void waitForVisibility(MobileElement e) {
//	  WebDriverWait wait = new WebDriverWait(getDriver(), TestUtils.WAIT);
	  Wait<WebDriver> wait = new FluentWait<WebDriver>(getDriver())
			  .withTimeout(Duration.ofSeconds(30))
			  .pollingEvery(Duration.ofSeconds(5))
			  .ignoring(NoSuchElementException.class);
	  wait.until(ExpectedConditions.visibilityOf(e));
  }

  public void waitForVisibility(WebElement e){
	  Wait<WebDriver> wait = new FluentWait<WebDriver>(getDriver())
	  .withTimeout(Duration.ofSeconds(30))
	  .pollingEvery(Duration.ofSeconds(5))
	  .ignoring(NoSuchElementException.class);
	  wait.until(ExpectedConditions.visibilityOf(e));
	  }

  public void clear(MobileElement e) {
	  waitForVisibility(e);
	  e.clear();
  }

  public void click(MobileElement e) {
	  waitForVisibility(e);
	  e.click();
  }

  public void click(MobileElement e, String msg) {
	  waitForVisibility(e);
	  utils.log().info(msg);
	  ExtentReport.getTest().log(Status.INFO, msg);
	  e.click();
  }

  public void sendKeys(MobileElement e, String txt) {
	  waitForVisibility(e);
	  e.sendKeys(txt);
  }

  public void sendKeys(MobileElement e, String txt, String msg) {
	  waitForVisibility(e);
	  utils.log().info(msg);
	  ExtentReport.getTest().log(Status.INFO, msg);
	  e.sendKeys(txt);
  }

  public String getAttribute(MobileElement e, String attribute) {
	  waitForVisibility(e);
	  return e.getAttribute(attribute);
  }

  public String getText(MobileElement e, String msg) {
	  String txt = null;
	  switch(getPlatform()) {
	  case "Android":
		  txt = getAttribute(e, "text");
		  break;
	  case "iOS":
		  txt = getAttribute(e, "label");
		  break;
	  }
	  utils.log().info(msg + txt);
	  ExtentReport.getTest().log(Status.INFO, msg + txt);
	  return txt;
  }

	public String getContextDesc(MobileElement e, String msg) {
		String txt = null;
		switch(getPlatform()) {
			case "Android":
				txt = getAttribute(e, "content-desc");
				break;
			case "iOS":
				txt = getAttribute(e, "label");
				break;
		}
		utils.log().info(msg + txt);
		ExtentReport.getTest().log(Status.INFO, msg + txt);
		return txt;
	}

  public void closeApp() {
	  ((InteractsWithApps) getDriver()).closeApp();
  }

  public void launchApp() {
	  ((InteractsWithApps) getDriver()).launchApp();
  }

  public MobileElement scrollToElement() {
		return (MobileElement) ((FindsByAndroidUIAutomator) getDriver()).findElementByAndroidUIAutomator(
				"new UiScrollable(new UiSelector()" + ".scrollable(true)).scrollIntoView("
						+ "new UiSelector().description(\"test-Price\"));");
  }

  public void iOSScrollToElement() {
	  RemoteWebElement element = (RemoteWebElement)getDriver().findElement(By.name("test-ADD TO CART"));
	  String elementID = element.getId();
	  HashMap<String, String> scrollObject = new HashMap<String, String>();
	  scrollObject.put("element", elementID);
//	  scrollObject.put("direction", "down");
//	  scrollObject.put("predicateString", "label == 'ADD TO CART'");
//	  scrollObject.put("name", "test-ADD TO CART");
	  scrollObject.put("toVisible", "sdfnjksdnfkld");
	  getDriver().executeScript("mobile:scroll", scrollObject);
  }

  @AfterTest (alwaysRun = true)
  public void afterTest() {
		  if(getDriver() != null){
			  getDriver().quit();
		  }
  }

    public static String selectPlatform(){
      String platform = getDriver().getPlatformName();
      return platform;
    }

    public static void default_back() throws InterruptedException {
      Thread.sleep(2000);
      getDriver().navigate().back();
    }
}
