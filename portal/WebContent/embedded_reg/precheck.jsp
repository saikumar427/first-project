<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.*,com.eventbee.general.*"%>
<%@ page import="com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>

<%!
public String createNewTrnId(String oldTrnId,String eventId){
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", "Entered to create a new transaction id for---->"+oldTrnId, "", null);
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
String GET_TRANSACTION_ID_QUERY = "select nextval('seq_transactionid') as transactionid";
String transid=DbUtil.getVal(GET_TRANSACTION_ID_QUERY,new String[]{});
String newTrnId="RK"+EncodeNum.encodeNum(transid).toUpperCase();
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", "old transaction id is "+oldTrnId+" new transaction id is"+newTrnId, "", null);
DbUtil.executeUpdateQuery("insert into newtid_track(old_tid,new_tid,created_at) values(?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String [] {oldTrnId,newTrnId,DateUtil.getCurrDBFormatDate()});
String regDetailsTempInsrtQry="insert into event_reg_details_temp(clubuserid ,source ,selectedpaytype,"+
  "discountcode ,useragent ,eventid ,tid ,transactiondate ,cardfee,ebeefee ,granddiscount ,tax ,"+
  "nettotal ,totalamount,grandtotal ,trackurl ,ticketurlcode ,eventdate ,context ,"+
  "totticketsqty,current_action,buyer_ntscode,nts_selected_action,nts_commission, referral_ntscode,currency_code,currency_conversion_factor,current_service_fee,collected_ticketqty,ebeefee_usd) select clubuserid ,source ,selectedpaytype,"+
  "discountcode ,useragent ,eventid ,'"+newTrnId+"' ,transactiondate ,cardfee,ebeefee ,granddiscount ,tax ,"+
  "nettotal ,totalamount,grandtotal ,trackurl ,ticketurlcode ,eventdate ,context ,"+
  "totticketsqty,current_action,buyer_ntscode,nts_selected_action,nts_commission, referral_ntscode,currency_code,currency_conversion_factor,current_service_fee,collected_ticketqty,ebeefee_usd from event_reg_details_temp where tid=?";
DbUtil.executeUpdateQuery(regDetailsTempInsrtQry,new String [] {oldTrnId});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " event_reg_details_temp", "",null);

String regTicketsTempInsrtQry="insert into event_reg_ticket_details_temp(tid ,ticketid ,tickettype  ,qty ,originalprice ,originalfee ,discount ,finalprice ,ticketname ,finalfee ,ticketgroupid ,ticketgroupname ,eid,final_nts_commission,transaction_at )"+
"select  '"+newTrnId+"',ticketid ,tickettype  ,qty ,originalprice ,originalfee ,discount ,finalprice ,ticketname ,finalfee ,ticketgroupid ,ticketgroupname ,eid,final_nts_commission,transaction_at from event_reg_ticket_details_temp where tid=?";
DbUtil.executeUpdateQuery(regTicketsTempInsrtQry,new String [] {oldTrnId});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " event_reg_ticket_details_temp","", null);

//seats temp query

//String seatBlockSeatsTempQuery="insert into event_reg_block_seats_temp(blocked_at,transactionid,eventdate,ticketid,eventid,seatindex) select now(),'"+newTrnId+"',eventdate,ticketid,eventid,seatindex from event_reg_block_seats_temp where transactionid=?";
String seatBlockSeatsTempQuery="insert into event_reg_block_seats_temp(blocked_at,transactionid,eventdate,ticketid,eventid,seatindex) select to_timestamp('"+DateUtil.getCurrDBFormatDate()+"','YYYY-MM-DD HH24:MI:SS.MS'),'"+newTrnId+"',eventdate,ticketid,eventid,seatindex from event_reg_block_seats_temp where transactionid=?";
DbUtil.executeUpdateQuery(seatBlockSeatsTempQuery,new String [] {oldTrnId});
DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid=?",new String [] {oldTrnId});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " event_reg_block_seats_temp","", null);

