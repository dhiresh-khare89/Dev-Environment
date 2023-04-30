public class  mcaFinanceWrapper {

	public class RatAnalysis {
		public Double returnOnEquity;
		public Double netDebtEquity;
		public Double netProfitMargin;
		public Double netOpIncGrowth;
		public String netProfGrowth;
		public Double roce;
		public Double interestCoverage;
		public Double ebitdaMargin;
		public String ebitdaGrowth;
	}

	public Double statusCode;
	public String requestId;
	public Result result;

	public class BalSheet {
		public Double propertyPlantAndEquipment;
		public Double shareCap;
		public Double otherEquity;
		public Double totalEl;
		public Double deffTaxLiab;
		public Double cashAndBank;
		public Double totalBorr;
		public Double totalAssets;
		public Double nonControllingInterest;
		public Double capWip;
		public Double investments;
		public Double otherAssets;
		public Double othersLiab;
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
		public TradeReceivables tradeReceivables;
		public CurrentFinancialSummary currentFinancialSummary;
		public String cdrFlag;
		public FinParamProfitLoss finParamProfitLoss;
		public FinParamBalanceSheet finParamBalanceSheet;
	}

	public class TradeReceivables {
		public WithinSixMonths withinSixMonths;
		public ExceedingSixMonths exceedingSixMonths;
	}

	public class IncomeState {
		public Double shareAssocJointVent;
		public Double deprcnAmort;
		public Double totalTaxExpense;
		public Double totExp;
		public Double exceptionalItemsBeforeTax;
		public Double profLossBefTax;
		public Double otherIncome;
		public String profitLoss;
		public Double finCost;
		public String ebit;
		public Double effTaxRate;
		public String ebitda;
		public String revenueFromOperations;
	}

	public class Result {
		public String consolidated;
		public CompanyInfo companyInfo;
		public List<Standalone> standalone;
	}

	public class WithinSixMonths {
		public Double doubtfulWithSix;
		public Double netTrdRecWithSix;
		public Double debtsDueDirWithSix;
		public Double totTrdRecWithSix;
		public Double securedGoodWithSix;
		public Double unsecuredGoodWithSix;
		public String provisionForBadAndDoubtfulDebtsWithSix;
	}

	public class ExceedingSixMonths {
		public Double netTrdRecExSix;
		public Double provisionForBadAndDoubtfulDebtsExSix;
		public Double debtsDueDirExSix;
		public Double unsecuredGoodExSix;
		public Double doubtfulExSix;
		public Double securedGoodExSix;
		public Double totTrdRecExSix;
	}

	public class FinParamProfitLoss {
		public Double revSubsidies;
		public Double propDiv;
		public Double propDividendPer;
		public Double incomeFor;
		public Double consumptnStores;
		public Double expenFor;
		public Double propDividend;
		public Double grossValueTransn;
		public Double badDebtsRP;
		public Double dilutedEpsPL;
		public Double basicEpsPL;
		public Double rentPaid;
	}

	public class CashFlowStat {
		public String cashAndCashEquivalentsCashFlowStatementAtBeginningOfPeriod;
		public String cashFlowsFromUsedInFinancingActivities;
		public String cashFlowsFromUsedInInvestingActivities;
		public Double freeCashFlow;
		public Double capExpenditure;
		public String cashAndCashEquivalentsCashFlowStatementAtEndOfPeriod;
		public String increaseDecreaseInCashAndCashEquivalents;
		public String cashFlowsFromUsedInOperatingActivities;
	}

	public class Standalone {
		public Data data;
		public Metadata metadata;
	}

	public class CurrentFinancialSummary {
		public BalSheet balSheet;
		public CashFlowStat cashFlowStat;
		public RatAnalysis ratAnalysis;
		public IncomeState incomeState;
	}

	public class CompanyInfo {
		public String entityEmailId;
		public String entityId;
		public String regAddOfEntity;
		public String registrationDateOfCompany;
		public String entityName;
	}

	public class FinParamBalanceSheet {
		public Double amountIssueAll;
		public Double conversionWrDe;
		public Double commercialPaper;
		public String rbOperatingLea;
		public Double miscExpenditure;
		public Double amtDueTransfer;
		public Double grossValue;
		public Double interCorpBorr1;
		public String goodwillConsl;
		public Double defaultPayment1;
		public Double securedLoan;
		public Double borrowingFia;
		public Double debenturesClaim;
		public Double warrantsIssued;
		public Double forfeitedShares;
		public Double interestDeposit;
		public Double paidUpCaptFc1Percent;
		public Double numShareHoldrs;
		public Double depMaturedCla1;
		public Double depMaturedCla2;
		public Double defaultPayment;
		public Double shareAppMoney3;
		public Double netWorth;
		public Double conversionWrPs;
		public Double interCorporate;
		public Double unpaidDividend;
		public Double capitalReserves;
		public Double depreciatnAmort;
		public Double paidUpCaptFcPercent;
		public Double paidUpCaptFc1;
		public String investmentJoint;
		public Double borrowingFc;
		public Double conversionWrEs;
		public Double numSharesBb;
		public Double investmentSubsd;
		public Double paidUpCaptFc;
		public Double investmentGovt;
		public Double shareAppMoney;
		public Double warrantsIssued1;
		public String investmentAssoc;
		public Double forfeitedSharR;
		public Double callsUnpaidDir;
		public Double depMaturedClai;
		public Double shareAppMoney1;
		public Double shareAppMoney2;
		public Double grossFixdAsset;
		public Double interCorpBorr;
		public Double unclaimedMDeb;
		public Double callsUnpaidOth;
		public Double depAcceptedRen;
		public Double unhedgedFeExp;
		public Double capitalSubsdies;
	}

	
	public static  mcaFinanceWrapper parse(String json) {
		return (mcaFinanceWrapper) System.JSON.deserialize(json, mcaFinanceWrapper.class);
	}
}