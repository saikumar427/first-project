<%@ page import="com.eventbee.general.*"%>
<%@ include file="registrationConfirmation.jsp" %>
<%
String itemNumber=request.getParameter("tid");
String paymentStatus = request.getParameter("status");
String host=request.getRemoteHost();
String refid=null;
StatusObj statob=null;	
DbUtil.executeUpdateQuery("update paypal_payment_data set remotehost=? where ebee_tran_id=?",new String[]{host,itemNumber});
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalxnotification.jsp", "response from paypal", " ****#####Values from paypal to new flow---- "+itemNumber,null);
if(itemNumber!=null && !"".equals(itemNumber))
 refid=DbUtil.getVal("select refid from paypal_payment_data where ebee_tran_id=?", new String []{itemNumber}); 
 //StatusObj sb=DbUtil.executeUpdateQuery("insert into paypal_payment_backup_data(refid,ebee_tran_id,response_status,process_status,date,paypal_tran_id,pending_reason) values(?,?,?,?,now(),?,?)",new String[]{refid,itemNumber,res,paymentStatus,txnId,pending_reason});
      
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

statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{paymentStatus,itemNumber});
statob=DbUtil.executeUpdateQuery("update event_reg_details_temp set status=? where tid=?", new String []{"Completed",itemNumber});
statob= DbUtil.executeUpdateQuery("update paypal_payment_data set paypal_order=? where ebee_tran_id=?", new String []{paymentStatus,itemNumber});
statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{paymentStatus,itemNumber});
}catch(Exception e){
EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,"paypalnotification.jsp","paypal notification","ERROR in process db",e);
}
}
	
	
	
	
	
	

%>
