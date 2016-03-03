<%@ page import="java.io.*,java.text.*,java.sql.*" %>
<%@ page import="java.util.*,org.w3c.dom.*" %>
<%@ page import="com.google.checkout.checkout.*" %>
<%@ page import="com.google.checkout.*" %>
<%@ page import="com.google.checkout.notification.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.util.*,com.eventbee.event.*,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.event.ticketinfo.*,com.eventbee.general.formatting.*"%>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.creditcard.*"%>

<%@ include file="regemail.jsp" %>

<%! 


public String  getProcessedXMLData(Document doc,String tagName,String tagElements){
		String nvalue="";
		Map resMap=new HashMap();

		try{
			NodeList listOfNodes = doc.getElementsByTagName(tagName);
			for(int s=0; s<listOfNodes.getLength() ; s++){
				Node firstNode = listOfNodes.item(s);
				if(firstNode.getNodeType() == Node.ELEMENT_NODE){

					Element firstElement = (Element)firstNode;
					
						NodeList nList = firstElement.getElementsByTagName(tagElements);
						Element nElement = (Element)nList.item(0);
						NodeList textnList = nElement.getChildNodes();
						nvalue=((Node)textnList.item(0)).getNodeValue().trim();
						
				
				}//if
			}//for
		}//try
		catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ProcessXMLData.java", "getProcessedXMLData", e.getMessage(), e ) ;
		}

		return nvalue;
	}
	
	public int UpdateData(String ebee_tran_id, String google_order_no, String message, String type,String status){
		int val=0;
		String QUERY="";
		StatusObj statobjn=null;
		
		String msg=message.replace("'","\"");
		if(type=="new-order-notification"){
		
		  QUERY="update google_payment_data set google_order_no=?,google_notif_time=now(),google_notif_xml=? where ebee_tran_id=?";
		  statobjn= DbUtil.executeUpdateQuery(QUERY, new String []{google_order_no,msg,ebee_tran_id});
		  
		  if(statobjn.getStatus())
		  	val=1;
		  }
		  if(type=="risk-information-notification"){
		  
		  QUERY="update google_payment_data set google_risk_time=now(),google_risk_xml=? where google_order_no=?";
		  statobjn= DbUtil.executeUpdateQuery(QUERY, new String []{msg,google_order_no});
		  
		  if(statobjn.getStatus())
		  	val=1;
		  
		  }
		  if(type=="order-state-change-notification"){
		
			  QUERY="update google_payment_data set google_charged_time=now(),google_charged_xml=?,google_charged_status=? where google_order_no=?";
			  statobjn= DbUtil.executeUpdateQuery(QUERY, new String []{msg,status,google_order_no});
			  
			  if(statobjn.getStatus())
			  	val=1;
		  }
		  
		  
		 return val;
	
	}
	
	public int InsertData(String google_order_no, String message, String type){
	int vals=0;
	String QUERY1="";
	StatusObj statobjn1=null;
		if(type=="order-state-change-notification"){
		  String msg=message.replace("'","\"");
		  QUERY1="insert into google_order_state_notification(google_order_no,order_notif_xml,order_notif_time) values(?,?,now())";
		  statobjn1= DbUtil.executeUpdateQuery(QUERY1, new String []{google_order_no,msg});
		  
		  if(statobjn1.getStatus())
		  	vals=1;
		  
		  }
		return vals;
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
int qty=Integer.parseInt(sold_qty)-q;
StatusObj sb=DbUtil.executeUpdateQuery("update price set sold_qty=? where price_id=?",new String[]{qty+"",priceid});
}
}
}

	


%>


<%


StringBuffer buf = new StringBuffer();
	 BufferedReader   in = new BufferedReader(new InputStreamReader(request.getInputStream()));
		String line;
		String message = "";
		while((line = in.readLine()) != null) {
			buf.append(line.trim() + "\n");
		}
		in.close();
		in=null;
		message = buf.toString();
		
		//message=data;
		
	
	
Collection itemvec=new Vector();
long ln=0;
String ccno="";
String type="";
String serialno="";
String gorderno="";


CompositeNotificationParser cnp= new CompositeNotificationParser();
CompositeNotificationParser.registerDefaultNotificationParsers(cnp);
 if(message!=null && !"".equals(message)){
 try{
	CheckoutNotification cn= cnp.parse(message);
	type=cn.getType();
 	serialno=cn.getSerialNumber();
	gorderno=cn.getGoogleOrderNumber();
		}catch(Exception e){
	System.out.println(e.getMessage());
	}
 }	
 

