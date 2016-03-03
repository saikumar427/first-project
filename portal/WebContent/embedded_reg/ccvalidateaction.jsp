<%@ page import="org.json.*"%>
<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.creditcard.*,com.eventbee.event.*,com.eventregister.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file="AuthorizeAIMPayment.jsp" %>
<%@ include file="BraintreePayprocess.jsp" %>
<%@ include file="StripePayment.jsp" %>
<%@ include file="payulatampayment.jsp" %>
<%@ page import="com.event.dbhelpers.DisplayAttribsDB,com.eventbee.layout.DBHelper" %>
<%!
boolean CheckIsAlreadySuccess(String transactionid){
boolean flag=false;
String ack=DbUtil.getVal("select 'yes' from event_reg_transactions where tid=?",new String[]{transactionid});
if("yes".equals(ack)){
flag=true;
}
return flag;
}

public String getEventName(String eid){
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid =CAST(? AS BIGINT)",new String[]{eid});
		if(eventname==null) eventname="";
		String allowedChars[]={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
				"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"," "};
						List allowed=Arrays.asList(allowedChars);
		String neweventname="";
						for(int i=0;i<eventname.length();i++){
							String s=eventname.charAt(i)+"";
							if(allowed.contains(s))
							neweventname+=s;
						}
		if(neweventname.length()>10)
			neweventname=neweventname.substring(0,10);
	return neweventname;
}

public String getCardErrorMessage(String eid){
	String carderrormsg="";
	HashMap<String,String> disAttribsForKeys=new HashMap<String,String>();
	//carderrormsg=DbUtil.getVal("select attrib_value from custom_event_display_attribs where attrib_name='event.reg.payments.failure.label' and module='RegFlowWordings' and eventid=CAST(? as BIGINT)",new String[]{eid});
	String lang="en_US";
	if(!"".equals(eid) && eid !=null)
		lang=DBHelper.getLanguageFromDB(eid);
	disAttribsForKeys=DisplayAttribsDB.getAttribValuesForKeys(eid,"RegFlowWordings",lang, new String [] {"event.reg.payments.failure.label"});
	carderrormsg=disAttribsForKeys.get("event.reg.ticket.page.Header");
	if(carderrormsg==null || "null".equalsIgnoreCase(carderrormsg))carderrormsg="We haven't received payment confirmation from Credit Card processor. You'll receive registration confirmation email, if payment is successfully processed.";
	return carderrormsg;
}
%>

<%
JSONObject object=new JSONObject();
CreditCardModel ccm=new CreditCardModel();
ProfileData m_ProfileData=new ProfileData();
HashMap hm=new HashMap();
String carderrormsg="";
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String m_cardamount=request.getParameter("totalamount");
hm.put(CardConstants.INTERNAL_REF,tid);
hm.put(CardConstants.REQUEST_APP,"EVENT_REGISTRATION");
hm.put(CardConstants.TRANSACTION_TYPE,CardConstants.TRANS_ONE_TIME);
hm.put(CardConstants.BASE_REF,"/card");
hm.put(CardConstants.LOGO_URL,"");
hm.put(CardConstants.AUTH_POLICY,"");
hm.put(CardConstants.AUTH_URL,"");
hm.put(CardConstants.AMOUNT,""+m_cardamount);
ccm.setParams(hm);
ccm.setProfiledata(m_ProfileData); 
ccm.setCardtype(request.getParameter("cardtype"));
ccm.setCardnumber(request.getParameter("cardnumber"));
ccm.setCvvcode(request.getParameter("cvvcode"));
ccm.setExpmonth(request.getParameter("expmonth"));
ccm.setExpyear(request.getParameter("expyear"));

ccm.getProfiledata().setFirstName(request.getParameter("firstName"));
ccm.getProfiledata().setLastName(request.getParameter("lastName"));
ccm.getProfiledata().setEmail(request.getParameter("email"));
ccm.getProfiledata().setCompany(request.getParameter("company"));
ccm.getProfiledata().setStreet1(request.getParameter("street1"));
ccm.getProfiledata().setStreet2(request.getParameter("street2"));
ccm.getProfiledata().setCity(request.getParameter("city"));
//if("US".equals(request.getParameter("country")))
ccm.getProfiledata().setState(request.getParameter("state"));
//else
//ccm.getProfiledata().setState(request.getParameter("non_us_state"));

if("authorize.net".equals(request.getParameter("vendor_pay"))){
	if("US".equals(request.getParameter("country")) || "CA".equals(request.getParameter("country")))
	ccm.getProfiledata().setState(request.getParameter("state"));	
	else
    ccm.getProfiledata().setState("default");
}


ccm.getProfiledata().setCountry(request.getParameter("country"));
ccm.getProfiledata().setZip(request.getParameter("zip"));
ccm.getProfiledata().setPhone(request.getParameter("phone"));

