<%@ page import="java.io.*,java.util.*,java.sql.Timestamp,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*,com.eventbee.event.ticketinfo.*" %>
<%@ page import="org.json.JSONObject"%>

<%!
ArrayList getQuestionsFortheTransactionlevel(String eventid){
String query="select attribid from buyer_custom_questions where eventid=CAST(? AS BIGINT)";
ArrayList attribsList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{eventid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
attribsList.add(db.getValue(i,"attribid",""));
}
}
return attribsList;
}
String responsetype;
final String GET_TRANSACTION_ID_QUERY = "select nextval('seq_transactionid') as transactionid";
	
public String getTransactionId(String pattern){
 	String transid=DbUtil.getVal(GET_TRANSACTION_ID_QUERY,new String[]{});
	String transactionid=pattern+EncodeNum.encodeNum(transid).toUpperCase();
	return transactionid;
	}

public String Insertpromotiontypequery="insert into promotion_mail_list (eid,attrib1,attrib2,fname,lname,email,created_at) values (CAST(? AS BIGINT),?,?,?,?,?,now())";

String InsertEventregTransaction(HashMap attendeeMap,String pattern,HttpServletRequest req,String promotiontype){
		
		String eventdate=(String)attendeeMap.get("eventdate");
		String transid=(String)attendeeMap.get("transid");
		String trackcode=(String)attendeeMap.get("trackcode");
		if("null".equals(eventdate)){
			eventdate="";
		}
		System.out.println("trackcode:"+trackcode);
		if(!"null".equals(trackcode)){
			String track_query="insert into trackurl_transaction(transactionid,trackingcode,accesstime) values (?,?,now())";
			DbUtil.executeUpdateQuery(track_query,new String[]{transid,trackcode});
		}
String event_closed_date="";
if(eventdate!=null&&!"".equals(eventdate)){
	String close_datequery="select est_enddate from event_dates where  date_display=?   and eventid=CAST(? AS BIGINT)";
	event_closed_date=DbUtil.getVal(close_datequery, new String[]{eventdate,(String)attendeeMap.get("eventid")});
	System.out.println("event_closed_date: "+event_closed_date);
}
else{
	String close_datequery="select end_date from eventinfo where eventid=CAST(? AS BIGINT)";
	event_closed_date=DbUtil.getVal(close_datequery, new String[]{(String)attendeeMap.get("eventid")});
}

final String ORDER_SEQ="select sequence+1 from transaction_sequence where groupid=? and grouptype=?";
final String ORDER_SEQ_INSERT="insert into transaction_sequence (groupid,sequence,grouptype) values(?,CAST(? AS INTEGER),'EVENT')";
final String ORDER_SEQ_UPDATE="update transaction_sequence set sequence=CAST(? AS INTEGER) where groupid=?";

String orderseq=DbUtil.getVal(ORDER_SEQ,new String []{(String)attendeeMap.get("eventid"),"EVENT"});
if(orderseq==null){
	orderseq="10000200";
	DbUtil.executeUpdateQuery(ORDER_SEQ_INSERT,new String[]{(String)attendeeMap.get("eventid"),orderseq});
}
else{
	StatusObj statobj=DbUtil.executeUpdateQuery(ORDER_SEQ_UPDATE,new String[]{orderseq,(String)attendeeMap.get("eventid")});
}

String query="insert into event_reg_transactions(ordernumber,tid,bookingsource,paymentstatus,transaction_date,paymenttype,fname,lname,email,phone,eventid,bookingdomain,eventdate,trackpartner,event_closed_date) values(?,?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,?,?,?,?,?,?,?)";
DbUtil.executeUpdateQuery(query,new String[]{orderseq,transid,"online","Completed",DateUtil.getCurrDBFormatDate(),"RSVP",(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),(String)attendeeMap.get("email"),(String)attendeeMap.get("phone"),(String)attendeeMap.get("eventid"),"EB",eventdate,trackcode,event_closed_date});


/* String query="insert into event_reg_transactions(tid,bookingsource,paymentstatus,transaction_date,paymenttype,fname,lname,email,phone,eventid,bookingdomain,eventdate,trackpartner,event_closed_date) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,?,?,?,?,?,?,?)";
DbUtil.executeUpdateQuery(query,new String[]{transid,"online","Completed",DateUtil.getCurrDBFormatDate(),"RSVP",(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),(String)attendeeMap.get("email"),(String)attendeeMap.get("phone"),(String)attendeeMap.get("eventid"),"EB",eventdate,trackcode,event_closed_date}); */

String transactionTicketquery="insert into transaction_tickets(ticketid,ticketname,ticketqty,tid,eventid) values (CAST(? AS BIGINT),?,CAST(? AS INTEGER),?,?)";
String opt=(String)attendeeMap.get("option");

String sure=null,notsure=null;
if("no".equals(opt)){
	responsetype="N";
	sure="0";
	notsure="0";
DbUtil.executeUpdateQuery(transactionTicketquery,new String[]{"100","Not Attending","1",transid,(String)attendeeMap.get("eventid")});
}
else{
	RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
	HashMap<String,String> ebeefeeMap=regtktmgr.getEbeeFee((String)attendeeMap.get("eventid"));
	String ebeefee=ebeefeeMap.get("finalebeefee");
	String ebeefee_USD=ebeefeeMap.get("ebeefee_usd");
	double serviceFee=0,surecount=0,notsurecount=0,totalcount=0,servicefee_usd=0;
	responsetype="Y";
	sure=req.getParameter("sure");
	notsure=req.getParameter("notsure");
	if(!"0".equals(sure)){
	DbUtil.executeUpdateQuery(transactionTicketquery,new String[]{"101","Attending",sure,transid,(String)attendeeMap.get("eventid")});
	try{
		surecount=Double.parseDouble(sure);
	}
	catch(Exception e){
		surecount=0;
	}
	}
	if(!"0".equals(notsure)){
	DbUtil.executeUpdateQuery(transactionTicketquery,new String[]{"102","Maybe",notsure,transid,(String)attendeeMap.get("eventid")});
	try{
		notsurecount=Double.parseDouble(notsure);
	}
	catch(Exception e){
		notsurecount=0;
	}
	}
	totalcount=surecount+notsurecount;
	serviceFee=(totalcount)*(Double.parseDouble(ebeefee));
	servicefee_usd=(totalcount)*(Double.parseDouble(ebeefee_USD));
	String mgrId=DbUtil.getVal("select mgr_id from eventinfo where eventid=?::integer", new String[]{(String)attendeeMap.get("eventid")});
	Double amount_we_have=0.00-serviceFee;
	DbUtil.executeUpdateQuery("update event_reg_transactions set servicefee=CAST(? AS NUMERIC),ebeefee_usd=?::NUMERIC,currency_code='USD',collected_ticketqty=?::NUMERIC,actual_ticketqty=?::NUMERIC,currency_conversion_factor=?::BIGINT,amount_we_have=?  where tid=?",new String[]{serviceFee+"",servicefee_usd+"",totalcount+"",totalcount+"",ebeefeeMap.get("conv_factor"),amount_we_have+"",transid});
	String iscollected=DbUtil.getVal("select 'yes' from mgr_credits_usage_history where tid=?", new String[]{transid});
	if(!"yes".equals(iscollected)){
		String avail=DbUtil.getVal("select 'yes' from mgr_available_credits where mgr_id=?::BIGINT and available_credits>=?::NUMERIC", new String[]{mgrId,servicefee_usd+""});
		if("yes".equals(avail) && !"yes".equals(iscollected)){
			DbUtil.executeUpdateQuery("update mgr_available_credits set used_credits=used_credits+?::NUMERIC where mgr_id=?::BIGINT", new String[]{servicefee_usd+"",mgrId});
			DbUtil.executeUpdateQuery("update mgr_available_credits set available_credits=total_credits-used_credits,updated_by='registration',last_updated_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where mgr_id=?::BIGINT", new String[]{DateUtil.getCurrDBFormatDate(),mgrId});
			DbUtil.executeUpdateQuery("insert into mgr_credits_usage_history(mgr_id,used_for_eventid,used_credits,tid,used_date) values(?::BIGINT,?::BIGINT,?::NUMERIC,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))", new String[]{mgrId,(String)attendeeMap.get("eventid"),servicefee_usd+"",transid,DateUtil.getCurrDBFormatDate()});
			DbUtil.executeUpdateQuery("update event_reg_transactions set collected_servicefee=?::NUMERIC,collected_by='beecredits' where tid=?", new String[]{serviceFee+"",transid});
			DbUtil.executeUpdateQuery("update event_reg_transactions set amount_we_have=amount_we_have::NUMERIC+collected_servicefee where tid=?", new String[]{transid});
		}
	}
}

String rsvp_transaction_query="insert into rsvp_transactions (eventid,tid,tdate,fname,lname,email,phone,tkey,responsetype,yescount,notsurecount) values (?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,?,?,?,CAST(? AS INTEGER),CAST(? AS INTEGER))";

DbUtil.executeUpdateQuery(rsvp_transaction_query,new String[]{(String)attendeeMap.get("eventid"),transid,DateUtil.getCurrDBFormatDate(),(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),(String)attendeeMap.get("email"),(String)attendeeMap.get("phone"),transid,responsetype,sure,notsure});


String InsertbuyerInfoquery="insert into buyer_base_info (eventid,fname,lname,transactionid,phone,email,profilekey,profileid) values (CAST(? AS BIGINT),?,?,?,?,?,?,CAST(? AS INTEGER))";

DbUtil.executeUpdateQuery(InsertbuyerInfoquery,new String[]{(String)attendeeMap.get("eventid"),(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),transid,(String)attendeeMap.get("phone"),(String)attendeeMap.get("email"),(String)attendeeMap.get("profilekey"),(String)attendeeMap.get("attendeeid")});
if("".equals(promotiontype)){
DbUtil.executeUpdateQuery(Insertpromotiontypequery,new String[]{(String)attendeeMap.get("eventid"),(String)attendeeMap.get("transid"),"",(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),(String)attendeeMap.get("email")});
	}

return orderseq;
}
void fillTransactionLevelQuestions(CustomAttribute[] attributeSet,ArrayList attribsList,ProfileActionDB profiledbaction,HttpServletRequest req,String attendeeid,String attribsetid,String eventid,String profilekey,String transid){
	if(attributeSet!=null&&attributeSet.length>0){
	String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
	HashMap responseMasterMap=new HashMap();
	responseMasterMap.put("responseid",responseId);
	responseMasterMap.put("tid",transid);
	responseMasterMap.put("eventid",eventid);
	responseMasterMap.put("profileid",attendeeid);
	responseMasterMap.put("profilekey",profilekey);
	responseMasterMap.put("ticketid","0");
	responseMasterMap.put("custom_setid",attribsetid);
	profiledbaction.InsertResponseMaster(responseMasterMap);
	String shortresponse=null;
	String bigresponse=null;
	
	for(int j=0;j<attributeSet.length;j++){
        shortresponse=null;
		bigresponse=null;
        CustomAttribute cb=(CustomAttribute)attributeSet[j];
		if(attribsList.contains(cb.getAttribId())){
			String questionid=cb.getAttribId();
			
			String question=cb.getAttributeName();
			String type=cb.getAttributeType();
			ArrayList options=cb.getOptions();
			if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
				String responses[]=req.getParameterValues("q_p_"+questionid);
				if(responses!=null){
				String responsesVal[]=profiledbaction.getOptionVal(options,responses);
				shortresponse=GenUtil.stringArrayToStr(responses,",");
				bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
				}
			}
		else{
			shortresponse=req.getParameter("q_p_"+questionid);
			bigresponse=req.getParameter("q_p_"+questionid);
			
		}
		HashMap userResponse=new HashMap();
		userResponse.put("question",question);
		userResponse.put("questionid",questionid);
		userResponse.put("shortresponse",shortresponse);
		userResponse.put("bigresponse",bigresponse);
		userResponse.put("responseid",responseId);
		if(bigresponse!=null && !"".equals(bigresponse.trim()))
		profiledbaction.insertResponse(userResponse);


	  }
	}
  }	
}


