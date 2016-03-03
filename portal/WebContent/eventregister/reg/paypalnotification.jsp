<%@ page import="java.net.*" %>
<%@ page import="java.io.*,java.text.*,java.sql.*" %>
<%@ page import="java.util.*,org.w3c.dom.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.util.*,com.eventbee.event.*,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.event.ticketinfo.*,com.eventbee.general.formatting.*"%>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.creditcard.*"%>
<%!
void SendEmail(String Transactionid,String refid){

try{
       EmailObj obj=EventbeeMail.getEmailObj();
	String HTMLcontent="Hello Sir\n\n The Transaction with The Following Transaction id:"+Transactionid+" for the event having eventid "+refid+" is denied";
        obj.setTo("sridevi@eventbee.org");
        obj.setFrom("support@eventbee.com");
	obj.setSubject("Paypal Payment Denied");
        obj.setHtmlMessage(HTMLcontent);
         EventbeeMail.sendHtmlMailPlain(obj);
      }
    catch(Exception e){
       EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,"Paypal Payment Notification.jsp","SendMail()","ERROR in SendMail method",e);
    }
       



}

Vector getTickets(String transactionid){
Vector vec=new Vector();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery("select ticketid,ticketqty from attendeeticket where transactionid=?",new String[]{transactionid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
HashMap hm=new HashMap();
hm.put("ticketid",db.getValue(i,"ticketid",""));
hm.put("ticketqty",db.getValue(i,"ticketqty",""));
vec.add(hm);
}
}
return vec;
}