String currencyformat1=DbUtil.getVal("select currency_code from event_currency where eventid=?",new String[]{eid});
if(currencyformat1==null)
currencyformat1="USD";
ccm.setCurrencyCode(currencyformat1);//4007000000027
ccm.setSoftDesc(getEventName(eid));
boolean isregistered=CheckIsAlreadySuccess(tid);
if(eid==null&&tid==null){
JSONArray arr=new JSONArray();
arr.put("Transaction can not processed this time, please try back later");
object.put("status","error");

object.put("errors",arr);
}
else if(isregistered){
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "trying to submit for the second time transactionid---->"+tid, "", null);
object.put("status","alreadyCompleted");
}
else{
StatusObj sobj= ccm.localValidate();
Vector v=new Vector();
String error="";
if(sobj.getStatus()){
v=(Vector)(sobj.getData());
}
String vendor=request.getParameter("vendor_pay"); 
if(vendor==null) vendor="paypal_pro";
if(v==null || v.size()==0){
if(!"authorize.net".equals(vendor) && ! vendor.contains("braintree")&& ! vendor.contains("stripe") && ! vendor.contains("payulatam")){
sobj= ccm.validate();		       
if(sobj.getStatus()){
   if(sobj.getData() instanceof Vector){
     v =(Vector)(sobj.getData());
     carderrormsg=getCardErrorMessage(eid);
   } else if(sobj.getData() instanceof String){
         error=(String)(sobj.getData());
          v.add("This transaction can not be processed at this time, please try back later");
          carderrormsg=getCardErrorMessage(eid);
        }
   } 
   }
   else if("authorize.net".equals(vendor)){
		AuthorizeAIMPaymentProcess aimp = new AuthorizeAIMPaymentProcess();
		HashMap<String,String> apmap =aimp.processPayment(ccm,request);		
		if(apmap!=null && !"Success".equals(apmap.get("status"))){
		if(apmap.get("card_error")!=null)        
		v.add(apmap.get("Response Reason Text"));
		else{ 
			v.add("This transaction can not be processed at this time, please try back later");	
			carderrormsg=getCardErrorMessage(eid);
		   }
		}
		else if(apmap==null){ 
			v.add("This transaction can not be processed at this time, please try back later");
			carderrormsg=getCardErrorMessage(eid);		
		}
   }
   else if(vendor!=null && vendor.contains("braintree")){
        BraintreePayprocess brp=new BraintreePayprocess();
		HashMap brainmap=brp.payAmount(ccm,request,vendor);		
		System.out.println("volsat:::"+brainmap);
		if(brainmap!=null&&(brainmap.get("status")==null ||!"Success".equals(brainmap.get("status")))){
        v.add(brainmap.get("shortmsg"));
        carderrormsg=getCardErrorMessage(eid);
		}else if(brainmap==null){
          v.add("This transaction can not be processed at this time, please try back later");
          carderrormsg=getCardErrorMessage(eid);
       }
   }
    else if(vendor!=null && vendor.contains("stripe")){
	 System.out.println("INside Stripe");
      StripeGateWayProcessPayment sp=new StripeGateWayProcessPayment();
       HashMap<String,String> resultMap=sp.processStripePayment(ccm,request,"charge");
		if("failure".equals(resultMap.get("status"))){
		 v.add(resultMap.get("failuremessage"));
		 if("This transaction can not be processed at this time, please try back later".equalsIgnoreCase(resultMap.get("failuremessage")))
			 carderrormsg=getCardErrorMessage(eid);
		}
	}else if(vendor!=null && vendor.contains("payulatam")){
		System.out.println("INside payulatam");
		PayULatamPayProcess payu= new PayULatamPayProcess();
		HashMap<String,String> resultMap=payu.processPayuPayment(ccm,request,"");
		if("failure".equals(resultMap.get("status"))){
			 v.add(resultMap.get("failuremessage"));
		}	 
	}
 }
 
 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "ccvalidateaction.jsp", "validation results from credit card for  transactionid---->"+tid+" is "+v, "", null);
if(v==null || v.size()==0){
StatusObj sb=DbUtil.executeUpdateQuery("update event_reg_details_temp set status='Completed',cc_vendor=? where tid=?",new String[]{vendor,tid});
if("authorize.net".equals(vendor) || "braintree_manager".equals(vendor) || "stripe".equals(vendor) || "payulatam".equals(vendor))
DbUtil.executeUpdateQuery("update event_reg_details_temp set selectedpaytype=? where tid=?",new String[]{"braintree_manager".equals(vendor)?"braintree":vendor,tid});

RegistrationProcessDB rgdb=new RegistrationProcessDB();
RegistrationConfirmationEmail regconfirm=new RegistrationConfirmationEmail();
int result=rgdb.InsertRegistrationDb(tid,eid);
int emailcount=regconfirm.sendRegistrationEmail(tid,eid);
object.put("status","success");
}else{
JSONArray errorsArray=new JSONArray();
if(v!=null&&v.size()>0){
for(int i=0;i<v.size();i++){
errorsArray.put(v.elementAt(i));
}
}
object.put("status","error");

object.put("errors",errorsArray);
}
}
object.put("tid",tid);
object.put("eid",eid);
object.put("ccerrormsg",carderrormsg);

out.println(object.toString());

%>