void fillResponseLevelQuestions(CustomAttribute[] attributeSet,ArrayList attribsList,ProfileActionDB profiledbaction,HttpServletRequest req,String attribsetid,String eventid,String pattern,int count,String transid,String promotiontype){
	String ticketid="102";
	if("q_s_".equals(pattern)){
		ticketid="101";
	}

	String Insertprofile_base_info_query="insert into profile_base_info(eventid,fname,lname,transactionid,phone,email,profilekey,ticketid,tickettype,profileid,created_at) values (CAST(? AS BIGINT),?,?,?,?,?,?,CAST(? AS BIGINT),?,CAST(? AS INTEGER),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";

	for(int i=1;i<=count;i++){
		String attendeeid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
	String profilekey="AK"+EncodeNum.encodeNum(attendeeid).toUpperCase();
		String firstname=req.getParameter(pattern+"fname_"+i);
		String lastname=req.getParameter(pattern+"lname_"+i);
		String phone=req.getParameter(pattern+"phone_"+i);
		String email=req.getParameter(pattern+"email_"+i);
		
		HashMap insert_mail_list=new HashMap();
		insert_mail_list.put("fname",firstname);
		insert_mail_list.put("lname",lastname);
		insert_mail_list.put("email",email);
		RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
		regdbhelper.InserMailingList(eventid,insert_mail_list);
	DbUtil.executeUpdateQuery(Insertprofile_base_info_query,new String[]{eventid,firstname,lastname,transid,phone,email,profilekey,ticketid,"attendeeType",attendeeid,DateUtil.getCurrDBFormatDate()});
	if("".equals(promotiontype)){
		
		if(!"".equals(email) || email != null){
			
			DbUtil.executeUpdateQuery(Insertpromotiontypequery,new String[]{eventid,transid,profilekey,firstname,lastname,email});
		}
	}
	if(attributeSet!=null&&attributeSet.length>0){
	String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
	HashMap rsvpAttendee=new HashMap();
	HashMap responseMasterMap=new HashMap();
	responseMasterMap.put("responseid",responseId);
	responseMasterMap.put("tid",transid);
	responseMasterMap.put("eventid",eventid);
	responseMasterMap.put("profileid",attendeeid);
	responseMasterMap.put("profilekey",profilekey);
	responseMasterMap.put("ticketid",ticketid);
	responseMasterMap.put("custom_setid",attribsetid);
	profiledbaction.InsertResponseMaster(responseMasterMap);

	String shortresponse=null;
	String bigresponse=null;
	
	for(int j=0;j<attributeSet.length;j++){
        shortresponse=null;
		bigresponse=null;
        CustomAttribute cb=(CustomAttribute)attributeSet[j];
		if(attribsList.contains(cb.getAttribId())){
			String questionid=cb.getAttribId();
			
			String question=cb.getAttributeName();
			String type=cb.getAttributeType();
			ArrayList options=cb.getOptions();
			if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
				String responses[]=req.getParameterValues(pattern+questionid+"_"+i);
				if(responses!=null){
				String responsesVal[]=profiledbaction.getOptionVal(options,responses);
				shortresponse=GenUtil.stringArrayToStr(responses,",");
				bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
				}
			}
		else{
			shortresponse=req.getParameter(pattern+questionid+"_"+i);
			bigresponse=req.getParameter(pattern+questionid+"_"+i);

		}
		
		HashMap userResponse=new HashMap();
		userResponse.put("question",question);
		userResponse.put("questionid",questionid);
		userResponse.put("shortresponse",shortresponse);
		userResponse.put("bigresponse",bigresponse);
		userResponse.put("responseid",responseId);
		if(bigresponse!=null && !"".equals(bigresponse.trim()))
		//System.out.println(userResponse);
		profiledbaction.insertResponse(userResponse);


	  }
	}
	}
  }	
}
%>

