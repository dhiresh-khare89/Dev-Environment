import { LightningElement, wire, api } from 'lwc';

export default class CallSalesforceAppToScannerApp extends LightningElement {
    connectedCallback() {
        //String url = "https://play.google.com/store/apps/details?id=com.sansan.scantosalesforce";
//Intent i = new Intent(Intent.ACTION_VIEW);
//i.setData(Uri.parse(url));
//startActivity(i);
        window.open('https://play.google.com/store/apps/details?id=com.sansan.scantosalesforce');
        //window.open('android.intent.action.com.sansan.scantosalesforce');
    }


}