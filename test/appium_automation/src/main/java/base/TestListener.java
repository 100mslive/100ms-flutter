package base;

import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

import java.net.MalformedURLException;

public class TestListener implements ITestListener{

    @Override
    public void onTestStart(ITestResult result) {
        AppiumServer.Start();

        String Platform = result.getMethod().getXmlTest().getLocalParameters().get("platform");

        if(Platform.contains("android_flutter")) {
            try {
                AppFactory.Android_Flutter_LaunchApp();
            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
        }else
        if(Platform.contains("ios_flutter")){
            try {
                AppFactory.iOS_Flutter_LaunchApp();
            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        try {
            tearDown();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTestFailure(ITestResult result) {
        try {
            tearDown();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        try {
            tearDown();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onTestFailedButWithinSuccessPercentage(ITestResult result) {

    }

    @Override
    public void onTestFailedWithTimeout(ITestResult result) {

    }

    @Override
    public void onStart(ITestContext context) {

    }

    @Override
    public void onFinish(ITestContext context) {

    }

    public void tearDown() throws InterruptedException {
        AppDriver.getDriver().quit();
        AppiumServer.Stop();
        Thread.sleep(3000);
    }
}
