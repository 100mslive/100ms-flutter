package com.qa.tests.MeetingRoomTest.MenuDropDownTest;


import com.qa.BaseTest;
import com.qa.pages.MeetingRoomPage.BottomToolBar.LeaveRoom;
import com.qa.pages.MeetingRoomPage.MenuDropDown.ChangeName;
import com.qa.pages.MeetingRoomPage.Tile;
import com.qa.pages.MeetingRoomPage.TopToolBar;
import com.qa.utils.TestUtils;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.testng.annotations.*;
import org.testng.asserts.SoftAssert;

import java.io.InputStream;
import java.lang.reflect.Method;

public class ChangeNameTest extends BaseTest {

    TopToolBar topToolBar;
    ChangeName changeName;
    Tile tile;
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
    public void beforeMethod(Method m) throws InterruptedException {
        closeApp();
        launchApp();
        utils.log().info("\n" + "****** starting test:" + m.getName() + "******" + "\n");
        sa = new SoftAssert();
        topToolBar = new TopToolBar();
        changeName = new ChangeName();
        tile = new Tile();
    }

    @AfterMethod
    public void afterMethod() throws InterruptedException {
        sa.assertAll();
        LeaveRoom leaveRoom = new LeaveRoom();
        leaveRoom.leave_withoutEndingRoom();
    }

    //@Test
    public void Test_ChangeName() throws InterruptedException {
        System.out.println("Verify Change Name");
        Thread.sleep(2000);

        topToolBar = topToolBar.goto_meetingRoom_menuPage(meetingDetail.getJSONObject("valid").getString("meeting_url"),
                meetingDetail.getJSONObject("valid").getString("username"),
                meetingDetail.getJSONObject("camera").getString("ON"),
                meetingDetail.getJSONObject("mic").getString("ON"));

        sa.assertTrue(changeName.changeNameBtn.isDisplayed());
        click(changeName.changeNameBtn);
        sa.assertTrue(changeName.changeNamePopup.isDisplayed());

        sa.assertTrue(changeName.changeNameCancelBtn.isDisplayed());
        click(changeName.changeNameCancelBtn);

        sa.assertTrue(tile.myTile.isDisplayed());

        String name_flag = getContextDesc(tile.myTile, "Name on Tile- ");
        String name_text = meetingDetail.getJSONObject("valid").getString("username") + getStrings().get("tile_name_(You)");
        sa.assertEquals(name_flag, name_text );

        click(topToolBar.menuBtn);
        click(changeName.changeNameBtn);

        sa.assertTrue(changeName.changeNameField.isDisplayed());
        changeName.put_change_name(meetingDetail.getJSONObject("valid").getString("new_username"));

        sa.assertTrue(changeName.changeNameOkBtn.isDisplayed());
        click(changeName.changeNameOkBtn);

        sa.assertTrue(tile.myTile_nameChange.isDisplayed());
        name_flag = getContextDesc(tile.myTile_nameChange, "New Name on Tile- ");
        name_text = meetingDetail.getJSONObject("valid").getString("new_username") + getStrings().get("tile_name_(You)");
        sa.assertEquals(name_flag, name_text);

        sa.assertTrue(changeName.nameChange_Notification.isDisplayed());
        name_flag = getContextDesc(changeName.nameChange_Notification, "New Name Notification- ");
        name_text = getStrings().get("name_changed_to") + meetingDetail.getJSONObject("valid").getString("new_username");
        sa.assertEquals(name_flag, name_text);
    }

}
