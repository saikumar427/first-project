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
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalxnotification.jsp", "response from paypal", " ****#####Values from paypal---- "+str,null);
String res="";
try{
	String paypal_url=EbeeConstantsF.get("paypalx.form.url","https://www.paypal.com/cgi-bin/webscr");
URL u = new URL(paypal_url);
URLConnection uc = u.openConnection();
uc.setDoOutput(true);
uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
PrintWriter pw = new PrintWriter(uc.getOutputStream());
pw.println(str);
pw.close();
System.out.println("Str"+str);

BufferedReader in = new BufferedReader(
new InputStreamReader(uc.getInputStream()));
 res = in.readLine();
in.close();
}catch(Exception e){
	System.out.println("Exception occeured while calling paypal URL"+e.getMessage());
}
String pay_key=request.getParameter("pay_key");


String itemNumber=DbUtil.getVal("select ebee_tran_id  from paypal_payment_data where paykey=?", new String []{pay_key});

String paymentStatus = request.getParameter("status");
String receiver1_id=request.getParameter("transaction[0].id");
String receiver2_id=request.getParameter("transaction[1].id");
String receiver1_status=request.getParameter("transaction[0].status");
String receiver2_status=request.getParameter("transaction[1].status");
//StatusObj stob=DbUtil.executeUpdateQuery("insert into paypal_payment_response_data(data,paykey,"
//+" rec1status,rec2status,rec1id,rec2id,status,tid,created)"
//+" values(?,?,?,?,?,?,?,?,now())",new String[]{str,pay_key,receiver1_status,receiver2_status,receiver1_id,receiver2_id,paymentStatus,itemNumber});
StatusObj stob=DbUtil.executeUpdateQuery("insert into paypal_payment_response_data(data,paykey,"
		+" rec1status,rec2status,rec1id,rec2id,status,tid,created)"
		+" values(?,?,?,?,?,?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String[]{str,pay_key,receiver1_status,receiver2_status,receiver1_id,receiver2_id,paymentStatus,itemNumber,DateUtil.getCurrDBFormatDate()});
String paymentAmount = request.getParameter("transaction[0].amount");
String txnId = request.getParameter("transaction[0].id");
String quantity =  request.getParameter("quantity");
String pending_reason =  request.getParameter("pending_reason");
String ebee_xml_data=null;
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
	
	
	
	
	
	

%>





