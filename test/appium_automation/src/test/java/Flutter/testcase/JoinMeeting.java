package Flutter.testcase;

import Flutter.pageobject.LandingPage;
import Flutter.pageobject.PreviewPage;
import org.testng.annotations.Test;

public class JoinMeeting {

    //@Test
    public void JoinMeetings() throws InterruptedException {
        String meeting_url = "https://ronitroy-xyz.app.100ms.live/meeting/kfg-ahl-lxm";
        String participant_name = "Ronit Roy";
        System.out.println("Just testing the app");
        Thread.sleep(3000);
        LandingPage landingPage = new LandingPage();
        PreviewPage previewPage = new PreviewPage();

        landingPage.meetingUrlField.clear();
        landingPage.put_meeting_url(meeting_url);
        landingPage.click_joinMeetingBtn();
        landingPage.put_participant_name(participant_name);
        landingPage.click_okBtn();
        landingPage.accept_permission();
        landingPage.accept_permission();

        previewPage.click_camBtn();
        previewPage.click_micBtn();
        previewPage.click_joinNowBtn();
    }

    @Test
    public void Test_JoinMeeting() throws InterruptedException {
        JoinMeetings();
    }

}
