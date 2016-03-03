<%@ page import="java.io.*" %>
<%@ page import="java.util.*,org.w3c.dom.*" %>
<%@ page import="com.google.checkout.checkout.*" %>
<%@ page import="com.google.checkout.*" %>
<%@ page import="com.google.checkout.notification.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.util.*"%>
<%@ page import="com.eventregister.*" %>
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

	//QUERY="update google_payment_data set google_order_no=?,google_notif_time=now(),google_notif_xml=? where ebee_tran_id=?";
	QUERY="update google_payment_data set google_order_no=?,google_notif_time=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),google_notif_xml=? where ebee_tran_id=?";
	statobjn= DbUtil.executeUpdateQuery(QUERY, new String []{google_order_no,DateUtil.getCurrDBFormatDate(),msg,ebee_tran_id});

	if(statobjn.getStatus())
	val=1;
	}
	if(type=="risk-information-notification"){

	//QUERY="update google_payment_data set google_risk_time=now(),google_risk_xml=? where google_order_no=?";
	QUERY="update google_payment_data set google_risk_time=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),google_risk_xml=? where google_order_no=?";
	statobjn= DbUtil.executeUpdateQuery(QUERY, new String []{DateUtil.getCurrDBFormatDate(),msg,google_order_no});

	if(statobjn.getStatus())
	val=1;

	}
	if(type=="order-state-change-notification"){

	//QUERY="update google_payment_data set google_charged_time=now(),google_charged_xml=?,google_charged_status=? where google_order_no=?";
	QUERY="update google_payment_data set google_charged_time=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),google_charged_xml=?,google_charged_status=? where google_order_no=?";
	statobjn= DbUtil.executeUpdateQuery(QUERY, new String []{DateUtil.getCurrDBFormatDate(),msg,status,google_order_no});

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
	//QUERY1="insert into google_order_state_notification(google_order_no,order_notif_xml,order_notif_time) values(?,?,now())";
	QUERY1="insert into google_order_state_notification(google_order_no,order_notif_xml,order_notif_time) values(?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
	statobjn1= DbUtil.executeUpdateQuery(QUERY1, new String []{google_order_no,msg,DateUtil.getCurrDBFormatDate()});

	if(statobjn1.getStatus())
	vals=1;

	}
	return vals;
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

String ebee_transaction_id= null;
String eventid=null;
StatusObj statob=null;
StatusObj sb=null;
String itemname=null;

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "googlenotification.jsp", "Response type form Google is---->"+type, "", null);

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
	eventid=DbUtil.getVal("select ebee_tran_id from google_payment_data where google_order_no=?", new String []{ebee_transaction_id});
	
		
	int retcount=UpdateData("",google_order_no,message,"risk-information-notification","");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "googlenotification.jsp", "Response  form Google is for the txid---->"+ebee_transaction_id, "", null);
    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "googlenotification.jsp", "Response  form Google is for the txid--->"+ebee_transaction_id+" and google order number is "+google_order_no, "", null);
	}

else if(NotificationTypes.ORDER_STATE_CHANGE_NOTIFICATION.equals(type)){
	
	StringBufferInputStream sbips= new StringBufferInputStream(message);
	Document doc1=ProcessXMLData.getDocument(sbips);
	String nondb=null;
	
	
	
	String google_order_no=getProcessedXMLData(doc1,"order-state-change-notification","google-order-number");
	
	ebee_transaction_id=DbUtil.getVal("select ebee_tran_id from google_payment_data where google_order_no=?", new String []{google_order_no});
	eventid=DbUtil.getVal("select refid from google_payment_data where google_order_no=?", new String []{google_order_no});
	int retcount=InsertData(google_order_no,message,"order-state-change-notification");
	String finacial_order_state=getProcessedXMLData(doc1,"order-state-change-notification","new-financial-order-state");
	String isalreadyinserted=DbUtil.getVal("select 'yes' from event_reg_transactions where tid=?",new String[]{ebee_transaction_id});
	
	 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "googlenotification.jsp", "Response  form Google is for the txid --->"+ebee_transaction_id+" finacial_order_state is "+finacial_order_state, "", null);
	
	if("CHARGED".equals(finacial_order_state) || "CHARGEABLE".equals(finacial_order_state)){
		 retcount=UpdateData("",google_order_no,message,"order-state-change-notification",finacial_order_state);
			
			
			
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "googlenotification.jsp", "Response  form Google is for the txid --->"+ebee_transaction_id+" retcount is "+retcount, "", null);
		
		  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "googlenotification.jsp", "Response  form Google is for the txid --->"+ebee_transaction_id+" eventid is "+eventid, "", null);
		
		  if(retcount>0){

		     if(!"yes".equals(isalreadyinserted)){
			 if(ebee_transaction_id!=null&&eventid!=null){
			  RegistrationProcessDB rgdb=new RegistrationProcessDB();
			  RegistrationConfirmationEmail regmail=new RegistrationConfirmationEmail();
		      int result=rgdb.InsertRegistrationDb(ebee_transaction_id,eventid);
		      int emailcount=regmail.sendRegistrationEmail(ebee_transaction_id,eventid);
		      statob=DbUtil.executeUpdateQuery("update event_reg_details_temp set status=? where tid=?", new String []{"Completed",ebee_transaction_id});
		      statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{"Completed",ebee_transaction_id});
            }		   
		   }
		  }
		     DbUtil.executeUpdateQuery("delete from google_order_state_notification where google_order_no=?", new String []{google_order_no});

            }


}

%>

<notification-acknowledgment xmlns="http://checkout.google.com/schema/2" serial-number="<%=serialno%>" />