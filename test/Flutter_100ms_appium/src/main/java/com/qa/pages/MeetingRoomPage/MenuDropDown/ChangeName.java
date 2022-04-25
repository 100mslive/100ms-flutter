package com.qa.pages.MeetingRoomPage.MenuDropDown;

import com.qa.pages.MeetingRoomPage.MeetingRoom;
import io.appium.java_client.MobileElement;
import io.appium.java_client.pagefactory.AndroidFindBy;
import io.appium.java_client.pagefactory.iOSXCUITFindBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;

public class ChangeName extends MeetingRoom {

    @iOSXCUITFindBy(accessibility = "Change Name")
    @AndroidFindBy(accessibility = "Change Name")
    public MobileElement changeNameBtn;

    @iOSXCUITFindBy(accessibility = "Change Name")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View")
    public MobileElement changeNamePopup;

    @iOSXCUITFindBy(accessibility = "Change Name")
    @AndroidFindBy(xpath = "/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View/android.widget.EditText")
    public MobileElement changeNameField;

    @iOSXCUITFindBy(accessibility = "OK")
    @AndroidFindBy(accessibility = "OK")
    public MobileElement changeNameOkBtn;

    @iOSXCUITFindBy(accessibility = "Cancel")
    @AndroidFindBy(accessibility = "Cancel")
    public MobileElement changeNameCancelBtn;


    @iOSXCUITFindBy(accessibility = "Back")
    @AndroidFindBy(accessibility =  "Name Changed to Ronit New Name" )
    public static MobileElement nameChange_Notification;


    public ChangeName put_change_name(String new_name){
        clear(changeNameField);
        sendKeys(changeNameField, new_name, "Change name to- " + new_name);
        return this;
    }
}
