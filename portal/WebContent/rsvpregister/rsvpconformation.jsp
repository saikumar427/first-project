<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventbee.event.ticketinfo.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.eventbee.layout.DBHelper" %>
<%@ page import="com.event.i18n.dbmanager.ConfirmationPageDAO" %>
<%@ include file='/globalprops.jsp' %>
<%!
static String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
public class GetTicketsThread implements Runnable{
	HashMap paramMap=new HashMap();
	public GetTicketsThread(HashMap hm) {  
		paramMap = hm;  
    }
	public void run() {
		try{
			com.eventbee.util.CoreConnector cc1=new com.eventbee.util.CoreConnector(com.eventbee.general.EbeeConstantsF.get("CONNECTING_PDF_URL",serveraddress+"/attendee/utiltools/sendPdfMail.jsp"));
			cc1.setArguments(paramMap);
		    cc1.setTimeout(30000);
		    String st=cc1.MGet();
		}catch(Exception e){
			System.out.println("Error in GetTicketsThread: "+e.getMessage());
		}
	}

}
 static String[] fillData(HashMap hm,String eventid,EmailTemplate emailtemplate,VelocityContext context){
//EventTicketDB edb=new EventTicketDB();
//HashMap evtmap=new HashMap();
//StatusObj sobj=edb.getEventInfo(eventid,evtmap);
String eventurl=null;
eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{eventid});
if(eventurl==null){
eventurl=serveraddress+"/event?eid="+eventid;
}

String urllink=eventurl;
HashMap attendeemap=new HashMap();
attendeemap.put("firstName",GenUtil.XMLEncode((String)context.get("fname")));
attendeemap.put("lastName",GenUtil.XMLEncode((String)context.get("lname")));
attendeemap.put("email",GenUtil.XMLEncode((String)context.get("emailid"))) ;

context.put("eventURL",urllink);

String mailtype="";
String mailcontent=emailtemplate.getHtmlFormat();
if(mailcontent==null||"".equals(mailcontent)){
mailcontent=emailtemplate.getTextFormat();
mailtype="Text";
}
else{
mailtype="Html";
}
String message=getVelocityOutPut(context,mailcontent);
String frommail=(String)hm.get("m_email");
String subject=getVelocityOutPut(context,emailtemplate.getSubjectFormat());
return new String[]{message,frommail,subject,mailtype};
		}
static String getVelocityOutPut(VelocityContext vc,String Template){
StringBuffer str=new StringBuffer();
java.io.StringWriter out1=new java.io.StringWriter();
VelocityEngine ve= new VelocityEngine();
try{
ve.init();
boolean abletopares=ve.evaluate(vc,out1,"ebeetemplate",Template );
str=out1.getBuffer();
}
catch(Exception e){
System.out.println(e.getMessage());
}
return str.toString();
}
public static int sendRsvpEmail(HashMap hmap,VelocityContext context){
    String eventid=(String) hmap.get("GROUPID");

    int status=0;
	try{
		EmailTemplate emailtemplate=null;
		String isformatexists=DbUtil.getVal("select 'yes' from email_templates where purpose='RSVP_CONFIRMATION' and groupid=?", new String []{eventid});
		if("yes".equals(isformatexists)){
			emailtemplate=new EmailTemplate("13579","RSVP_CONFIRMATION",eventid);
		}else{
			emailtemplate=new EmailTemplate("100","RSVP_CONFIRMATION");
		}
		
       	EmailObj obj=EventbeeMail.getEmailObj();
		String tomail=(String)hmap.get("emailid");
		String mailbcc=EbeeConstantsF.get("ADMIN_EMAIL","sridevi@beeport.com") ;
		if(!"no".equals(hmap.get("mailtoattendee"))){
			obj.setTo(tomail);
		}	
		else{
			obj.setTo(EbeeConstantsF.get("ADMIN_EMAIL","sridevi@beeport.com"));
			mailbcc="";
		}
		String[] formatmessage=fillData(hmap,eventid,emailtemplate,context);
		String emailtype=formatmessage[3];
		
		if(!"no".equals(hmap.get("mailtomgr"))){
			if(!"".equals(mailbcc))
				mailbcc+=","+formatmessage[1];
			else	
				mailbcc+=formatmessage[1];
		}
		if(!"".equals(hmap.get("mailbcc"))){
			if(!"".equals(mailbcc))
				mailbcc+=","+(String)hmap.get("mailbcc");
			else	
				mailbcc+=(String)hmap.get("mailbcc");
		}	
		obj.setBcc(mailbcc);
		//obj.setBcc(formatmessage[1]+","+EbeeConstantsF.get("ADMIN_EMAIL","sridevi@beeport.com") );
		
		obj.setFrom(formatmessage[1]);
		obj.setSubject(formatmessage[2]);
		obj.setSendMailStatus(new SendMailStatus("13579","RSVP_CONFIRMATION",eventid,"1"));
		if("Html".equals(emailtype)){
			obj.setHtmlMessage(formatmessage[0]);
			//EventbeeMail.sendHtmlMail(obj);
			EventbeeMail.sendHtmlMailPlain(obj);
			EventbeeMail.insertStrayEmail(obj, "html", "S");
		}
		else if("Text".equals(emailtype)){
			obj.setTextMessage(formatmessage[0]);
			//EventbeeMail.sendTextMail(obj);
			EventbeeMail.sendTextMailPlain(obj);
			EventbeeMail.insertStrayEmail(obj, "text", "S");
		}
		status=1;
	}
	catch(Exception e){
		status=0;
	}
	return status;

}