<%!
ArrayList getQuestionsFortheSelectedOption(String option,String eventid){

String query="select attribid from subgroupattribs where groupid=CAST(? AS BIGINT) and subgroupid=CAST(? AS INTEGER)";
ArrayList attribsList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,option});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
attribsList.add(db.getValue(i,"attribid",""));
}
}
System.out.println("attriblist:"+attribsList);
return attribsList;
}
Boolean checkstatus(String sure,String notsure,String selectedOption,String eventid,String rsvpdate){
	if("yes".equals(selectedOption)){
		HashMap completedcount=new HashMap();
		int limit=0;
		int count=0;
		completedcount=getcompletedcount(eventid);
		
		limit=Integer.parseInt(completedcount.get("rsvplimitallowed").toString());
		if(rsvpdate == null){
			count=Integer.parseInt(completedcount.get("attendeecount").toString());
		}
		else{
			count=getrecurringrsvpcount(eventid,rsvpdate);
		}

		if(limit == 0){
			limit=100000000;
		}
		if(count<limit){
			int availablecount=limit-count;
			int selectedcount=Integer.parseInt(sure)+Integer.parseInt(notsure);
			if(selectedcount>availablecount){
				return false;
			}
			else{
				return true;
			}
		}
		else{
			return false;
		}
	}
	else{
		return true;
	}
}

