package com.eventbee.creditcard;

import com.eventbee.general.StatusObj;
import com.eventbee.authentication.ProfileData;
import java.util.*;
import com.eventbee.general.EbeeConstantsF;
import com.eventbee.general.*;


public class CreditCardModel {

	private String cc_number=null;
	private String cvv_code=null;

	private String ccexp_month=null;
	private String ccexp_year=null;

	private String cardtype=null;

	private String grand_total=null;

	private String counter=null;
	private String currency_code=null;

	private String transactionid=null;
	private String transactiontype=null;
	private String baseref=null;
	private String internalref=null;

	private ProfileData profiledata=null;

	private String INTERNAL_REF=null;
	private String REQUEST_APP=null;

    private String TRANSACTION_TYPE= null;

	private String LOGO_URL=null;
	public String BASE_REF=null;
	private String AUTH_POLICY= null;
	private String AUTH_URL= null;

	private String ON_SUCCESS_RETURN=null;
	private String ON_INVALID_TRANSACTION_RETURN=null;
	private String ON_FAILURE_TRANSACTION_RETURN=null;
	private String softDesc=null;


	public void setParams(HashMap hm){
		this.INTERNAL_REF=(String)hm.get(CardConstants.INTERNAL_REF);
		this.REQUEST_APP=(String)hm.get(CardConstants.REQUEST_APP);

		this.TRANSACTION_TYPE=(String)hm.get(CardConstants.TRANSACTION_TYPE);

		this.grand_total=(String)hm.get(CardConstants.AMOUNT);

		this.BASE_REF=(String)hm.get(CardConstants.BASE_REF);
		this.LOGO_URL=(String)hm.get(CardConstants.LOGO_URL);
		this.AUTH_POLICY=(String)hm.get(CardConstants.AUTH_POLICY);
		this.AUTH_URL=(String)hm.get(CardConstants.AUTH_URL);

		this.ON_SUCCESS_RETURN=(String)hm.get(CardConstants.ON_SUCCESS_RETURN);
		this.ON_INVALID_TRANSACTION_RETURN=(String)hm.get(CardConstants.ON_INVALID_TRANSACTION_RETURN);
		this.ON_FAILURE_TRANSACTION_RETURN=(String)hm.get(CardConstants.ON_FAILURE_TRANSACTION_RETURN);

	}


   public void setCurrencyCode(String currency_code){
   		   this.currency_code=currency_code;
   	}



	public void setCardnumber(String cc_number){
		   this.cc_number=cc_number;
	}

	public void setCvvcode(String cvv_code){
			   this.cvv_code=cvv_code;
	}


	public void setExpmonth(String ccexp_month){
		   this.ccexp_month=ccexp_month;
	}

	public void setExpyear(String ccexp_year){
		   this.ccexp_year=ccexp_year;
	}

	public void setCardtype(String cardtype){
		   this.cardtype=cardtype;
	}

	public void setGrandtotal(String grand_total){
		   	if(grand_total.indexOf(".")==-1){

		   		this.grand_total=grand_total+".00";
			}else{
				this.grand_total=grand_total;
			}
	}

	public void setProfiledata(ProfileData profiledata1){
		//this.profiledata=profiledata1;
		if(profiledata1 !=null){

			if(profiledata==null){
		profiledata=new ProfileData();
		profiledata.setFirstName( profiledata1.getFirstName()   );
		profiledata.setLastName( profiledata1.getLastName()   );

		profiledata.setEmail( profiledata1.getEmail()   );

		profiledata.setCompany( profiledata1.getCompany()   );

		profiledata.setStreet1( profiledata1.getStreet1()   );
		profiledata.setStreet2( profiledata1.getStreet2()   );

		profiledata.setCity( profiledata1.getCity()   );
		profiledata.setState( profiledata1.getState()   );

		profiledata.setCountry( profiledata1.getCountry()   );
		profiledata.setZip( profiledata1.getZip()   );

		profiledata.setPhone( profiledata1.getPhone()   );
			}
		}

	}

	public String getCardnumber(){
		   return cc_number;
	}

	public String getCvvcode(){
			   return cvv_code;
		}


	public String getExpmonth(){
		   return ccexp_month;
	}

	public String getExpyear(){
			return ccexp_year;
	}

	public String getCardtype(){
		return cardtype;
	}

	public String getGrandtotal(){
		return grand_total;
	}

   public String getCurrencyCode(){
	 return currency_code;
   }

	public ProfileData getProfiledata(){
		return profiledata;
	}