%>

<%!

void getdetails(String tid,String eid,VelocityContext context,String sure,String notsure){
EventTicketDB edb=new EventTicketDB();
RegistrationDBHelper regdb=new RegistrationDBHelper();
/*HashMap customquestions=new HashMap();
	String showcustomquestions=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=to_number(?,'999999999')) and name='event.confirmationscreen.questions.show'", new String[]{eid});
	if("Y".equals(showcustomquestions))
		customquestions=regdb.getCustomQuestions(eid,tid);*/
TicketsDB tktdb=new TicketsDB();
HashMap configMap = tktdb.getConfigValuesFromDb(eid);
HashMap evtmap=new HashMap();
StatusObj sobj=edb.getEventInfo(eid,evtmap);
String startday,endday;
startday=(String)evtmap.get("StartDate_Day");

endday=(String)evtmap.get("EndDate_Day");
String starttime=(String)evtmap.get("STARTTIME");

String endtime=(String)evtmap.get("ENDTIME");
String venue=(String)evtmap.get("VENUE");
String location=(String)evtmap.get("LOCATION");
String fname="";
String lname="";
/*HashMap attendeeDetails=new HashMap();
HashMap notSureDetails=new HashMap();*/
HashMap buyerdetails=null;
buyerdetails=regdb.getBuyerInfo(tid,eid);
/*String getprofiledetailsquery="select fname,lname,profilekey from profile_base_info where eventid=to_number(?,'9999999999999') and transactionid=? and ticketid=to_number(?,'9999999999999')";
DBManager db=new DBManager();
if(Integer.parseInt(sure)>0){
	StatusObj profilesb=db.executeSelectQuery(getprofiledetailsquery,new String[]{eid,tid,"101"});
	
	if(profilesb.getStatus()){
		for(int i=0;i<profilesb.getCount();i++){
			attendeeDetails.put("fname_"+i,db.getValue(i,"fname",""));
			attendeeDetails.put("lname_"+i,db.getValue(i,"lname",""));
			attendeeDetails.put("pkey_"+i,db.getValue(i,"profilekey",""));
			String pkey=db.getValue(i,"profilekey","");
			String custquestion=regdb.getCustQuestionsResponse(pkey, customquestions);
			if(!"".equals("custquestion"))attendeeDetails.put("customQuestion_"+i, custquestion);

		
		}

		context.put("attendeeDetails",attendeeDetails);
	}
}
if(Integer.parseInt(notsure)>0){
	StatusObj profilesb=db.executeSelectQuery(getprofiledetailsquery,new String[]{eid,tid,"102"});
	if(profilesb.getStatus()){
		for(int i=0;i<profilesb.getCount();i++){
			notSureDetails.put("fname_"+i,db.getValue(i,"fname",""));
			notSureDetails.put("lname_"+i,db.getValue(i,"lname",""));
			notSureDetails.put("pkey_"+i,db.getValue(i,"profilekey",""));
			String pkey=db.getValue(i,"profilekey","");
			String custquestion=regdb.getCustQuestionsResponse(pkey, customquestions);
			if(!"".equals("custquestion"))notSureDetails.put("customQuestion_"+i, custquestion);

		}
		
		context.put("notSureDetails",notSureDetails);
	}
}
HashMap codersvp=new HashMap();
codersvp=getrsvpbarcode(eid,tid,sure,attendeeDetails,context,"a");
context.put("attendingCode",codersvp);

codersvp=getrsvpbarcode(eid,tid,notsure,notSureDetails,context,"ns");
context.put("notSureCode",codersvp);*/

String qrcodeoption=(String)configMap.get("confirmationpage.qrcodes");

if(qrcodeoption==null||"".equals(qrcodeoption))
qrcodeoption="Attendee";
//ArrayList purchasedTickets=regdb.getConfirmationTicketDetails(tid,eid);
ArrayList profileInfo=regdb.getProfileInfo(tid,eid);
//HashMap ticketsdetails=regmgr.getTicketDetails(eid);
if(profileInfo!=null&&profileInfo.size()>0){
	try{
		for(int i=0;i<profileInfo.size();i++){
			
			HashMap profile=(HashMap)profileInfo.get(i);
			//String ticketid=(String)profile.get("ticketid");
			String profilekey=(String)profile.get("profilekey");
			fname=(String)profile.get("fname");
			lname=(String)profile.get("lname");
			if("".equals(fname)){
				fname=(String)buyerdetails.get("fname");
				lname=(String)buyerdetails.get("lname");
			}
			
			context.put("startDay",startday);
			context.put("endDay",endday);
			context.put("startTime",starttime);
			context.put("endTime",endtime);
			context.put("venue",venue);
			context.put("location",location);
			context.put("eventName",(String)evtmap.get("EVENTNAME"));
			context.put("mgrFirstName",(String)evtmap.get("FIRSTNAME"));
			context.put("mgrLastName",(String)evtmap.get("LASTNAME"));
			context.put("mgrEmail",(String)evtmap.get("EMAIL"));
			context.put("mgrPhone",GenUtil.getHMvalue(evtmap,"PHONE"));
			context.put("registrantDetails",buyerdetails);
		}
	}
	catch(Exception e){
		System.out.println(e);
	}
  }
}



