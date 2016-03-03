<%@ page import="com.eventbee.general.*,org.json.JSONObject,adaptivepayments.AdaptivePayments,com.eventregister.RegistrationTiketingManager"%>
<%@ page import="common.com.paypal.platform.sdk.utils.*"%>
<%@ page import="com.paypal.svcs.types.ap.*"%>
<%@ page import="common.com.paypal.platform.sdk.exceptions.*"%>
<%@ page import="com.paypal.svcs.types.common.*"%>
<%@ page import="common.com.paypal.platform.sdk.utils.*"%>
<%@ page import="com.paypal.svcs.services.*"%>
<%@ page import="java.util.HashMap"%>

 
 <%
 JSONObject obj=new JSONObject();
    String status=null;
	String tid=request.getParameter("tid");
	String eid=request.getParameter("eid");
try {
	String newtid=DbUtil.getVal("select new_tid from newtid_track where old_tid=?",new String[]{tid});
	if(newtid!=null && !"".equals(newtid))
		tid=newtid;
System.out.println("in paypalxstatus");
	String msg="";
    String payKey=DbUtil.getVal("select paykey from paypal_payment_data where ebee_tran_id=?",new String[]{tid});;	   
	PaymentDetailsRequest paydetailReq = new PaymentDetailsRequest();
	RequestEnvelope en = new RequestEnvelope();
	en.setErrorLanguage("en_US");
	paydetailReq.setPayKey(payKey);
	paydetailReq.setRequestEnvelope(en);
	AdaptivePayments ap = new AdaptivePayments();
	PaymentDetailsResponse paydetailsResp =	 ap.paymentDetails(paydetailReq);	
	status=paydetailsResp.getStatus();
	System.out.println("in paypalxstatus status: "+status);
	//DbUtil.executeUpdateQuery("insert into paypalx_status_response(tid,paykey,paypaltranid,time,status,payeremail,payer) values(?,?,?,now(),?,?,?)",new String[]{tid,payKey,((PaymentInfo)(paydetailsResp.getPaymentInfoList().getPaymentInfo().get(0))).getTransactionId(),status,paydetailsResp.getSenderEmail(),paydetailsResp.getFeesPayer()});
	DbUtil.executeUpdateQuery("insert into paypalx_status_response(tid,paykey,paypaltranid,time,status,payeremail,payer) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?)",new String[]{tid,payKey,((PaymentInfo)(paydetailsResp.getPaymentInfoList().getPaymentInfo().get(0))).getTransactionId(),DateUtil.getCurrDBFormatDate(),status,paydetailsResp.getSenderEmail(),paydetailsResp.getFeesPayer()});
	if("COMPLETED".equalsIgnoreCase(status))
	obj.put("status","Completed");

   else if("INCOMPLETE".equals(status)||"PROCESSING".equals(status)){
   	obj.put("status",status);
	 msg="<div style='text-align:left;height:400px;padding-left:2px;' ><br/>"
        +"We haven't received payment confirmation from credit card processing company. Some times it may take few minutes to get the confirmation.<p/>"
+"A confirmation email with Transaction ID <b>"+tid+"</b> will be sent to your mail as soon as we get confirmation. <p/>"
+"<span class='error'>NOTE: If you do not find confirmation email in your Inbox, please do check your Bulk folder, and update your spam filter settings to allow Eventbee emails.</span>"
+"<p><a href='#' onClick='refreshPage();'>Back to Tickets page</a><br/>"
+"</div>";
	obj.put("msg",msg);
}
else if("EXPIRED".equalsIgnoreCase(status)){
	obj.put("status",status);
 msg="<div style='text-align:left;height:400px;padding-left:2px;' ><br/>Time is Over,Please go to tickets page to register tickets for this event."
  +"<a href='#' onClick='refreshPage();'>Back to Tickets page</a><br/>"
+"</div>";
	obj.put("msg",msg);
}
else if("CREATED".equalsIgnoreCase(status))
	obj.put("status",status);
else{
status="INVALID";
	obj.put("status","INVALID");

}
	

}
	catch (PPFaultMessage e) {
	System.out.println("in PPFaultMessage: "+e);
	session.setAttribute("exception", e);
	} catch (Exception e) {
		System.out.println("in Exception: "+e);
		session.setAttribute("exception", e);
	}
	if(status==null || "CREATED".equalsIgnoreCase(status) || "INVALID".equalsIgnoreCase(status)){
	RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
	HashMap<String,String> ebeefeeMap=regtktmgr.getEbeeFee(eid);
	String ebeefee=ebeefeeMap.get("finalebeefee");
	DbUtil.executeUpdateQuery("update event_reg_details_temp set ebeefee=CAST(? AS NUMERIC)*(collected_ticketqty)  where tid=?",new String[]{ebeefee,tid});
	}
	obj.put("tid",tid);
out.println(obj.toString());
%>