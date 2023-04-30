public class ScanVisitingCardController {
    public String myValue{ get; set; }
    //myValue=false;
    public ScanVisitingCardController(ApexPages.StandardSetController controller) {
        myValue = checkDeviceTheme();
    }
    
    private static String checkDeviceTheme() {
        String getUiThemeDisplayed = UserInfo.getUiThemeDisplayed();
        System.debug('getUiThemeDisplayed '+getUiThemeDisplayed);
        if(getUiThemeDisplayed.contains('Theme4d')) {
            System.debug('Inside theme4D if');
            return 'true';
        }
        return 'false';
    }
}