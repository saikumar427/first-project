<%@ page import="java.net.*" %>
<%@ page import="java.io.*,java.text.*" %>
<%@ page import="java.util.*,org.w3c.dom.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.util.*,com.eventregister.*"%>
<%
Enumeration en = request.getParameterNames();
String str = "cmd=_notify-validate";
while(en.hasMoreElements()){
String paramName = (String)en.nextElement();
String paramValue = request.getParameter(paramName);
str = str + "&" + paramName + "=" + URLEncoder.encode(paramValue);
}
System.out.println("str::"+str);
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalnotification.jsp", "response from paypal", " ****#####Values from paypal---- "+str,null);
String paypal_url=EbeeConstantsF.get("paypal.form.url","https://www.sandbox.paypal.com/cgi-bin/webscr");
String res="";
try{
URL u = new URL(paypal_url);
URLConnection uc = u.openConnection();
uc.setDoOutput(true);
uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
PrintWriter pw = new PrintWriter(uc.getOutputStream());
pw.println(str);
pw.close();
BufferedReader in = new BufferedReader(
new InputStreamReader(uc.getInputStream()));
 res = in.readLine();
in.close();
}catch(Exception e){
	System.out.println("Exception occeured while calling standard paypal URL"+e.getMessage());
}
System.out.println("res::"+res);
String itemName = request.getParameter("item_name");
String itemNumber = request.getParameter("item_number");
String paymentStatus = request.getParameter("payment_status");
String paymentAmount = request.getParameter("mc_gross");
String paymentCurrency = request.getParameter("mc_currency");
String txnId = request.getParameter("txn_id");
String receiverEmail = request.getParameter("receiver_email");
String payerEmail = request.getParameter("payer_email");
String quantity =  request.getParameter("quantity");
String pending_reason =  request.getParameter("pending_reason");
String refid=null;    
StatusObj statob=null;					   
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalnotification.jsp", "response from paypal", " ****#####Values from paypal to new flow---- "+itemNumber,null);
if(itemNumber!=null && !"".equals(itemNumber))
 refid=DbUtil.getVal("select refid from paypal_payment_data where ebee_tran_id=?", new String []{itemNumber}); 
 StatusObj sb=DbUtil.executeUpdateQuery("insert into paypal_payment_backup_data(refid,ebee_tran_id,response_status,process_status,date,paypal_tran_id,pending_reason) values(?,?,?,?,now(),?,?)",new String[]{refid,itemNumber,res,paymentStatus,txnId,pending_reason});
      
if(refid==null)
return;
String isalreadyinserted=DbUtil.getVal("select 'yes' from event_reg_transactions where tid=?",new String[]{itemNumber});
	
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalnotification.jsp", "paymentStatus from paypal out side LOOP", " "+paymentStatus,null);


if("Completed".equals(paymentStatus) ||"Pending".equals(paymentStatus)){


EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalnotification.jsp", "paymentStatus from paypal in side LOOP", " "+paymentStatus,null);
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
//statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{paymentStatus,itemNumber});

statob= DbUtil.executeUpdateQuery("update event_reg_transactions  set paymentstatus= case when paymentstatus ='Pending' then  ?  else   COALESCE(paymentstatus ,'Completed')  end  where tid=?", new String []{paymentStatus,itemNumber});

}catch(Exception e){
EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,"paypalnotification.jsp","paypal notification","ERROR in process db",e);

}
}
	
	
	
	
	
	

%>