//locked ticked temp tabel
//String lockedticketQuery="insert into event_reg_locked_tickets (locked_qty,locked_time,eventdate,tid,ticketid,eventid) select locked_qty,now(),eventdate,'"+newTrnId+"',ticketid,eventid from event_reg_locked_tickets where tid=?";
String lockedticketQuery="insert into event_reg_locked_tickets (locked_qty,locked_time,eventdate,tid,ticketid,eventid) select locked_qty,to_timestamp('"+DateUtil.getCurrDBFormatDate()+"','YYYY-MM-DD HH24:MI:SS.MS'),eventdate,'"+newTrnId+"',ticketid,eventid from event_reg_locked_tickets where tid=?";
DbUtil.executeUpdateQuery(lockedticketQuery,new String [] {oldTrnId});
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String [] {oldTrnId});

String customAttResMasterQry="insert into custom_questions_response_master (attribsetid,profilekey,created,status,"+
"transactionid,ref_id,subgroupid,groupid,profileid ) select attribsetid,?,created,status,"+
"?,?,subgroupid,groupid,CAST(? AS BIGINT) from custom_questions_response_master where profilekey=(select profilekey from buyer_base_info where transactionid=?)";
String customAttResponseQry="insert into custom_questions_response(optionval,attribid,created,ref_id,lastupdated,"+
"bigresponse,option_id,question_shortform,optiondisplay,shortresponse,question_original)  "+
"select optionval,attribid,created,?,lastupdated,"+
"bigresponse,option_id,question_shortform,optiondisplay,shortresponse,question_original "+
" from custom_questions_response where ref_id=(select ref_id from custom_questions_response_master "+
		"where profilekey=(select profilekey from buyer_base_info where transactionid=?))";
//new profileid,profile key
String profileid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
String profilekey="AK"+EncodeNum.encodeNum(profileid).toUpperCase();
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " New profileid and profilekey are "+profileid+"  "+profilekey ,"", null);

String buyerBaseInfoInsrtQry="insert into buyer_base_info(eventid ,fname ,lname ,transactionid ,phone ,email ,profilekey ,  profileid ,profilestatus, created_at )"+
"select eventid ,fname ,lname ,'"+newTrnId+"' ,phone ,email ,'"+profilekey+"' ,  "+profileid+" ,profilestatus,created_at from buyer_base_info "+
" where transactionid=?";
String newRefId=DbUtil.getVal("select nextval('attributes_survey_responseid') as refid",new String[]{});

StatusObj s=DbUtil.executeUpdateQuery(buyerBaseInfoInsrtQry,new String [] {oldTrnId});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " buyer_base_info insert status  "+s.getStatus()+"Error Msg"+s.getErrorMsg(),"", null);

s=DbUtil.executeUpdateQuery(customAttResMasterQry,new String [] {profilekey,newTrnId,newRefId,profileid,oldTrnId});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " customAttResMasterQry insert status  "+s.getStatus(),"", null);

s=DbUtil.executeUpdateQuery(customAttResponseQry,new String [] {newRefId,oldTrnId});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "precheck.jsp", " customAttResponseQry insert status  "+s.getStatus(),"", null);


String qry="select profilekey,profileid from profile_base_info  where transactionid=?";
DBManager dbmanager=new DBManager();
StatusObj statobj=null;
statobj=dbmanager.executeSelectQuery(qry,new String []{oldTrnId});
int count1=statobj.getCount();
//String profileBaseInsrtQry="insert into profile_base_info( eventid ,fname  ,lname  ,transactionid ,phone ,email ,profilekey ,ticketid ,tickettype ,profileid ,created_at,seatcode,seatindex )"+
//"select eventid ,fname  ,lname  , '"+newTrnId+"',phone ,email ,? ,ticketid ,tickettype ,? ,now(),seatcode,seatindex from profile_base_info where profilekey=?";
String profileBaseInsrtQry="insert into profile_base_info( eventid ,fname  ,lname  ,transactionid ,phone ,email ,profilekey ,ticketid ,tickettype ,profileid ,created_at,seatcode,seatindex,profile_setid)"+
"select eventid ,fname  ,lname  , '"+newTrnId+"',phone ,email ,? ,ticketid ,tickettype ,CAST(? AS INTEGER) ,to_timestamp('"+DateUtil.getCurrDBFormatDate()+"','YYYY-MM-DD HH24:MI:SS.MS'),seatcode,seatindex,CAST(? AS BIGINT) from profile_base_info where profilekey=?";
String customAttResMasterQry1="insert into custom_questions_response_master (attribsetid,profilekey,created,status,"+
"transactionid,ref_id,subgroupid,groupid,profileid ) select attribsetid,?,created,status,"+
"?,?,subgroupid,groupid,?::BIGINT from custom_questions_response_master where profilekey=?";
String customAttResponseQry1="insert into custom_questions_response(optionval,attribid,created,ref_id,lastupdated,"+
"bigresponse,option_id,question_shortform,optiondisplay,shortresponse,question_original)  "+
"select optionval,attribid,created,?,lastupdated,"+
"bigresponse,option_id,question_shortform,optiondisplay,shortresponse,question_original "+
" from custom_questions_response where ref_id=(select ref_id from custom_questions_response_master "+
		"where profilekey=?)";
