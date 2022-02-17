package Flutter.testcase.MeetingRoomTest.MenuDropDownTest;

import Flutter.pageobject.MeetingRoomPage.MenuDropDown.ChangeName;
import Flutter.pageobject.MeetingRoomPage.MenuDropDown.MuteAll;
import Flutter.pageobject.MeetingRoomPage.Tile;
import Flutter.pageobject.MeetingRoomPage.TopToolBar;
import Flutter.pageobject.PageFlowFunc;
import org.testng.Assert;
import org.testng.annotations.Test;

public class ChangeNameTest {

    @Test
    public void Test_ChangeName() throws InterruptedException {
        System.out.println("Verify mute all");
        Thread.sleep(2000);
        PageFlowFunc pageFlow = new PageFlowFunc();
        ChangeName changeName = new ChangeName();
        TopToolBar topToolBar = new TopToolBar();
        Tile tile = new Tile();

        pageFlow.goto_meetingRoom_menuDropDown();
        Assert.assertTrue(changeName.changeNameBtn.isDisplayed());
        changeName.click_changeNameBtn();
        Assert.assertTrue(changeName.changeNamePopup.isDisplayed());

        Assert.assertTrue(changeName.changeNameCancelBtn.isDisplayed());
        changeName.click_changeNameCancelBtn();

        Assert.assertTrue(tile.myTile.isDisplayed());
        String name_flag = tile.myTile.getAttribute("content-desc");
        String name_text = "Ronit Roy (You)";
        Assert.assertEquals(name_flag, name_text );

        topToolBar.click_menuBtn();
        changeName.click_changeNameBtn();

        Assert.assertTrue(changeName.changeNameField.isDisplayed());
        String new_name = "Ronit New Name";
        changeName.put_change_name(new_name);

        Assert.assertTrue(changeName.changeNameOkBtn.isDisplayed());
        changeName.click_changeNameOkBtn();

        Assert.assertTrue(tile.myTile_nameChange.isDisplayed());
        name_flag = tile.myTile_nameChange.getAttribute("content-desc");
        name_text = "Ronit New Name (You)";
        Assert.assertEquals(name_flag, name_text);

        Assert.assertTrue(changeName.nameChange_Notification.isDisplayed());
        name_flag = changeName.nameChange_Notification.getAttribute("content-desc");
        name_text = "Name Changed to Ronit New Name";
        Assert.assertEquals(name_flag, name_text);

        pageFlow.leave_room();
    }

}