HashMap getrsvpbarcode(String eid,String tid,String count,HashMap details,VelocityContext context,String pattern){
	RegistrationDBHelper regdb=new RegistrationDBHelper();
	HashMap qr_barcodemsg=regdb.getQrCodeBarCode(eid);
	
	HashMap barcodersvp=new HashMap();
	try{
		
	if(Integer.parseInt(count)>0){
		JSONObject obj=new JSONObject();
		
		obj.put("eid",eid);
		obj.put("xid",tid);
		for(int i=0;i<Integer.parseInt(count);i++){
			obj.put("pkey",details.get("pkey_"+i));
			obj.put("fn",details.get("fname_"+i));
			obj.put("ln",details.get("lname_"+i));
			obj.put("tId","101");
			String qstring=obj.toString();
			String qrcode="",vbarcode="",hbarcode="";
				qrcode=(String)qr_barcodemsg.get("qrcode");
				vbarcode=(String)qr_barcodemsg.get("vbarcode");
				hbarcode=(String)qr_barcodemsg.get("hbarcode");
			try{
				
				String qr[]=qrcode.split("#msg");
				qrcode=qr[0]+java.net.URLEncoder.encode(qstring)+qr[1];
				String vbar[]=vbarcode.split("#msg");
				vbarcode=vbar[0]+obj.get("pkey")+vbar[1];
				String hbar[]=hbarcode.split("#msg");
				hbarcode=hbar[0]+obj.get("pkey")+hbar[1];
				String vserver[]=vbarcode.split("#serveraddress");
				vbarcode=vserver[0]+serveraddress+vserver[1];
				String hserver[]=hbarcode.split("#serveraddress");
				hbarcode=hserver[0]+serveraddress+hserver[1];
				
			}catch(Exception e){System.out.println("exception in try is :"+e.getMessage());}
						
			barcodersvp.put(pattern+"_qrCode_"+i,qrcode);
			barcodersvp.put(pattern+"_barCode128_"+i,hbarcode);
			barcodersvp.put(pattern+"_vBarCode128_"+i,vbarcode);
			//barcodersvp.put(pattern+"_qrCode_"+i,"<img src='http://chart.apis.google.com/chart?cht=qr&chs=100x100&chl="+java.net.URLEncoder.encode(qstring)+"'/>");
			//barcodersvp.put(pattern+"_barCode128_"+i,"<img width='200px' src='"+serveraddress+"/genbc?type=code128&msg="+obj.get("pkey")+"&height=0.75cm&hrsize=6pt&hrp=bottom&fmt=gif'>");
		}
		
		
	}
	
	}
	catch(Exception e){
		System.out.println("exception is"+e);
	}
	
	return barcodersvp;
}
void getQuestionsBarCode(String transactionid,String eventid,VelocityContext context,String sure,String notsure,String confirmationtype){
   RegistrationDBHelper regdb=new RegistrationDBHelper(confirmationtype);
   HashMap customquestions=new HashMap();
   HashMap attendeeDetails=new HashMap();
   HashMap notSureDetails=new HashMap();
   HashMap buyercustomquestions=new HashMap();
   String showcustomquestions="";
   if("confirmation_email".equals(confirmationtype)){
      showcustomquestions=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=CAST(? AS BIGINT)) and name='event.confirmationemail.questions.show'", new String[]{eventid});
   }else{
      showcustomquestions=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=CAST(? AS BIGINT)) and name='event.confirmationpage.questions.show'", new String[]{eventid});
   }
   
   if("Y".equalsIgnoreCase(showcustomquestions)){
		 customquestions=regdb.getCustomQuestions(eventid,transactionid,"attendee");
		 buyercustomquestions=regdb.getCustomQuestions(eventid,transactionid,"buyer");
	}
	HashMap<String, String> buyerquestionMap=new HashMap<String, String>();
	HashMap buyerdetails=null;
	buyerdetails=regdb.getBuyerInfo(transactionid,eventid);
	for(int i=0;i<buyerdetails.size();i++){
	 if("Y".equals(showcustomquestions)){
			String pkey=(String)buyerdetails.get("profilekey");
			String buyercustquestion=regdb.getCustQuestionsResponse(pkey, buyercustomquestions);
			if(!"".equals(buyercustquestion))buyerquestionMap.put("buyercustomQuestion", buyercustquestion);
		}
    }
	
	String buyerquestion=buyerquestionMap.get("buyercustomQuestion");
	context.put("buyercustomQuestions",buyerquestion);
    String getprofiledetailsquery="select fname,lname,profilekey from profile_base_info where eventid=CAST(? AS BIGINT) and transactionid=? and ticketid=CAST(? AS BIGINT)";
    DBManager db=new DBManager();
    if(Integer.parseInt(sure)>0){
	    StatusObj profilesb=db.executeSelectQuery(getprofiledetailsquery,new String[]{eventid,transactionid,"101"});
	  if(profilesb.getStatus()){
		for(int i=0;i<profilesb.getCount();i++){
			attendeeDetails.put("fname_"+i,db.getValue(i,"fname",""));
			attendeeDetails.put("lname_"+i,db.getValue(i,"lname",""));
			attendeeDetails.put("pkey_"+i,db.getValue(i,"profilekey",""));
			String pkey=db.getValue(i,"profilekey","");
			String custquestion=regdb.getCustQuestionsResponse(pkey, customquestions);
			if(!"".equals("custquestion"))attendeeDetails.put("customQuestion_"+i, custquestion);
         }
       context.put("attendeeDetails",attendeeDetails);
	}
   }

   if(Integer.parseInt(notsure)>0){
	StatusObj profilesb=db.executeSelectQuery(getprofiledetailsquery,new String[]{eventid,transactionid,"102"});
	if(profilesb.getStatus()){
		for(int i=0;i<profilesb.getCount();i++){
			notSureDetails.put("fname_"+i,db.getValue(i,"fname",""));
			notSureDetails.put("lname_"+i,db.getValue(i,"lname",""));
			notSureDetails.put("pkey_"+i,db.getValue(i,"profilekey",""));
			String pkey=db.getValue(i,"profilekey","");
			String custquestion=regdb.getCustQuestionsResponse(pkey, customquestions);
			if(!"".equals("custquestion"))notSureDetails.put("customQuestion_"+i, custquestion); 
		}
		context.put("notSureDetails",notSureDetails);
	}
  }
   HashMap codersvp=new HashMap();
   codersvp=getrsvpbarcode(eventid,transactionid,sure,attendeeDetails,context,"a");
   context.put("attendingCode",codersvp);

   codersvp=getrsvpbarcode(eventid,transactionid,notsure,notSureDetails,context,"ns");
   context.put("notSureCode",codersvp);		 
		 
}
%>
<%
//EventTicketDB edb=new EventTicketDB();
String confirmationtype="";
String eventid=request.getParameter("eventid");
String sure=request.getParameter("sure");
String notsure=request.getParameter("notsure");
String emailid_trac=request.getParameter("emailid");
String orderNumber=request.getParameter("ordernumber");
if(orderNumber==null)orderNumber="";
try{Integer.parseInt(sure);}
catch(Exception e)
{System.out.println("rsvpconfirmation sure numberformat"+e.getMessage());sure="0";}

