<%@ page import="java.util.*,com.eventbee.event.*" %>
<%@ page import="com.eventbee.editevent.EditEventDB"%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%@ page import="com.eventbee.creditcard.*" %>
<%@ page import="java.net.InetAddress"%>

<jsp:include page="/auth/checkpermission.jsp"/>
<%!
String server_addrs="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

public void SendEmail(String eventid,String unitid){
		try{
		DBManager dbmanager=new DBManager();
		String query=" select eventname,e.email,e.phone,u.phone as userphone,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo e,user_profile u where u.user_id=e.mgr_id::varchar and eventid=cast(? as integer)";
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{eventid});
		String evtname="",email="",phone="",u_phone="",username="";
		if(statobj.getStatus()){
		int recordcount=statobj.getCount();
		for(int i=0;i<recordcount;i++){
		 evtname=dbmanager.getValue(i,"eventname","");
		 email=dbmanager.getValue(i,"email","");
		 phone=dbmanager.getValue(i,"phone","");
		 u_phone=dbmanager.getValue(i,"userphone","");
		 username=dbmanager.getValue(i,"username","");
		 }
		}
		String servername=EbeeConstantsF.get("serveraddress","www.eventbee.com");
		String url=ShortUrlPattern.get(username)+"/event?eventid="+eventid;
		String subject="Online Registration Alert";
		String message="Event: "+evtname+"\n"+" http://"+url;
		message+="\n Powered With Online Registration";
		message+="\n User Phone no: "+u_phone;
		message+="\n Event Phone no: "+phone;
		message+="\n email: "+email;
		EmailObj obj=EventbeeMail.getEmailObj();
		/* String frommail=EbeeConstantsF.get("online.registration.alertfrom.mail","bala@beeport.com");
		String tomail=EbeeConstantsF.get("online.registration.alertto.mail","bala@beeport.com"); */
		String frommail=EbeeConstantsF.get("online.registration.alertfrom.mail","bala@eventbee.org");
		String tomail=EbeeConstantsF.get("online.registration.alertto.mail","bala@eventbee.org");
		obj.setTo(tomail);
		obj.setFrom(frommail);
		obj.setSubject(subject);
		obj.setTextMessage(message);
		EventbeeMail.sendTextMailPlain(obj);
	}catch(Exception e){
		 System.out.println(" There is an error in powered by send mail:"+ e.getMessage());
	   }
	}

void sendEventemail(Authenticate authData,String eventid,String unitid,String platform,String domain){
try{
        

       EditEventDB evtDB1=new EditEventDB();

	DBManager dbmanager=new DBManager();
			String query=" select eventname,email from eventinfo where eventid=cast(? as integer)";
			StatusObj statobject=dbmanager.executeSelectQuery(query,new String[]{eventid});
			String eventname="",email="";
			if(statobject.getStatus()){
			int recordcount=statobject.getCount();
			for(int i=0;i<recordcount;i++){
			 eventname=dbmanager.getValue(i,"eventname","");
			 email=dbmanager.getValue(i,"email","");			
			 }
		}
	Map messageMap=new HashMap();
	String msg= " <table cellpadding='5' bgcolor='#ffcc33'><tr><td><p>";

	if(("Yes".equalsIgnoreCase(evtDB1.getConfig(eventid,EventConstants.POWERED_BY))))
{
        
        
        if("ning".equals(platform))
        msg=msg+"Visit your <a href='"+domain+"'>Ning Event Register</a> page to get code to display Register button on your website.<br>";
        else        
        msg=msg+"Visit your <a href='"+server_addrs+"/portal/auth/listauth.jsp?groupid="+eventid+"&purpose=eventmanage'>Event Manage</a> page to get code to display Register button on your website.<br>";
        
        
        
          
}
else{
       if("ning".equals(platform)){
       msg=msg+"Visit your <a href='"+domain+"'>Ning Event Register</a> page to addtickets to your event today, and take advantage of Eventbee's "
       	      +"  flat $1 fee per ticket pricing model. <a href='"+server_addrs+"/helplinks/onlineregistration.jsp'>Click here</a> to learn more.";
       
        }
        else  {      
        msg=msg+"Online ticketing is not yet enabled on your event,"
              +"  <a href='"+server_addrs+"/portal/auth/listauth.jsp?groupid="+eventid+"&purpose=eventmanage'>addtickets</a> to your event today, and take advantage of Eventbee's "
	      +"  flat $1 fee per ticket pricing model. <a href='"+server_addrs+"/helplinks/onlineregistration.jsp'>Click here</a> to learn more.";
         }

}
msg=msg+"</p></td></tr></table>";

	messageMap.put("#**TO_FIRST_NAME**#",authData.getFirstName());
	messageMap.put("#**EVENT_NAME**#",eventname);
	messageMap.put("#**TO_FIRST_NAME**#",authData.getFirstName());
	messageMap.put("#**EVENT_MSG**#",msg);
	
	messageMap.put("#**EVENT_URL**#",ShortUrlPattern.get(authData.getLoginName())+"/event?eventid="+eventid);
	SendEmail se=new SendEmail(unitid,"EVENT_LISTING_CONFIRMATION_MAIL",email,messageMap);
	
}catch(Exception send){System.out.println(" Exception in sendEventEmail: "+send);}

}