%>

<%
String ebee_transaction_id= null;
String eventid=null;
StatusObj statob=null;
StatusObj sb=null;

String itemname=null;
if(NotificationTypes.NEW_ORDER_NOTIFICATION.equals(type)){
	String CARD_TRAN_QUERY="insert into cardtransaction(internal_ref,response_id,app_name,transaction_date,amount,process_vendor )"
							+"values(?,?,'EVENT_REGISTRATION',now(),?,'google')";
	NewOrderNotification non=new NewOrderNotification(message);
	StringBufferInputStream sbips= new StringBufferInputStream(message);
	Document doc1=ProcessXMLData.getDocument(sbips);
	ebee_transaction_id=getProcessedXMLData(doc1,NotificationTypes.NEW_ORDER_NOTIFICATION,"ebee-trans-id");
	String google_order_no=getProcessedXMLData(doc1,NotificationTypes.NEW_ORDER_NOTIFICATION,"google-order-number");
	String amount=getProcessedXMLData(doc1,NotificationTypes.NEW_ORDER_NOTIFICATION,"order-total");
	int retcount=UpdateData(ebee_transaction_id,google_order_no,message,type,"");
	statob= DbUtil.executeUpdateQuery(CARD_TRAN_QUERY, new String []{ebee_transaction_id,google_order_no,amount});
         String BKP_TRAN_QUERY="insert into google_payment_backup_data(notifyxml,date,google_order_number) "
                              +" values(?,now(),?)";
        
	 sb= DbUtil.executeUpdateQuery(BKP_TRAN_QUERY, new String []{message,google_order_no});

     
}

else if(NotificationTypes.RISK_INFORMATION_NOTIFICATION.equals(type)){
	
	String avs_resp=null;
	String cvn_responce=null;
	String cc_number=null;
	int account_expire_days=0;
	
	
	RiskInformationNotification rin= new RiskInformationNotification(message);
	
	StringBufferInputStream sbips= new StringBufferInputStream(message);
	Document doc1=ProcessXMLData.getDocument(sbips);
	
	RiskInformationNotification rinfo= new RiskInformationNotification(message);
		
	String google_order_no=getProcessedXMLData(doc1,NotificationTypes.RISK_INFORMATION_NOTIFICATION,"google-order-number");
	
	if(rinfo!= null){
		avs_resp=rinfo.getAvsResponse();
		cvn_responce=rinfo.getCvnResponse();
		cc_number=rinfo.getPartialCcNumber();
		account_expire_days=rinfo.getBuyerAccountAge();
				
	}
	ebee_transaction_id=DbUtil.getVal("select ebee_tran_id from google_payment_data where google_order_no=?", new String []{google_order_no});
	statob= DbUtil.executeUpdateQuery("update cardtransaction set cardnum=?,cardtype='',transaction_date=now(),response_scode=?,proces_status=? where response_id=?", new String []{cc_number,cvn_responce,avs_resp,google_order_no});
	
		
	int retcount=UpdateData("",google_order_no,message,"risk-information-notification","");
}