int sure1=Integer.parseInt(sure);
sure1=sure1-1;
int notsure1=Integer.parseInt(notsure);
notsure1=notsure1-1;
String transactionid=request.getParameter("transactionid");
String eventdate=request.getParameter("rsvp_event_date");
if("null".equals(eventdate)){
	eventdate= "false";
}
else{
String[] splitdate=eventdate.split("-");
eventdate=splitdate[0]+" - "+splitdate[1];
}

String eventbankling="<p><a href='' onClick='refreshPage();'>"+getPropValue("rsvp.back.evnt",eventid) +"</a><br/></p>";
//String template=DbUtil.getVal("select content from reg_flow_templates where  purpose=?",new String[]{"0","rsvpPage"});

/* String template=DbUtil.getVal("select content from custom_reg_flow_templates where eventid=CAST(? AS BIGINT) and purpose=?",new String[]{eventid,"rsvp_confirmationpage"});
if(template == null){
	template=DbUtil.getVal("select content from default_reg_flow_templates where lang=? and purpose=?",new String[]{lang,"rsvp_confirmationpage"});
} */
String template=null;
try{
	HashMap<String, String> hm= new HashMap<String,String>();
	hm.put("purpose", "rsvp_confirmationpage");
	ConfirmationPageDAO pageDao=new ConfirmationPageDAO();
	String lang=DBHelper.getLanguageFromDB(eventid);
	template=(String)pageDao.getData(hm, lang, eventid).get("content");
	
}catch(Exception e){
	System.out.println("Exception in getVelocityTemplate"+e.getMessage());
}

HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");
String attendingLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.attending.label","Attending");
String mayBeLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notsuretoattend.label","Maybe");
VelocityContext context = new VelocityContext();
getdetails(transactionid,eventid,context,sure,notsure);
context.put("attendee",sure);
context.put("notSure",notsure);
context.put("transactionKey",transactionid);
context.put("eventdate",eventdate);
context.put("eventreglink",eventbankling);
context.put("eventid",eventid);
context.put("attendingLabel",attendingLabel);
context.put("mayBeLabel",mayBeLabel);
if(!"".equals(orderNumber))
	context.put("orderNumber",orderNumber);
VelocityEngine ve= new VelocityEngine(); 
TicketsDB tktdb=new TicketsDB();
HashMap configMap = tktdb.getConfigValuesFromDb(eventid);
HashMap rsvpattendee=new HashMap();
rsvpattendee.put("m_email",context.get("mgrEmail"));
rsvpattendee.put("GROUPID",eventid);
rsvpattendee.put("emailid",emailid_trac);
rsvpattendee.put("email",emailid_trac);
rsvpattendee.put("mailtomgr",GenUtil.getHMvalue(configMap,"event.sendmailtomgr","yes"));
rsvpattendee.put("mailtoattendee",GenUtil.getHMvalue(configMap,"event.sendmailtoattendee","yes"));
rsvpattendee.put("mailbcc",GenUtil.getHMvalue(configMap,"registration.email.cc.list",""));

//RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
	//regdbhelper.InserMailingList((String)rsvpattendee.get("eventid"),rsvpattendee);
    confirmationtype="confirmation_email";
	getQuestionsBarCode(transactionid,eventid,context,sure,notsure,confirmationtype);
	HashMap paramMap=new HashMap();
	paramMap.put("tid",transactionid);
    paramMap.put("eid",eventid);
    paramMap.put("bcc", "bcc");
    paramMap.put("powertype", "RSVP");
	System.out.println("calling rsvp get tickets thread: "+eventid);
    (new Thread(new GetTicketsThread(paramMap))).start();
    //int r=sendRsvpEmail(rsvpattendee,context);
	
try{
	ve.init();
    confirmationtype="confirmation_page";
	if(context.containsKey("attendeeDetails"))
	  context.remove("attendeeDetails");
	if(context.containsKey("notSureDetails")) 
      context.remove("notSureDetails");
    if(context.containsKey("attendingCode"))
      context.remove("attendingCode");
    if(context.containsKey("notSureCode"))
      context.remove("notSureCode");	
	getQuestionsBarCode(transactionid,eventid,context,sure,notsure,confirmationtype); 
     boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);

}
catch(Exception exp){
out.println("---"+exp.getMessage());
}  
%>