%>

<%


InetAddress local = InetAddress.getLocalHost();

System.out.println ("Server IP : " + local.getHostAddress());
%>



<%
String platform=(String)session.getAttribute("platform");
 String domain=(String)session.getAttribute("domain");

String bancycle="";
String appname="";
String unitid="13579";
appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
String loginname="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)
loginname=DbUtil.getVal("select login_name from authentication where user_id=? ",new String [] {authData.getUserID()});
String eventid=request.getParameter("evetid");

if(eventid==null||"null".equals(eventid.trim()))
eventid=request.getParameter("GROUPID");

if(eventid==null||"null".equals(eventid.trim()))
eventid=request.getParameter("eventid");

%>
<%
String status=DbUtil.getVal("select status from eventinfo where eventid=cast(? as integer)", new String [] {eventid});
if("INACTIVE".equals(status)){
List list=(List)session.getAttribute("EVENTIDS_HASH");
if(list!=null&&list.size()>0){
for(int j=0;j<list.size();j++){
HashMap hmap=(HashMap)list.get(j);
if(hmap!=null){
DbUtil.executeUpdateQuery("update eventinfo set status='ACTIVE' where eventid=cast(? as integer)",new String [] {(String)hmap.get("eventid")});
}
}
}
sendEventemail(authData,eventid,unitid,platform,domain);
EditEventDB evtDB=new EditEventDB();
if(("Yes".equalsIgnoreCase(evtDB.getConfig(eventid,EventConstants.POWERED_BY))))
SendEmail(eventid,unitid);
HashMap emailmap=(HashMap)session.getAttribute(eventid+"_FREEPLUS_EVENT_EMAILIDMAP");
if(emailmap!=null&&!emailmap.isEmpty()){
%>
<jsp:include page="/createevent/sendemails.jsp"/>
<%
}
}
CreditCardProcessingBean jBean=(CreditCardProcessingBean)session.getAttribute("CreditCardProcessingBean");
StatusObj sobj=null;
HashMap hm=(HashMap)session.getAttribute("ACC_UPGRADE");


session.removeAttribute(eventid+"_TICKET_POWERED_HASH");
session.removeAttribute(eventid+"_TICKET_EVENT_HASH");
session.removeAttribute(eventid+"TicketDetails");
session.removeAttribute(eventid+"CustomAttributes");
session.removeAttribute("EventDetails");
session.removeAttribute("PowerType");
session.removeAttribute("rsvpdetails");
session.removeAttribute("purpose");
session.removeAttribute("MEMBER_EVENT_VECTOR");
session.setAttribute("EVENTIDS_HASH",null);
session.removeAttribute("ADD_NEW_EVENT");
session.removeAttribute("ACC_UPGRADE");
session.removeAttribute(eventid+"commission_details");
session.removeAttribute(eventid+"networkticketing");
session.removeAttribute("listmap");
session.removeAttribute("UpdatedCPC");
session.removeAttribute("UpdatedCPM");
session.removeAttribute("EventListing_Cart");
session.removeAttribute("Networkadvertising");
session.removeAttribute("NETWORK_ADV_COSTS");
session.removeAttribute("partner_selected_attribs");
session.removeAttribute(eventid+"_GROUP_EVENT_HASH");

String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=cast(? as integer)", new String [] {eventid});
if(eventname!=null)
	eventname=java.net.URLEncoder.encode(eventname);
//response.sendRedirect("/portal/mytasks/eventmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"&evtname="+eventname);
if("yes".equals((String)session.getAttribute("Networkadpurpose"))){

response.sendRedirect("/portal/mytasks/netadvsuccess.jsp?GROUPID="+request.getParameter("GROUPID")+"&evtname="+eventname);

}
else if("ning".equals(platform)){
session.setAttribute("EventListed","Yes");
response.sendRedirect("/portal/ningapp/ticketing/eventmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"&evtname="+eventname);
}
else
response.sendRedirect("/portal/mytasks/eventlistsuccess.jsp?GROUPID="+request.getParameter("GROUPID")+"&evtname="+eventname);



%>

