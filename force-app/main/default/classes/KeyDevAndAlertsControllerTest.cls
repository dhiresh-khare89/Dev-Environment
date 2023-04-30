@isTest
private class KeyDevAndAlertsControllerTest{

	@testSetup static void setup(){
		
		Lead lead = new lead();
		lead.lastName = 'Test new client last name';
        lead.Company = 'Tata Steel Limited';
		lead.capIQId__c = 'IQ874170';
		insert lead;

		Client_News__c clientNewsObj = new Client_News__c();
		clientNewsObj.New_Client__c = lead.Id;
		clientNewsObj.Name = 'Test news';
		clientNewsObj.IQ_KEY_DEV_HEADLINE__c = 'Test headline';
		insert clientNewsObj;

		
	}

	@isTest static void testMethod1() {
		// code_block
		List<Lead> newClientList = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r ) FROM Lead];
		KeyDevAndAlertsController.getNewClient(newClientList[0].Id, 'Lead');	
	}

	@isTest static void testMethod2() {
		// code_block	
	}
}