HashMap getcompletedcount(String eventid){
		String rsvplimitallowed=DbUtil.getVal("select totallimit from rsvp_settings where eventid=?",new String[]{eventid});
		
		if(rsvplimitallowed == null){
			rsvplimitallowed = "0";
		}
		String surecomcount=DbUtil.getVal("select sum(yescount) from rsvp_transactions where eventid=?",new String[]{eventid});
		if(surecomcount == null){
			surecomcount = "0";
		}
		String notsurecomcount=DbUtil.getVal("select sum(notsurecount) from rsvp_transactions where eventid=?",new String[]{eventid});
		if(notsurecomcount == null){
			notsurecomcount = "0";
		}
		
		int attendeecount=Integer.parseInt(surecomcount)+Integer.parseInt(notsurecomcount);
		HashMap count=new HashMap();
		count.put("attendeecount",attendeecount);
		count.put("rsvplimitallowed",rsvplimitallowed);
		return count;
}

int getrecurringrsvpcount(String eventid,String rsvpdate){
	String sure=DbUtil.getVal("select sum(yescount) from rsvp_transactions where eventid=? and tid in(select tid from event_reg_transactions where eventid=? and eventdate=?)",new String[]{eventid,eventid,rsvpdate});
	if(sure == null){
		sure="0";
	}
	String notsure=DbUtil.getVal("select sum(notsurecount) from rsvp_transactions where eventid=? and tid in(select tid from event_reg_transactions where eventid=? and eventdate=?)",new String[]{eventid,eventid,rsvpdate});
	if(notsure == null){
		notsure ="0";
	}
	int count=Integer.parseInt(sure)+Integer.parseInt(notsure);

	return count;
}
%>


