<%@page import="com.eventregister.RegistrationConfirmationEmail"%>
<%@page import="com.eventregister.RegistrationProcessDB"%>
<%@page import="java.util.ArrayList"%>
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
	System.out.println("request came in papalxstatusnew.jsp:: eid::"+eid+"  tid::"+tid);
	ArrayList<PaymentInfo> paylist=null;
	String payKey="";
try {
	String newtid=DbUtil.getVal("select new_tid from newtid_track where old_tid=?",new String[]{tid});
	if(newtid!=null && !"".equals(newtid))
		tid=newtid;
	System.out.println("in paypalxstatusnew ");
	String msg="";
    payKey=DbUtil.getVal("select paykey from paypal_payment_data where ebee_tran_id=?",new String[]{tid});;	   
	PaymentDetailsRequest paydetailReq = new PaymentDetailsRequest();
	RequestEnvelope en = new RequestEnvelope();
	en.setErrorLanguage("en_US");
	paydetailReq.setPayKey(payKey);
	paydetailReq.setRequestEnvelope(en);
	AdaptivePayments ap = new AdaptivePayments();
	PaymentDetailsResponse paydetailsResp =	 ap.paymentDetails(paydetailReq);	
	status=paydetailsResp.getStatus();
	
	PaymentInfoList payinfolist=paydetailsResp.getPaymentInfoList();
	paylist=(ArrayList<PaymentInfo>) payinfolist.getPaymentInfo();
	System.out.println("in paypalxstatusnew: "+status +"   tid::"+tid);
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
	
	
	/*paypalxnotification jsp code start*/
	
try{
	String receiver1_id="";
	String receiver2_id="";
	String receiver1_status="";
	String  receiver2_status="";
	String paymentStatus = status;
	String paymentAmount="";
	String txnId="";
	String quantity ="";
	String pending_reason="";
	String res="";
	for(int i=0;i<paylist.size();i++){		
		Receiver receiver=paylist.get(i).getReceiver();
		if(i==0){
			receiver1_id=receiver.getInvoiceId();
			receiver1_status=paylist.get(i).getSenderTransactionStatus();
			paymentAmount=""+receiver.getAmount();
			txnId=paylist.get(i).getTransactionId();
		}
		if(i==1){
			receiver2_id=receiver.getInvoiceId();
			receiver2_status=paylist.get(i).getSenderTransactionStatus();
		}
	}
	
	String itemNumber=DbUtil.getVal("select ebee_tran_id  from paypal_payment_data where paykey=?", new String []{payKey});
	String refid=null;
	StatusObj statob=null;					   
	EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalxnotification.jsp", "response from paypal", " ****#####Values from paypal to new flow---- "+itemNumber,null);
	
	if(itemNumber!=null && !"".equals(itemNumber))
	 refid=DbUtil.getVal("select refid from paypal_payment_data where ebee_tran_id=?", new String []{itemNumber}); 
	// StatusObj sb=DbUtil.executeUpdateQuery("insert into paypal_payment_backup_data(refid,ebee_tran_id,response_status,process_status,date,paypal_tran_id,pending_reason) values(?,?,?,?,now(),?,?)",new String[]{refid,itemNumber,res,paymentStatus,txnId,pending_reason});
	StatusObj sb=DbUtil.executeUpdateQuery("insert into paypal_payment_backup_data(refid,ebee_tran_id,response_status,process_status,date,paypal_tran_id,pending_reason) values(?,?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?)",new String[]{refid,itemNumber,res,paymentStatus,DateUtil.getCurrDBFormatDate(),txnId,pending_reason});
	      
	if(refid==null)
	return;
	String isalreadyinserted=DbUtil.getVal("select 'yes' from event_reg_transactions where tid=?",new String[]{itemNumber});
		
	EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalxnotification.jsp", "paymentStatus from paypal out side LOOP", " "+paymentStatus,null);

	if("Completed".equalsIgnoreCase(paymentStatus)||"Pending".equals(paymentStatus)){
	if("Completed".equalsIgnoreCase(paymentStatus))
	paymentStatus="Completed";

	EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalxnotification.jsp", "paymentStatus from paypal in side LOOP", " "+paymentStatus,null);
	try{
	StatusObj statobj=null;  
	if(!"yes".equals(isalreadyinserted)){
	RegistrationProcessDB rgdb=new RegistrationProcessDB();
	RegistrationConfirmationEmail regmail=new RegistrationConfirmationEmail();
	int result=rgdb.InsertRegistrationDb(itemNumber,refid);
	int emailcount=regmail.sendRegistrationEmail(itemNumber,refid);
	}

	statob=DbUtil.executeUpdateQuery("update event_reg_details_temp set status=? where tid=?", new String []{"Completed",itemNumber});
	statob= DbUtil.executeUpdateQuery("update paypal_payment_data set paypal_order=? where ebee_tran_id=?", new String []{paymentStatus,itemNumber});
	statob= DbUtil.executeUpdateQuery("update event_reg_transactions  set paymentstatus= case when paymentstatus ='Pending' then  ?  else   COALESCE(paymentstatus ,'Completed')  end  where tid=?", new String []{paymentStatus,itemNumber});
	}catch(Exception e){
	EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,"paypalnotification.jsp","paypal notification","ERROR in process db",e);

	}
}
	}catch(Exception e){
		System.out.println("Exception occured while doing paypalxnotification action in papalxstatusnew:: "+"tid::"+tid+" ::"+e.getMessage());
	}
	/*paypalxnotification jsp code end*/
	
	
	
			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
%>