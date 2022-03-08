package com.qa.pages;

import org.json.JSONObject;
import org.json.JSONTokener;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.IOException;
import java.io.InputStream;

public class DesktopWebPage {
  WebDriver driver;
  JSONObject meetingDetail;

  public void start_web_meeting() throws InterruptedException, IOException {
    System.setProperty("webdriver.chrome.driver", "/Users/ronitroy/IdeaProjects/react-native-hms/test/RN_100ms_appium/src/test/resources/app/chromedriver 2");
    ChromeOptions options = new ChromeOptions();
    options.addArguments("use-fake-ui-for-media-stream");
    driver = new ChromeDriver(options);

    InputStream datais = null;
    try {
      String dataFileName = "data/meetingDetail.json";
      datais = getClass().getClassLoader().getResourceAsStream(dataFileName);
      JSONTokener tokener = new JSONTokener(datais);
      meetingDetail = new JSONObject(tokener);
    } catch(Exception e) {
      e.printStackTrace();
      throw e;
    } finally {
      if(datais != null) {
        datais.close();
      }
    }

    String meeting_url = meetingDetail.getJSONObject("valid").getString("meeting_url");
    driver.get(meeting_url);
    Thread.sleep(5000);

    WebElement name_locator = driver.findElement(By.cssSelector("[autocorrect]"));
    name_locator.sendKeys("Web");
    Thread.sleep(5000);

    WebElement join_btn = driver.findElement(By.cssSelector(".hmsui-button.icon-size-lg.tw-1plf0r2.tw-ki16hf"));
    join_btn.click();
  }

    public void end_web_meeting() throws InterruptedException {
      Thread.sleep(1000);
      driver.quit();
      Thread.sleep(1000);
  }
}
//  DesktopWebPage desktopWebPage = new DesktopWebPage();
//      desktopWebPage.start_web_meeting();
//        Thread.sleep(1000);
//        desktopWebPage.end_web_meeting();
