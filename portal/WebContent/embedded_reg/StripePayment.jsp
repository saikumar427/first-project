<%@page import="com.stripe.model.Charge"%>
<%@page import="com.stripe.Stripe,com.stripe.exception.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@page import="com.eventbee.general.DbUtil,com.eventbee.general.DateUtil,com.eventbee.general.formatting.CurrencyFormat"%>  
<%@page import="com.eventbee.creditcard.CreditCardModel,com.eventbee.general.DBManager,com.eventbee.general.StatusObj,com.eventbee.general.EbeeConstantsF"%> 
 
<%!
public class StripeGateWayProcessPayment{
	String striperesponse="";
public HashMap<String,String> processStripePayment(CreditCardModel ccm,HttpServletRequest request,String token){
	 String cardnumber=null,expmonth=null,expyear=null,cvvcode=null,cardtype=null,name=null,address1=null,address2=null,city=null,zipcode=null,state=null,country=null;
	 String fname="",lname="";
	 HashMap<String,String> resultMap=new HashMap<String,String>(); 
	 Map<String, Object> chargeParams = new HashMap<String, Object>();
	 Map<String, Object> cardParams = new HashMap<String, Object>();
	 String eid=request.getParameter("eid");
	 String tid=request.getParameter("tid");
	 String apirrkey="";
	 System.out.println("Stripe process:::"+eid+" tid::"+tid);
	 try{
	 if(!"".equals(ccm.getCardnumber()))cardnumber=ccm.getCardnumber()+"";
	 if(!"".equals(ccm.getExpmonth()))expmonth=ccm.getExpmonth()+"";
	 if(!"".equals(ccm.getExpyear()))expyear=ccm.getExpyear()+"";
	 if(!"".equals(ccm.getCvvcode()))cvvcode=ccm.getCvvcode()+"";
	 if(!"".equals(ccm.getCardtype()))cardtype=ccm.getCardtype()+"";
	 if(!"".equals(ccm.getProfiledata().getFirstName()))fname=ccm.getProfiledata().getFirstName()+"";
	 if(!"".equals(ccm.getProfiledata().getLastName()))lname=ccm.getProfiledata().getLastName()+"";
	 name=fname+" "+lname;
	 if(!"".equals(ccm.getProfiledata().getStreet1()))address1=ccm.getProfiledata().getStreet1()+"";
	 if(!"".equals(ccm.getProfiledata().getStreet2()))address2=ccm.getProfiledata().getStreet2()+"";
	 if(!"".equals(ccm.getProfiledata().getCity()))city=ccm.getProfiledata().getCity()+"";
	 if(!"".equals(ccm.getProfiledata().getZip()))zipcode=ccm.getProfiledata().getZip()+"";
	 if(!"".equals(ccm.getProfiledata().getState()))state=ccm.getProfiledata().getState()+"";
	 if(!"".equals(ccm.getProfiledata().getCountry()))country=ccm.getProfiledata().getCountry()+"";
	 apirrkey=getManagerAPIKey(eid);
	 Stripe.apiKey=apirrkey.trim();	
     String amt=CurrencyFormat.getCurrencyFormat("",Double.parseDouble(ccm.getGrandtotal())*100+"",false);	 
     amt=amt.substring(0,amt.indexOf("."));
	 chargeParams.put("amount",amt);
     chargeParams.put("currency",ccm.getCurrencyCode());
	 cardParams.put("number", cardnumber);
	 cardParams.put("exp_month",expmonth);
	 cardParams.put("exp_year",expyear);
     cardParams.put("cvc",cvvcode);
     cardParams.put("cardtype",cardtype);
     cardParams.put("name",name);
     cardParams.put("address_line1",address1);
     cardParams.put("address_line2",address2);
     cardParams.put("address_city",city);
     cardParams.put("address_zip",zipcode);
     cardParams.put("address_state",state);
     cardParams.put("address_country",country);
     chargeParams.put("card", cardParams);
     chargeParams.put("description", "Charge for Eventbee Transaction");
     if("charge".equals(token)){
     System.out.println("before charge object creates:"+eid+" :: "+tid);
	 Charge result=Charge.create(chargeParams);
     striperesponse=result.toString();
     resultMap=PrepareResultMap(result);
	 }else if("refund".equals(token)){
    	  HashMap<String,String> chargedetailsmap=new HashMap<String,String>();
		  String chrageid="",amount="";
		  chargedetailsmap=getChargeDetails(tid);
		  if(chargedetailsmap.size()>0){
			  chrageid=chargedetailsmap.get("chargeid");
			  amount=chargedetailsmap.get("amount");
		  }
		  amount=CurrencyFormat.getCurrencyFormat("",amount,true);
		  Charge result=Charge.retrieve(chrageid);
    	  Map<String, Object> refundParams = new HashMap<String, Object>();
    	  refundParams.put("amount",amount);
    	  result=result.refund(refundParams);
    	  striperesponse=result.toString();
    	  resultMap=PrepareResultMap(result); 
    	
     }
     }catch (CardException e) {
      // Since it's a decline, CardException will be caught
      String message="";
      System.out.println("CardException occured : tid: "+tid+" Error:: "+e.getMessage());
      if("incorrect_number".equals(e.getCode()))
    	  message="The card number is incorrect";
      else if("invalid_number".equals(e.getCode()))
    	  message="The card number is not a valid credit card number";
      else if("invalid_expiry_month".equals(e.getCode()))
    	  message="The card's expiration month is invalid";
      else if("invalid_expiry_year".equals(e.getCode()))
    	  message="The card's expiration year is invalid";
      else if("invalid_cvc".equals(e.getCode()))
    	  message="The card's security code is invalid";
      else if("expired_card".equals(e.getCode()))
    	  message="The card has expired";
      else if("incorrect_cvc".equals(e.getCode()))
    	  message="The card's security code is incorrect";
      else if("incorrect_zip".equals(e.getCode()))
    	  message="The card's zip code failed validation";
      else if("card_declined".equals(e.getCode())) 
    	  message="The card was declined";
      else if("missing".equals(e.getCode()))
    	  message="There is no card on a customer that is being charged";
      else if("processing_error".equals(e.getCode()))
    	  message="An error occurred while processing the card";
      resultMap.put("failuremessage", message);
      striperesponse+=message;
     }catch (InvalidRequestException e) {
       // Invalid parameters were supplied to Stripe's API
       striperesponse+=e.getMessage();
      System.out.println("InvalidRequestException occured : tid: "+tid+" Error:: "+e.getMessage()); 
      if("currency".equalsIgnoreCase(e.getParam()))
    	  resultMap.put("failuremessage", "Invalid currency");
      else	  
       resultMap.put("failuremessage", e.getParam());  
      
     }catch (AuthenticationException e) {
      // Authentication with Stripe's API failed
      // (maybe you changed API keys recently)
      	striperesponse+=e.getMessage();
    	System.out.println("AuthenticationException occured : tid: "+tid+" Error:: "+e.getMessage());
     }catch (APIConnectionException e) {
       // Network communication with Stripe failed
       	striperesponse+=e.getMessage();
    	System.out.println("APIConnectionException occured : tid: "+tid+" Error:: "+e.getMessage());
     }catch (StripeException e) {
       // Display a very generic error to the user, and maybe send
      // yourself an email
      	striperesponse+=e.getMessage();
    	System.out.println("StripeException occured : tid: "+tid+" Error:: "+e.getMessage());
     }catch (Exception e) {
      // Something else happened, completely unrelated to Stripe
      	striperesponse+=e.getMessage();
    	System.out.println("Exception occured : tid: "+tid+" Error:: "+e.getMessage());
    	resultMap.put("failuremessage", e.getMessage());  
     }
	 String accountstatus="false";
	 String senv=EbeeConstantsF.get("BRAINTREE_ENVIRONMENT","sandbox");
	 System.out.println("stripe environment:"+senv+" "+tid+"::"+eid);
	 if(!"sandbox".equalsIgnoreCase(senv))accountstatus="true";
	 
  if(!"".equals(resultMap.get("id")) && resultMap.get("id")!=null && accountstatus.equalsIgnoreCase(resultMap.get("livemode")) && "true".equalsIgnoreCase(resultMap.get("paidstatus"))){
	  resultMap.put("status","Success");
  }else{
	 resultMap.put("status","failure");
  }
  System.out.println("livemode from map is:"+resultMap.get("livemode")+" "+tid+"::"+eid);
  if(resultMap.get("failuremessage")==null && !accountstatus.equalsIgnoreCase(resultMap.get("livemode")))
	  resultMap.put("failuremessage", "This transaction can not be processed at this time, please try back later");
  System.out.println("failure msg is:"+resultMap.get("failuremessage")+" "+tid+"::"+eid);
  if("charge".equals(token)){
  if(!"".equals(resultMap.get("cardnumber")) && resultMap.get("cardnumber")!=null)
	  cardParams.put("number",resultMap.get("cardnumber"));
  else{
	  try{
	  String creditcardnumber="";
	  HashMap hmap=(HashMap)chargeParams.get("card");
	  creditcardnumber=hmap.get("number")+"";
	  if(!"".equals(creditcardnumber) && creditcardnumber!=null)
		  creditcardnumber=creditcardnumber.substring(creditcardnumber.length()-4, creditcardnumber.length());
	  cardParams.put("number",creditcardnumber);
    }catch(Exception e){
    	System.out.println("Exception occured while getting cardnumber from chargeParams: tid: "+tid+" Error:: "+e.getMessage());
    }
  }
  chargeParams.put("card",cardParams);
  insertStripePaymentData(eid,tid,chargeParams,striperesponse,resultMap,apirrkey);
  insertCardTransactionData(eid,tid,chargeParams,resultMap);
  }
  return resultMap;
}

public HashMap<String,String> PrepareResultMap(Charge result){
	HashMap<String,String> resultMap=new HashMap<String,String>(); 
	 try{
		 if(result.getLivemode()!=null) resultMap.put("livemode",result.getLivemode()+"");
		 if(result.getId()!=null) resultMap.put("id",result.getId());
		 if(result.getPaid()!=null) resultMap.put("paidstatus",result.getPaid()+"");
		 if(result.getAmount()!=null) resultMap.put("amount",result.getAmount()+"");
		 if(result.getCurrency()!=null) resultMap.put("currency",result.getCurrency());
		 if(result.getCustomer()!=null) resultMap.put("customer",result.getCustomer());
		 if(result.getDescription()!=null) resultMap.put("description",result.getDescription());
		 if(result.getCreated()!=null) resultMap.put("created",result.getCreated()+"");
		 if(result.getCaptured()!=null) resultMap.put("capturestatus",result.getCaptured()+"");
		 if(result.getRefunded()!=null) resultMap.put("refundstatus",result.getRefunded()+"");
		 if(result.getAmountRefunded()!=null) resultMap.put("refundamount",result.getAmountRefunded()+"");
	     if(result.getCard()!=null){
			 resultMap.put("cardnumber",result.getCard().getLast4());
		     resultMap.put("cardholdername",result.getCard().getName());
		     resultMap.put("cardtype",result.getCard().getType());
		     resultMap.put("cardholdername",result.getCard().getName());
		     resultMap.put("cvvcheckstatus",result.getCard().getCvcCheck());
		     resultMap.put("expmonth",result.getCard().getExpMonth()+"");
		     resultMap.put("expyear",result.getCard().getExpYear()+"");
		     resultMap.put("city",result.getCard().getAddressCity());
		     resultMap.put("country",result.getCard().getCountry());
		     resultMap.put("countryaddress",result.getCard().getAddressCountry());
		     resultMap.put("address1",result.getCard().getAddressLine1());
		     resultMap.put("address2",result.getCard().getAddressLine2());
		     resultMap.put("address1checkstatus",result.getCard().getAddressLine1Check());
		     resultMap.put("state",result.getCard().getAddressState());
		     resultMap.put("zipcode",result.getCard().getAddressZip());
		     resultMap.put("zipcheckstatus",result.getCard().getAddressZipCheck());
	     }
     }catch(Exception e){
		 System.out.println("Exception occured at PrepareResultMap"+e.getMessage());
	 }
     return resultMap;
}

public String getManagerAPIKey(String eventid){
	String apikey="";
	try{
	apikey=DbUtil.getVal("select attrib_2 from payment_types where refid=? and attrib_5=?",new String[]{eventid,"stripe"});
	if(apikey==null)apikey="";
	}catch(Exception e){System.out.println("Exception occured in getManagerAPIKey for event::"+eventid);}
	return apikey;
}

public HashMap<String,String> getChargeDetails(String tid){
	HashMap<String,String> chargemap=new HashMap<String,String>();
	DBManager dbm=new DBManager();
	StatusObj statobj=null;
	try{
	statobj=dbm.executeSelectQuery("select amount,response_id from cardtransaction where internal_ref=?", new String[]{tid});
	if(statobj.getStatus() && statobj.getCount()>0){
		chargemap.put("amount",dbm.getValue(0,"amount","0"));
		chargemap.put("chargeid",dbm.getValue(0,"response_id",""));
	}
	}catch(Exception e){System.out.println("Exception occured in getChargeDetails for transaction::"+tid);}
	return chargemap;
}

public void insertStripePaymentData(String eventid,String tid,Map<String,Object> inputdatamap,String striperesponse,HashMap<String,String> resultMap,String apikey){
	try{
	String query="insert into stripe_payment_data(refid,tid,data_sent,data_response,mgr_api_key,date,status) values(CAST(? as BIGINT),?,?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?)";
	DbUtil.executeUpdateQuery(query, new String[]{eventid,tid,inputdatamap.toString(),striperesponse,apikey,DateUtil.getCurrDBFormatDate(),resultMap.get("status")});
	}catch(Exception e){
		System.out.println("Exception occured in insertStripePaymentData : eventid: "+eventid+" tid: "+tid+" "+e.getMessage());
	}
}

public void insertCardTransactionData(String eventid,String tid,Map<String,Object> inputdatamap,HashMap<String,String> resultMap){
	String resquery="insert into cardtransaction( "
		    +" transactionid,process_vendor,transaction_date,app_name,internal_ref,cardtype,cardmm,cardyy,cardnum,amount,proces_status,transaction_type,response_id,response_status) "
			    +" values (CAST(? as INTEGER),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,CAST(? as INTEGER),CAST(? as INTEGER),?,CAST(? as FLOAT),?,?,?,?)";
    String TRANSACTION_ID_GET="select nextval('seq_cardtransaction_id') as transactionid";
    String CreditCardNumber=(String)inputdatamap.get("number");
    if(CreditCardNumber!=null)
      CreditCardNumber=CreditCardNumber.subSequence(CreditCardNumber.length()-4,CreditCardNumber.length())+"";
    String cardtranid="",amount="0",cardtype="",expmonth="0",expyear="0",status="",id="";
    try{
    	if(resultMap.get("amount")!=null && !"".equals(resultMap.get("amount"))){
	    	amount=Double.toString(Double.parseDouble(resultMap.get("amount"))/100);
	    	amount=CurrencyFormat.getCurrencyFormat("",amount,true);
    	}
    	if(resultMap.get("cardtype")!=null) cardtype=resultMap.get("cardtype");
    	if(resultMap.get("expmonth")!=null) expmonth=resultMap.get("expmonth");
    	if(resultMap.get("expyear")!=null) expyear=resultMap.get("expyear");
    	if(resultMap.get("status")!=null) status=resultMap.get("status");
    	if(resultMap.get("id")!=null) id=resultMap.get("id");
    	
    	cardtranid=DbUtil.getVal(TRANSACTION_ID_GET,null);
    	DbUtil.executeUpdateQuery(resquery, new String[]{cardtranid,"STRIPE - DIRECT",DateUtil.getCurrDBFormatDate(),"EVENT_REGISTRATION",
    			tid,cardtype,expmonth,expyear,CreditCardNumber,amount,status,"AD",id,status});
    	
    }catch(Exception e){
    	System.out.println("Exception occured in insertCardTransactionData : eventid: "+eventid+" tid: "+tid+" "+e.getMessage());
    }
}

}
%>

