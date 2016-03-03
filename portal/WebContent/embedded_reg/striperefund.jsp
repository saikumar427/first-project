<%@page import="com.stripe.model.Charge"%>
<%@page import="com.stripe.Stripe,com.stripe.exception.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.eventbee.general.DbUtil,com.eventbee.general.formatting.CurrencyFormat"%>  
<%@page import="com.eventbee.general.DBManager,com.eventbee.general.StatusObj,com.eventbee.general.EbeeConstantsF"%> 
<%!
   public HashMap<String,String> refundStripePayment(String tid,String amount,String eid,String payment_type){
     System.out.println("IN refundStripePayment Method: "+tid+" :: "+eid);
     HashMap<String,String> resultMap=new HashMap<String,String>();
     String originalamt=amount;
     Charge result=null;
     String chargeId="";
     String failuremessage="";
     try{
      String apirrkey=""; 
      try{
      amount=CurrencyFormat.getCurrencyFormat("",Double.parseDouble(amount)*100+"",false);
      amount=amount.substring(0,amount.indexOf("."));
      }catch(Exception e){
    	System.out.println("Exception occured at parsing amount :"+amount+" tid :: "+tid+" eid :: "+eid);  
      }
      apirrkey=getManagerAPIKey(tid);
      Stripe.apiKey=apirrkey.trim();	
      chargeId=getStripeChargeID(tid);      
      result=Charge.retrieve(chargeId);
      Map<String, Object> refundParams = new HashMap<String, Object>();
      refundParams.put("amount",amount);
      result=result.refund(refundParams);
      resultMap=PrepareResultMap(result);
      resultMap.put("chargeId",chargeId);
    }catch (InvalidRequestException e) {
        // Invalid parameters were supplied to Stripe's API
        System.out.println("InvalidRequestException occured tid: "+tid+" Error: "+e.getMessage()); 
        resultMap.put("failuremessage",e.getMessage());
    }catch (AuthenticationException e) {
        // Authentication with Stripe's API failed
        // (maybe you changed API keys recently)
      	System.out.println("AuthenticationException occured tid: "+tid+" Error: "+e.getMessage());
      	resultMap.put("failuremessage",e.getMessage());
    }catch (APIConnectionException e) {
         // Network communication with Stripe failed
      	System.out.println("APIConnectionException occured tid: "+tid+" Error: "+e.getMessage());
      	resultMap.put("failuremessage",e.getMessage());
    }catch (StripeException e) {
         // Display a very generic error to the user, and maybe send
        // yourself an email
     	System.out.println("StripeException occured tid: "+tid+" Error: "+e.getMessage());
     	resultMap.put("failuremessage",e.getMessage());
    }catch(Exception e){
      System.out.println("Exception occured in refundStripePayment tid: "+tid+" Error: "+e.getMessage());
      resultMap.put("failuremessage",e.getMessage());
    }
     String status="";
     if(!"".equals(resultMap.get("id")) && resultMap.get("id")!=null && resultMap.get("failuremessage")==null)
   	  status="Success";
     else{
    	if(resultMap.get("failuremessage")!=null) failuremessage=resultMap.get("failuremessage");
   	 	status="failure;"+"<br/>failuremessage: "+failuremessage;
     }
     String insertquery="insert into refund_track(eventid,tid,amount,payment_type,response,refunded_at,reference_id,status) values(?,?,?,?,?,now(),?,?)";
 	 StatusObj sb=DbUtil.executeUpdateQuery(insertquery,new String[]{eid,tid,originalamt,payment_type,result==null?failuremessage:result.toString(),chargeId,status});
     return resultMap;
   }

   public String getStripeChargeID(String tid){
        String chargeid="";
        try{
        chargeid=DbUtil.getVal("select ext_pay_id from event_reg_transactions where tid=?",new String[]{tid});	
        }
	catch(Exception e){System.out.println("Exception occured in getStripeChargeID for transaction::"+tid);}
	if(chargeid==null)chargeid="";
        return chargeid;
}

  public String getManagerAPIKey(String tid){
	String apikey="";
	try{
	apikey=DbUtil.getVal("select mgr_api_key from stripe_payment_data where status='Success' and tid=? ",new String[]{tid});
	if(apikey==null)apikey="";
	}catch(Exception e){System.out.println("Exception occured in getManagerAPIKey for tid::"+tid);}
	return apikey;
}

   public HashMap<String,String> PrepareResultMap(Charge result){
      HashMap<String,String> resultMap=new HashMap<String,String>(); 
     try{
    	 if(result.getLivemode()!=null) resultMap.put("livemode",result.getLivemode()+"");
    	 if(result.getId()!=null) resultMap.put("id",result.getId());
    	 if(result.getRefunded()!=null) resultMap.put("refundstatus",result.getRefunded()+"");
    	 if(result.getAmountRefunded()!=null) resultMap.put("refundamount",result.getAmountRefunded()+"");
		 if(result.getPaid()!=null) resultMap.put("paidstatus",result.getPaid()+"");
		 if(result.getAmount()!=null) resultMap.put("amount",result.getAmount()+"");
		 if(result.getCurrency()!=null) resultMap.put("currency",result.getCurrency());
		 if(result.getCustomer()!=null) resultMap.put("customer",result.getCustomer());
		 if(result.getDescription()!=null) resultMap.put("description",result.getDescription());
		 if(result.getCreated()!=null) resultMap.put("created",result.getCreated()+"");
		 if(result.getCaptured()!=null) resultMap.put("capturestatus",result.getCaptured()+"");
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
     //resultMap.put("responsejson",result.toString());
     }catch(Exception e){
		 System.out.println("Exception occured at PrepareResultMap"+e.getMessage());
	 }
     return resultMap;
}
%>

<%
  String tid=request.getParameter("tid");
  System.out.println("In striperefund.jsp tid: "+tid);
  String amount=request.getParameter("amount");
  String eid=request.getParameter("eid");
  String payment_type=request.getParameter("payment_type");
  HashMap<String,String> resultMap=new HashMap<String,String>();
  resultMap=refundStripePayment(tid,amount,eid,payment_type); 
  System.out.println("failuremessage is:"+resultMap.get("failuremessage")+" tid :: "+tid+" eid :: "+eid+" amount :: "+amount);
  if(!"".equals(resultMap.get("id")) && resultMap.get("id")!=null && resultMap.get("failuremessage")==null){
	  resultMap.put("status","Success");
  }else{
	 resultMap.put("status","failure");
  }
  StringBuffer sbf=new StringBuffer();
  sbf.append("<Response>\n");
  if("Success".equals(resultMap.get("status")))
	  sbf.append("<Status>Success</Status>\n<TransactionID>"+tid+"</TransactionID>\n<internalrefid>"+resultMap.get("chargeId")+"</internalrefid>\n");
  else
	  sbf.append("<Status>Fail</Status>\n<TransactionID>"+tid+"</TransactionID>\n<ErrorMsg>"+resultMap.get("failuremessage")+"</ErrorMsg>\n"); 
  sbf.append("</Response>");
  System.out.println("response is: "+sbf.toString());
 // String insertquery="insert into refund_track(eventid,tid,amount,payment_type,response,refunded_at,reference_id,status) values(?,?,?,?,?,now(),?,?)";
//	StatusObj sb=DbUtil.executeUpdateQuery(insertquery,new String[]{eid,tid,amount,payment_type,resultMap.get("responsejson"),resultMap.get("chargeId"),resultMap.get("status")});


out.println(sbf.toString());
%>
