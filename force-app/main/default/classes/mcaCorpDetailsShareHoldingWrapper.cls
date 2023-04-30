public class mcaCorpDetailsShareHoldingWrapper {

	public String requestId;
	public Result result;
	public Integer statusCode;

	public class Metadata {
		public String source;
		public String documentName;
		public String dateOfFiling;
		public String finYearStartDate;
		public String finYearEndDate;
		public String docId;
	}

	public class ShareHolders {
		public String din;
		public String pan;
		public String name;
		public Integer percentageOfHoldingByShares;
		public Integer numberOfEquitySharesHeld;
		public Metadata metadata;
		public String address;
		public String cin;
		public String percentageOfHoldingByVotes;
	}

	public class Result {
		public List<ShareHolders> shareHolders;
		public String companyName;
		public String entityId;
		public String lastDownloaded;
	}

	
	public static mcaCorpDetailsShareHoldingWrapper parse(String json) {
		return (mcaCorpDetailsShareHoldingWrapper) System.JSON.deserialize(json, mcaCorpDetailsShareHoldingWrapper.class);
	}
}