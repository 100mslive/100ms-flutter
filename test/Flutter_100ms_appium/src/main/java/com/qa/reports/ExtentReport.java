package com.qa.reports;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;

import java.util.HashMap;
import java.util.Map;

public class ExtentReport {
    public static ExtentReports extent;
    final static String filePath = "Extent.html";
    static Map<Integer, ExtentTest> extentTestMap = new HashMap();

    public synchronized static ExtentReports getReporter() {
        if (extent == null) {
        	ExtentSparkReporter html = new ExtentSparkReporter("Extent.html");
        	html.config().setDocumentTitle("Appium Framework");
        	html.config().setReportName("MyApp");
        	html.config().setTheme(Theme.DARK);
            extent = new ExtentReports();
            extent.attachReporter(html);
        }

        return extent;
    }

    public static synchronized ExtentTest getTest() {
        return (ExtentTest) extentTestMap.get((int) (long) (Thread.currentThread().getId()));
    }

    public static synchronized ExtentTest startTest(String testName, String desc) {
        ExtentTest test = getReporter().createTest(testName, desc);
        extentTestMap.put((int) (long) (Thread.currentThread().getId()), test);
        return test;
    }
}
