package ReactNative.testcase;

import ReactNative.pageobject.LandingPage;
import org.testng.annotations.Test;

public class JoinMeeting {

    @Test
    public void Test_JoinMeeting() throws InterruptedException {
        String meeting_url = "https://ronitroy-xyz.app.100ms.live/meeting/kfg-ahl-lxm";
        System.out.println("Just testing the app");
        Thread.sleep(3000);
        LandingPage landingPage = new LandingPage();

        //landingPage.click_crossBtn();
        landingPage.meetingUrlField.clear();
        landingPage.put_meeting_url(meeting_url);
        landingPage.click_joinMeetingBtn();
    }
}