if(statobj.getStatus() && count1>0){
for(int i=0;i<count1;i++){
String oldProfileKey=dbmanager.getValue(i,"profilekey","");
String newProfileId=DbUtil.getVal("select nextval('seq_attendeeId') as profileid",new String[]{});
newRefId=DbUtil.getVal("select nextval('attributes_survey_responseid') as refid",new String[]{});
String newProfileKey="AK"+EncodeNum.encodeNum(newProfileId).toUpperCase();
DbUtil.executeUpdateQuery(profileBaseInsrtQry,new String [] {newProfileKey,newProfileId,profileid,oldProfileKey});
DbUtil.executeUpdateQuery(customAttResMasterQry1,new String [] {newProfileKey,newTrnId,newRefId,newProfileId,oldProfileKey});
DbUtil.executeUpdateQuery(customAttResponseQry1,new String [] {newRefId,oldProfileKey});

}//End of for.
}//End of if block.
return newTrnId;
}
%>


<%
String status="";
String type="";
String newTrnId=request.getParameter("tid");
String trnId=request.getParameter("tid");
System.out.println("trnId"+trnId);
String eid1=request.getParameter("eid");
JSONObject obj=new JSONObject();
String qry="select paymentstatus,paymenttype from event_reg_transactions  where tid=?";
DBManager dbmanager=new DBManager();
StatusObj statobj=null;
statobj=dbmanager.executeSelectQuery(qry,new String []{trnId});
int count1=statobj.getCount();
if(statobj.getStatus() && count1>0){
status="Completed";
type=dbmanager.getValue(0,"paymenttype","");
}
else{
String isProcessedPaypal=DbUtil.getVal("select 'yes' from paypal_payment_backup_data  where ebee_tran_id=?",new String[]{trnId});
if("yes".equalsIgnoreCase(isProcessedPaypal)){
status="inProcess";
type="paypal";
}
else{

String isProcessedGoogle=DbUtil.getVal("select 'yes' from google_payment_backup_data  where transactionid=?",new String[]{trnId});
if("yes".equalsIgnoreCase(isProcessedGoogle)){
status="inProcess";
type="google";
}
else{
String isInPaypalData=DbUtil.getVal("select 'yes' from paypal_payment_data  where ebee_tran_id=?",new String[]{trnId});
// ebee_tran_id

if("yes".equalsIgnoreCase(isInPaypalData)){
//create a new transactionid and return it.
 newTrnId=createNewTrnId(trnId,eid1);
status="attempted";
type="paypal";

}
else{
String isInGoogleData=DbUtil.getVal("select 'yes' from google_payment_data  where ebee_tran_id=?",new String[]{trnId});
if("yes".equalsIgnoreCase(isInGoogleData)){
newTrnId=createNewTrnId(trnId,eid1);
status="attempted";
type="google";
}
else{
status="firstAttempt";
//submit form 
}
}
}
}

}
System.out.println("status in precheck.jsp"+status);
System.out.println("new TrnID in precheck.jsp"+newTrnId);
if("completed".equalsIgnoreCase(status)){

%>
<div id='paypalcontent'>Your transaction is already Completed.<a href='#' onClick="cancelRedirect();"> Click here to close the window</a> </div>
<%
return;
}
if("inProcess".equalsIgnoreCase(status)){
%>
<div id='paypalcontent'>Your transaction is in process.<a href='#' onClick="cancelRedirect();"> Click here to close the window</a> </div>
<%
return;
}
if("attempted".equalsIgnoreCase(status)){
%>

<%
}
%>