void reduceSoldQuantity(Vector vec){
if(vec!=null&&vec.size()>0){
for(int i=0;i<vec.size();i++){
HashMap hm=(HashMap)vec.elementAt(i);
String priceid=(String)hm.get("ticketid");
String quantity=(String)hm.get("ticketqty");
int q=Integer.parseInt(quantity);
String sold_qty=DbUtil.getVal("select sold_qty from price  where price_id=?",new String[]{priceid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"paypal Notification Page In refunds Section Reduce Tickets Method","sold Tickets quantity is  "+sold_qty,"",null);
int qty=Integer.parseInt(sold_qty)-q;
StatusObj sb=DbUtil.executeUpdateQuery("update price set sold_qty=? where price_id=?",new String[]{qty+"",priceid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"paypal Notification Page In refunds Section Reduce Tickets Method","Status of the reducing ticket quantity status"+sb.getStatus(),"",null);
}
}
}



%>
<%@ include file="regemail.jsp" %>








<%

Enumeration en = request.getParameterNames();
String str = "cmd=_notify-validate";
while(en.hasMoreElements()){
String paramName = (String)en.nextElement();
String paramValue = request.getParameter(paramName);
str = str + "&" + paramName + "=" + URLEncoder.encode(paramValue);
}
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.ERROR,"paypalnotification.jsp", "response from paypal", " ****#####Values from paypal---- "+request.getQueryString(),null);
	



String paypal_url=EbeeConstantsF.get("paypal.form.url","https://www.sandbox.paypal.com/cgi-bin/webscr");
// post back to PayPal system to validate
// NOTE: change http: to https: in the following URL to verify using SSL (for increased security).
// using HTTPS requires either Java 1.4 or greater, or Java Secure Socket Extension (JSSE)
// and configured for older versions.
//URL u = new URL("http://www.paypal.com/cgi-bin/webscr");
URL u = new URL(paypal_url);
URLConnection uc = u.openConnection();
uc.setDoOutput(true);
uc.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
PrintWriter pw = new PrintWriter(uc.getOutputStream());
pw.println(str);
pw.close();

BufferedReader in = new BufferedReader(
new InputStreamReader(uc.getInputStream()));
String res = in.readLine();
in.close();

// assign posted variables to local variables
String itemName = request.getParameter("item_name");
String itemNumber = request.getParameter("item_number");
String paymentStatus = request.getParameter("payment_status");
String paymentAmount = request.getParameter("mc_gross");
String paymentCurrency = request.getParameter("mc_currency");
String txnId = request.getParameter("txn_id");
String receiverEmail = request.getParameter("receiver_email");
String payerEmail = request.getParameter("payer_email");
//String = request.getParameter("custom");
String quantity =  request.getParameter("quantity");
String pending_reason =  request.getParameter("pending_reason");

String ebee_xml_data=null;
String refid=null;
String CARD_TRAN_QUERY="insert into cardtransaction(internal_ref,response_id,app_name,transaction_date,amount,process_vendor,proces_status )"
					   +" values(?,?,'EVENT_REGISTRATION',now(),?,'paypal',?)";



StatusObj statob=null;					   

if(itemNumber!=null && !"".equals(itemNumber))
	ebee_xml_data=DbUtil.getVal("select ebee_xml_data from paypal_payment_data where ebee_tran_id=?", new String []{itemNumber}); 
        refid=DbUtil.getVal("select refid from paypal_payment_data where ebee_tran_id=?", new String []{itemNumber}); 
      StatusObj sb=DbUtil.executeUpdateQuery("insert into paypal_payment_backup_data(refid,ebee_tran_id,response_status,process_status,date,paypal_tran_id,pending_reason) values(?,?,?,?,now(),?,?)",new String[]{refid,itemNumber,res,paymentStatus,txnId,pending_reason});
 
           

String isalreadyinserted=DbUtil.getVal("select 'yes' from transaction where transactionid=?",new String[]{itemNumber});
	


	 	
	if("Completed".equals(paymentStatus)||"Pending".equals(paymentStatus)){
		statob= DbUtil.executeUpdateQuery("delete from cardtransaction where internal_ref=?", new String []{itemNumber});
		
		statob= DbUtil.executeUpdateQuery(CARD_TRAN_QUERY, new String []{itemNumber,txnId,paymentAmount,paymentStatus});
		
		// Check the data of perticular transaction id
		try{
		
		       StatusObj statobj=null;  
			if(ebee_xml_data!=null){
			if(!"yes".equals(isalreadyinserted)){
			
				EventRegisterDataBean edb= new EventRegisterDataBean();
				EventRegisterManager erm=new EventRegisterManager();
					
				EventRegisterManager.initEventRegXmlData(ebee_xml_data,edb);
				statobj=erm.insertRegData(edb);
				DbUtil.executeUpdateQuery("delete from trackurl_transaction where trackingcode is null", new String []{});
			  	String trackingCode=DbUtil.getVal("select trackingcode from trackurl_transaction where transactionid=?  and trackingcode is not null", new String []{itemNumber}); 
				if(trackingCode!=null){
				DbUtil.executeUpdateQuery("update event_reg_transactions set trackpartner=? where tid=?", new String []{trackingCode,itemNumber});
				}
				if("true".equals(edb.getUpgradeRegStatus())){
				 String result=DbUtil.getVal("select mergeTransactions(?,?) as result", new String []{edb.getOldTransactionId(),edb.getTransactionId()}); 
				 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"googlenotifiation.jsp Transaction upgraded","OLD TRANSACTION ID---"+edb.getOldTransactionId()+"----NEW TRANSACTION ID---"+edb.getTransactionId(),"",null);
				 //EventRegisterManager.MergeTransactions(edb);
				   }
 
				
				
				
				ProfileData[] pd=edb.getProfileData();
                                
			        int mailstatus=sendRegistrationEmail(pd,edb);
			       
       		 }
       		 
		
		statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{paymentStatus,itemNumber});
                statob=DbUtil.executeUpdateQuery("update event_reg_details set status=? where tid=?", new String []{"Completed",itemNumber});
		statob= DbUtil.executeUpdateQuery("update paypal_payment_data set paypal_order=? where ebee_tran_id=?", new String []{paymentStatus,itemNumber});
                statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{paymentStatus,itemNumber});


			}
		}catch(Exception e){
			EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,"paypalnotification.jsp","paypal notification","ERROR in process db",e);
		
		}
	}
	/*if("Refunded".equals(paymentStatus)){
		statob= DbUtil.executeUpdateQuery("delete from cardtransaction where internal_ref=?", new String []{itemNumber});
		statob= DbUtil.executeUpdateQuery(CARD_TRAN_QUERY, new String []{itemNumber,txnId,paymentAmount,"CANCELLED"});
		statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{"CANCELLED",itemNumber});
	        statob=DbUtil.executeUpdateQuery("update eventattendee set eventid=-eventid where transactionid=?", new String []{itemNumber});
	        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"paypal Notification Page In refunds Section"," updating event attendee status is  "+statob.getStatus(),"",null);
	        Vector v=getTickets(itemNumber);
	        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"paypal Notification Page In refunds Section"," Transactiontickets Vector  is  "+v,"",null);

		statob=DbUtil.executeUpdateQuery("update attendeeticket set eventid='-'||eventid where transactionid=?", new String []{itemNumber});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"paypal Notification Page In refunds Section"," updating attendeeticket eventid status is "+statob.getStatus(),"",null);
		reduceSoldQuantity(v);
	        statob=DbUtil.executeUpdateQuery("update attendeeticket set ticketid=-ticketid where transactionid=?", new String []{itemNumber});
	        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"paypal Notification Page In refunds Section"," updating attendeeticket ticketid status is "+statob.getStatus(),"",null);
		
	
	}*/
	if("Denied".equals(paymentStatus)||"Failed".equals(paymentStatus)){
		statob= DbUtil.executeUpdateQuery("delete from cardtransaction where internal_ref=?", new String []{itemNumber});
		statob= DbUtil.executeUpdateQuery(CARD_TRAN_QUERY, new String []{itemNumber,txnId,paymentAmount,"Denied"});
		statob= DbUtil.executeUpdateQuery("update paypal_payment_data set paypal_order=? where ebee_tran_id=?", new String []{paymentStatus,itemNumber});
		statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{"Denied",itemNumber});
		statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{"Denied",itemNumber});
		statob=DbUtil.executeUpdateQuery("update eventattendee set eventid=-eventid where transactionid=?", new String []{itemNumber});
		Vector v=getTickets(itemNumber);
	        statob=DbUtil.executeUpdateQuery("update attendeeticket set eventid='-'||eventid where transactionid=?", new String []{itemNumber});
		reduceSoldQuantity(v);
		statob=DbUtil.executeUpdateQuery("update attendeeticket set ticketid=-ticketid where transactionid=?", new String []{itemNumber});
	    	
	
	    	SendEmail(itemNumber,refid);
	
	}
	
	
	
	

%>