<%
boolean status=true;
String Msg="";
String orderNumber="";
JSONObject obj=new JSONObject();
String eventid=request.getParameter("eventid");
String option=request.getParameter("selectedoption");
System.out.println("option: "+option);
String rec_event_date=request.getParameter("rsvp_event_date");
String promotiontype=request.getParameter("enablepromotion");
String trackcode=request.getParameter("trackcode");
String surecount="0",notsurecount="0";
if("no".equals(option)){
	System.out.println("nooo");
}
else{
 surecount=request.getParameter("sure");
 notsurecount=request.getParameter("notsure");
}

Boolean rsvpstatus=checkstatus(surecount,notsurecount,option,eventid,rec_event_date);

if(rsvpstatus==false){

obj.put("Available","NO");
}
else{

String attribsetid=request.getParameter("attribsetid");
String transid="";

ProfileActionDB profiledbaction=new ProfileActionDB();
ArrayList sureattribsList=getQuestionsFortheSelectedOption("101",eventid);
ArrayList notsureattribsList=getQuestionsFortheSelectedOption("102",eventid);

ArrayList attribsList=getQuestionsFortheTransactionlevel(eventid);
CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eventid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
HashMap rsvpAttendee=new HashMap();
try{
	String sfirstname,slastname;
String firstname=request.getParameter("q_p_fname");
String lastname=request.getParameter("q_p_lname");
String email=request.getParameter("q_p_email");
String phone=request.getParameter("q_p_phone");
rec_event_date=request.getParameter("rsvp_event_date");
if("yes".equals(option)){
	if(!"0".equals(surecount)){
		firstname=request.getParameter("q_s_fname_1");
		lastname=request.getParameter("q_s_lname_1");
		email=request.getParameter("q_s_email_1");
			
	}
	if(!"0".equals(notsurecount)){
		firstname=request.getParameter("q_ns_fname_1");
		lastname=request.getParameter("q_ns_lname_1");
		email=request.getParameter("q_ns_email_1");
			
	}

}
Msg="Thank you, your RSVP information is sent to the Event Manager";
String attendeeid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
String profilekey="PK"+EncodeNum.encodeNum(attendeeid).toUpperCase();
transid=getTransactionId("RK");

rsvpAttendee.put("fname",firstname);
rsvpAttendee.put("lname",lastname);
rsvpAttendee.put("email",email);
rsvpAttendee.put("emailid",email);
rsvpAttendee.put("phone",phone);
rsvpAttendee.put("attendeeid",attendeeid);
rsvpAttendee.put("eventid",eventid);
rsvpAttendee.put("GROUPID",eventid);
rsvpAttendee.put("attending",option);
rsvpAttendee.put("eventdate",rec_event_date);
rsvpAttendee.put("option",option);
rsvpAttendee.put("profilekey",profilekey);
rsvpAttendee.put("transid",transid);
rsvpAttendee.put("trackcode",trackcode);
//profiledbaction.InsertAttendeeInfo(rsvpAttendee);

orderNumber=InsertEventregTransaction(rsvpAttendee,"RK",request,promotiontype);
System.out.println("In RSVP Order Number:"+orderNumber);
fillTransactionLevelQuestions(attributeSet,attribsList,profiledbaction,request,attendeeid,attribsetid,eventid,profilekey,transid);
	
if("no".equals(option)){
	
}
else{
int sureattend=Integer.parseInt(request.getParameter("sure"));
int notsureattend=Integer.parseInt(request.getParameter("notsure"));

	fillResponseLevelQuestions(attributeSet,sureattribsList,profiledbaction,request,attribsetid,eventid,"q_s_",sureattend,transid,promotiontype);
	
	fillResponseLevelQuestions(attributeSet,notsureattribsList,profiledbaction,request,attribsetid,eventid,"q_ns_",notsureattend,transid,promotiontype);

	
}
}
catch(Exception e){
status=false;
System.out.println("Exception In RSVP PROFILE SUBMISSION"+e.getMessage());
}
if(status){
obj.put("Status","Success");
obj.put("Msg",Msg);
obj.put("responsetype",responsetype);
obj.put("transactionid",transid);
obj.put("emailid",rsvpAttendee.get("emailid"));
obj.put("Available","YES");
obj.put("ordernumber",orderNumber);

}
else
obj.put("Status","Fail");
}


out.print(obj.toString());

System.out.println(obj.toString());
%>