else if(NotificationTypes.ORDER_STATE_CHANGE_NOTIFICATION.equals(type)){
	
	StringBufferInputStream sbips= new StringBufferInputStream(message);
	Document doc1=ProcessXMLData.getDocument(sbips);
	String nondb=null;
	
	
	
	String google_order_no=getProcessedXMLData(doc1,"order-state-change-notification","google-order-number");
	
	ebee_transaction_id=DbUtil.getVal("select ebee_tran_id from google_payment_data where google_order_no=?", new String []{google_order_no});
	
	int retcount=InsertData(google_order_no,message,"order-state-change-notification");
	
	String finacial_order_state=getProcessedXMLData(doc1,"order-state-change-notification","new-financial-order-state");
	
	String isalreadyinserted=DbUtil.getVal("select 'yes' from transaction where transactionid=?",new String[]{ebee_transaction_id});
	if("CHARGED".equals(finacial_order_state) || "CHARGEABLE".equals(finacial_order_state)){
		 retcount=UpdateData("",google_order_no,message,"order-state-change-notification",finacial_order_state);
		StatusObj statobj1= DbUtil.executeUpdateQuery("update cardtransaction set proces_status=? where response_id=?", new String []{finacial_order_state,google_order_no});
				
		 if(retcount>0){
		 
		 	nondb=DbUtil.getVal("select google_notif_xml from google_payment_data where google_order_no=?", new String []{google_order_no});
		 
		 	if(nondb!=null && !"".equals(nondb)){
		 	if(!"yes".equals(isalreadyinserted)){
				
		 		EventRegisterDataBean edb= new EventRegisterDataBean();
				EventRegisterManager erm=new EventRegisterManager();
				EventRegisterManager.initEventRegXmlData(nondb,edb);
				StatusObj statobj=erm.insertRegData(edb);
				
				DbUtil.executeUpdateQuery("delete from trackurl_transaction where trackingcode is null", new String []{});
							  	String trackingCode=DbUtil.getVal("select trackingcode from trackurl_transaction where transactionid=?  and trackingcode is not null", new String []{ebee_transaction_id}); 
								if(trackingCode!=null){
								DbUtil.executeUpdateQuery("update event_reg_transactions set trackpartner=? where tid=?", new String []{trackingCode,ebee_transaction_id});
				}
				 
				if("true".equals(edb.getUpgradeRegStatus())){
				String result=DbUtil.getVal("select mergeTransactions(?,?) as result", new String []{edb.getOldTransactionId(),edb.getTransactionId()}); 
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"googlenotifiation.jsp Transaction upgraded","OLD TRANSACTION ID---"+edb.getOldTransactionId()+"----NEW TRANSACTION ID---"+edb.getTransactionId(),"",null);
 				//EventRegisterManager.MergeTransactions(edb);
				}
 
			      StatusObj sobj= DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{"Completed",ebee_transaction_id});
			      statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{"Completed",ebee_transaction_id});

				 ProfileData[] pd=edb.getProfileData();
				 
				int mailstatus=sendRegistrationEmail(pd,edb);

			  }
		 	}
		 	
		 
		 }
		 DbUtil.executeUpdateQuery("delete from google_order_state_notification where google_order_no=?", new String []{google_order_no});
	
	}
	if("CANCELLED".equals(finacial_order_state)){
	String ebeetranid= DbUtil.getVal("select internal_ref from cardtransaction where response_id=?", new String []{google_order_no});
	statob= DbUtil.executeUpdateQuery("update cardtransaction set proces_status=? where response_id=?", new String []{finacial_order_state,google_order_no});
		statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{"CANCELLED",ebeetranid});
		statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{finacial_order_state,ebeetranid});
		statob=DbUtil.executeUpdateQuery("update eventattendee set eventid=-eventid where transactionid=?", new String []{ebeetranid});
		Vector v=getTickets(ebeetranid);
		statob=DbUtil.executeUpdateQuery("update attendeeticket set eventid='-'||eventid where transactionid=?", new String []{ebeetranid});
		reduceSoldQuantity(v);

		statob=DbUtil.executeUpdateQuery("update attendeeticket set ticketid=-ticketid where transactionid=?", new String []{ebeetranid});
                
	    }

}
/*else{
	StringBufferInputStream sbips= new StringBufferInputStream(message);
	Document doc1=ProcessXMLData.getDocument(sbips);
	String google_order_no=getProcessedXMLData(doc1,"refund-amount-notification","google-order-number");
	ebee_transaction_id=DbUtil.getVal("select ebee_tran_id from google_payment_data where google_order_no=?", new String []{google_order_no});
	int retcount=InsertData(google_order_no,message,"refund-amount-notification");
	statob= DbUtil.executeUpdateQuery("update cardtransaction set proces_status=? where response_id=?", new String []{"CANCELLED",google_order_no});
	statob=DbUtil.executeUpdateQuery("update transaction set payment_status=? where transactionid=?", new String []{"CANCELLED",ebee_transaction_id});
	statob=DbUtil.executeUpdateQuery("update eventattendee set eventid=-eventid where transactionid=?", new String []{ebee_transaction_id});
	Vector v=getTickets(ebee_transaction_id);
	statob=DbUtil.executeUpdateQuery("update attendeeticket set eventid='-'||eventid where transactionid=?", new String []{ebee_transaction_id});
	reduceSoldQuantity(v);
	statob=DbUtil.executeUpdateQuery("update attendeeticket set ticketid=-ticketid where transactionid=?", new String []{ebee_transaction_id});



}

*/
%>

<notification-acknowledgment xmlns="http://checkout.google.com/schema/2" serial-number="<%=serialno%>" />