	//for recurring payment frequency ,startdate,recurring amount, userid
	public boolean recurringPayment(String userid,int duemonths,String startdate,String amount,String purpose){
		CreditCardInfo cci=null;
		int count = (int) (Math.random() * (100000 - 1));

		counter=""+count;
		if(profiledata!=null){
			cci=new CreditCardInfo(cc_number,ccexp_month,ccexp_year,cardtype,grand_total,currency_code,profiledata,INTERNAL_REF);
		}else{
			cci=new CreditCardInfo(cc_number,ccexp_month,ccexp_year,cardtype,grand_total,currency_code,INTERNAL_REF);
		}

		CCProcessing ccp=new CCProcessing();
		boolean sobj=ccp.processRecurringCard(userid,duemonths,startdate,amount,cci,purpose);
		return sobj;

	}


	public ResponseObj validateCard(String requestapp,String intref){
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CreditCardModel","validateCard()","entered card validate",null);
		CreditCardInfo cci=null;
		int count = (int) (Math.random() * (100000 - 1));

		counter=""+count;
		if(profiledata!=null){
			cci=new CreditCardInfo(cc_number,cvv_code,ccexp_month,ccexp_year,cardtype,grand_total,currency_code,profiledata,INTERNAL_REF);
			cci.setSoftDesc(softDesc);
		}else{
			cci=new CreditCardInfo(cc_number,cvv_code,ccexp_month,ccexp_year,cardtype,grand_total,currency_code,INTERNAL_REF);
			cci.setSoftDesc(softDesc);
		}

		CCProcessing ccp=new CCProcessing();
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CreditCardModel","validateCard()","entering ccProccesing processCard()",null);
		StatusObj sobj=ccp.processCard(cci,counter,requestapp,intref);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CreditCardModel","validateCard()","exit card validate after ccProccesing processCard()",null);
		return (ResponseObj)sobj.getData();

	}

	//used from the calling program for local validation before calling processCreditCard
	public StatusObj localValidate(){
			StatusObj sobj=null;
			Vector v=null;
			CreditCardInfo cci=null;
			if(profiledata!=null){
				if(profiledata.validateProfile()!=null){
					sobj=new StatusObj(true,ON_INVALID_TRANSACTION_RETURN,profiledata.validateProfile());
					//return sobj;
					if(sobj.getStatus())
					v=(Vector)sobj.getData();
				}
			}

			if(profiledata!=null){
				cci=new CreditCardInfo(cc_number,ccexp_month,ccexp_year,cardtype,grand_total,currency_code,profiledata,INTERNAL_REF);
				cci.setSoftDesc(softDesc);
			}else{
				cci=new CreditCardInfo(cc_number,ccexp_month,ccexp_year,cardtype,grand_total,currency_code,INTERNAL_REF);
				cci.setSoftDesc(softDesc);
			}
			CCProcessing ccp=new CCProcessing();

			sobj=ccp.localValidate(cci);
			if(sobj.getStatus()){
				if(v==null)
				v=(Vector)sobj.getData();
				else
				v.addAll(0,(Vector)sobj.getData());
			}
			if(v!=null){
				Vector finalerrVector=new Vector();
				finalerrVector.add(v.get(0));
			sobj=new StatusObj(true,"",finalerrVector);
			}
			return sobj;
	}


	public StatusObj validate(){
		System.out.println("in CreditCardModel validate method");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CreditCardModel","validate()","entered validate",null);
			StatusObj sobj=null;
			if(profiledata!=null){
				if(profiledata.validateProfile()!=null){
					sobj=new StatusObj(true,ON_INVALID_TRANSACTION_RETURN,profiledata.validateProfile());
					return sobj;
				}
			}
			
			System.out.println("ON_FAILURE_TRANSACTION_RETURN: "+ON_FAILURE_TRANSACTION_RETURN);
		    ResponseObj robj=validateCard(REQUEST_APP,INTERNAL_REF);
			if(robj.getStatus()){
					sobj=new StatusObj(false,ON_SUCCESS_RETURN,"");
			}else if("R".equals(robj.getStatus_code())){
					sobj=new StatusObj(true,ON_INVALID_TRANSACTION_RETURN,robj.data);
			}else if("F".equals(robj.getStatus_code())){
					sobj=new StatusObj(true,ON_FAILURE_TRANSACTION_RETURN,"");
			}
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CreditCardModel","validate()","exiting validate",null);
			return sobj;
	}
	


	public String getSoftDesc() {
		return softDesc;
	}


	public void setSoftDesc(String softDesc) {
		this.softDesc = softDesc;
	}
}
