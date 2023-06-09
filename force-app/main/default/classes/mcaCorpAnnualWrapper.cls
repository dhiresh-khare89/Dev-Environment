public class mcaCorpAnnualWrapper  {

	public class ListOfForeignInvestors {
		public String name;
		public String dateOfIncorporation;
		public Integer numberOfSharesheld;
		public String countryOfIncorporation;
		public String address;
		public Double percentageOfSharesHeld;
	}

	public Integer statusCode;
	public String requestId;
	public Result result;

	public class BusinessActivitiesList {
		public Integer percentageOfTurnoverOfTheCompany;
		public String descriptionOfMainActivityGroup;
		public String businessActivityCode;
		public Integer sNo;
		public String descriptionOfBusinessActivity;
		public String mainActivityGroupCode;
	}

	public class AnnualReturn {
		public Data data;
		public Metadata metadata;
	}

	public class SubsidiariesList {
		public Integer percentageOfSharesHeld;
		public Integer sNo;
		public String cinFcrn;
		public String namecompany;
		public String holdingSubsidiaryAssociateJointVenture;
	}

	public class Metadata {
		public String docId;
		public String attachmentLink;
		public String excelLink;
		public String documentName;
		public String financialYear;
		public String lastUpdated;
		public String formId;
		public String dateOfFiling;
		public String docLink;
		public String entityId;
		public String type;
	}

	public class Data {
		public List<SubsidiariesList> subsidiariesList;
		public List<BusinessActivitiesList> businessActivitiesList;
		public List<ListOfForeignInvestors> listOfForeignInvestors;
	}

	public class CompanyInfo {
		public String entityEmailId;
		public String entityId;
		public String regAddOfEntity;
		public String registrationDateOfCompany;
		public String entityName;
	}

	public class Result {
		public CompanyInfo companyInfo;
		public List<AnnualReturn> annualReturn;
	}

	
	public static mcaCorpAnnualWrapper  parse(String json) {
		return (mcaCorpAnnualWrapper ) System.JSON.deserialize(json, mcaCorpAnnualWrapper.class);
	}
}