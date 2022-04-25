package com.qa.tests;


import com.qa.BaseTest;
import com.qa.pages.HomePage;
import com.qa.pages.PageFlowFunc;
import com.qa.pages.PreviewPage;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.Assert;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;


public class HomePageTest extends BaseTest {

    HomePage homePage;
    JSONObject meetingDetail;
    TestUtils utils = new TestUtils();
    SoftAssert sa;

    @BeforeClass
    public void beforeClass() throws Exception {
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
    }

    @AfterClass
    public void afterClass() {
    }

    @BeforeMethod
    public void beforeMethod(Method m){
        closeApp();
        launchApp();
        utils.log().info("\n" + "****** starting test:" + m.getName() + "******" + "\n");
        sa = new SoftAssert();
        homePage = new HomePage();
    }

    @AfterMethod
    public void afterMethod() {
      sa.assertAll();
    }


    @Test
    public void Test_HomePage() throws InterruptedException, IOException {
      System.out.println("Verify Meeting url space Visible");
        Thread.sleep(2000);

        sa.assertTrue(homePage.crossBtn.isDisplayed());
        click(homePage.crossBtn);
        String meeting_url_text = getText(homePage.meetingUrlField, "meeting_url_text - ");
        String flag = getStrings().get("empty_meeting_url");
        sa.assertEquals(meeting_url_text, flag);

        sa.assertTrue(homePage.meetingUrlField.isDisplayed());
        homePage.put_meeting_url(meetingDetail.getJSONObject("valid").getString("meeting_url"));
        meeting_url_text = getText(homePage.meetingUrlField, "meeting_url_text - ");
        flag = meetingDetail.getJSONObject("valid").getString("meeting_url");
        sa.assertEquals( meeting_url_text, flag + ", " +getStrings().get("empty_meeting_url"));

        sa.assertTrue(homePage.joinMeetingBtn.isDisplayed());
    }

    @Test
    public void Test_ParticipantName_Popup() throws InterruptedException {
        System.out.println("Verify Name space Visible");
        Thread.sleep(2000);

        homePage = homePage.goto_enterName(meetingDetail.getJSONObject("valid").getString("meeting_url"));

        Thread.sleep(2000);
        sa.assertTrue(homePage.participantNameField.isDisplayed());
        String name_field_text = getText(homePage.participantNameField, "name_field_text - ");
        String flag = getStrings().get("empty_name_space");
        sa.assertEquals(name_field_text, flag);

        homePage.put_participant_name(meetingDetail.getJSONObject("valid").getString("username"));
        name_field_text = getText(homePage.participantNameField, "name_field_text - ");
        flag = meetingDetail.getJSONObject("valid").getString("username");
        sa.assertEquals(name_field_text, getText(homePage.participantNameField, "name_field_text - "));

        sa.assertTrue(homePage.nameOKbtn.isDisplayed());
        sa.assertTrue(homePage.nameCancelbtn.isDisplayed());
    }

}
