public class mcaMCASchedulesWrapper {

	public class SchNoncurrentInvestment {
		public Integer investmentINR;
		public String nameOfBodyCorporateInWhomInvestmentHasMade;
	}

	public Integer statusCode;
	public String requestId;
	public Result result;

	public class Metadata {
		public String financialEndDate;
		public String docId;
		public String attachmentLink;
		public String financialStartDate;
		public String documentName;
		public String financialYear;
		public String lastUpdated;
		public String formId;
		public String dateOfFiling;
		public String docLink;
		public String excelLink;
		public String entityId;
		public String type;
	}

	public class SchPropertyPlantAndEquipment {
		public Long totalIncreaseDecreaseInPropertyPlantEquipment;
		public Long propertyPlantAndEquipmentAtEndOfPeriod;
		public Long additionsAndAcquisitions;
		public String totalIncreaseDecreaseThroughTransfersAndOtherChanges;
		public Integer disposalsAndRetirementsPropertyPlantAndEquipment;
		public Long propertyPlantAndEquipmentAtBeginningOfPeriod;
		public Long depreciationPropertyPlantAndEquipment;
	}

	public class Data {
		public List<SchNoncurrentInvestment> schNoncurrentInvestment;
		public SchChangesInEquity schChangesInEquity;
		public ShareholdingPattern shareholdingPattern;
		public List<SchNoncurrentInvestment> schCurrentInvestment;
		public SchRelatedParties schRelatedParties;
		public SchEquityShareCapital schEquityShareCapital;
		public SchPropertyPlantAndEquipment schPropertyPlantAndEquipment;
	}

	public class ShareholdingPattern {
		public List<ShareholdingOfDirectorsKMP> shareholdingOfDirectorsKMP;
		public List<ShareholdingOfDirectorsKMP> promotersShareholding;
		public List<ShareholdingOfDirectorsKMP> shareholdersHoldingMoreThanFivePercent;
		public List<ShareholdingOfDirectorsKMP> sharesHeldByHoldingCompany;
		public List<ShareholdingOfDirectorsKMP> topTenShareholding;
	}

	public class JointControlOrSignificantInfluenceMember {
		public String transfersOfLoanUnderFinanceAgreementsFromEntityRelatedPartyTransactions;
		public String revenueFromRenderingOfServicesRelatedPartyTransactions;
		public String transfersOfLoanUnderFinanceAgreementsToEntityRelatedPartyTransactions;
		public String otherRelatedPartyTransactionsContributionReceived;
		public String purchasesOfGoodsRelatedPartyTransacations;
		public String leasesAsLessorRelatedPartyTransactions;
		public Integer otherRelatedPartyTransactionsExpense;
		public String countryOfIncorporationOrResidenceOfRelatedParty;
		public String servicesReceivedRelatedPartyTransactions;
		public String otherRelatedPartyTransactionsContributionMade;
		public String amountsReceivableRelatedPartyTransactions;
		public String identificationNumberOfForeginRelatedPartyInCountryOfIncorporationOrResidence;
		public String transfersUnderLicenseAgreementsFromEntityRelatedPartyTransactions;
		public String leasesAsLesseeRelatedPartyTransactions;
		public String salesOfTangibleAssetsRelatedPartyTransactions;
		public String otherRelatedPartyTransactionsIncome;
		public String amountsPayableRelatedPartyTransactions;
		public String descriptionOfNatureOfTransactionsWithRelatedParty;
		public String nameOfRelatedParty;
		public String transfersUnderLicenseAgreementsToEntityRelatedPartyTransactions;
		public String cinOfRelatedParty;
		public String provisionsForDoubtfulDebtsRelatedToOutstandingBalancesOfRelatedPartyTransaction;
		public String purchasesOfTangibleAssetsRelatedPartyTransactions;
		public String transfersOfResearchAndDevelopmentToEntityRelatedPartyTransactions;
		public String provisionOfGuaranteesOrCollateralByEntityRelatedPartyTransactions;
		public String revenueFromSaleOfGoodsRelatedPartyTransactions;
		public String transfersOfResearchAndDevelopmentFromEntityRelatedPartyTransactions;
		public String descriptionOfNatureOfRelatedPartyRelationship;
		public String provisionOfGuaranteesOrCollateralToEntityRelatedPartyTransactions;
	}

	public class Result {
		public CompanyInfo companyInfo;
		public List<Standalone> standalone;
	}

	public class ShareholdingOfDirectorsKMP {
		public Double percentageOfSharesHeld;
		public Integer numberOfSharesHeld;
		public String nameOfShareholder;
	}

	public class SchRelatedParties {
		public List<JointControlOrSignificantInfluenceMember> jointControlOrSignificantInfluenceMember;
		public List<JointControlOrSignificantInfluenceMember> relatedPartiesMember;
		public List<JointControlOrSignificantInfluenceMember> associatesMember;
		public List<JointControlOrSignificantInfluenceMember> otherRelatedPartiesMember;
		public List<JointControlOrSignificantInfluenceMember> keyManagementPersonnelOfEntityOrParentMember;
		public List<JointControlOrSignificantInfluenceMember> parentMember;
		public List<JointControlOrSignificantInfluenceMember> subsidiariesMember;
	}

	public class SchEquityShareCapital {
		public Long valueOfSharesIssued;
		public String sharesInCompanyHeldByAssociatesOfItsHoldingCompany;
		public Long totalIncreaseDecreaseinShareCapital;
		public String sharesInCompanyHeldByHoldingCompany;
		public String sharesInCompanyHeldBySubsidiariesOfItsHoldingCompany;
		public Long capitalAtBeginningOfPeriod;
		public String sharesInCompanyHeldByAssociatesOfItsUltimateHolding;
		public String sharesInCompanyHeldByUltimateHoldingCompany;
		public Long valueOfSharesAuthorised;
		public String totalSharesInCompanyHeldByHoldingCompanyOrUltimate;
		public Long capitalAtTheEndOfPeriod;
		public Long valueOfSharesSubscribedAndFullyPaid;
		public String sharesInCompanyHeldBySubsidiariesOfItsUltimateHolding;
	}

	public class SchChangesInEquity {
		public Long profitLossForPeriod;
		public Long totalIncreaseDecreaseInEquity;
		public Long appropriationsForDividendDividendTaxAndGeneralReserve;
		public Integer deductionToReserves;
		public String otherAdjustment;
		public Long balanceAtEndOfPeriod;
		public Long totalComprehensiveIncome;
		public Long balanceAtBeginningOfPeriod;
	}

	public class Standalone {
		public Data data;
		public Metadata metadata;
	}

	public class CompanyInfo {
		public String entityEmailId;
		public String entityId;
		public String regAddOfEntity;
		public String registrationDateOfCompany;
		public String entityName;
	}

	
	public static mcaMCASchedulesWrapper parse(String json) {
		return (mcaMCASchedulesWrapper) System.JSON.deserialize(json, mcaMCASchedulesWrapper.class);
	}
}