<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.pagenating.*"%>


<%!
Vector getParticipatedNtsEvents(){
Vector v=new Vector();
String query="select c.nts_approvaltype,b.eventname,b.eventid"
		+" from eventinfo b,group_agent_settings c where  b.eventid=c.groupid "
		+" and listtype='PBL'  and c.enablenetworkticketing ='Yes'  and b.status='ACTIVE' "
		+" order by b.created_at desc limit 10";
        DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{ });
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
	HashMap hm=new HashMap();
	for(int j=0;j<columnnames.length;j++){
	hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
	}
			v.add(hm);
		}
	}
	return v;
}

HashMap PartnerApprovalStatusForEvents(String userid){

String Query="select status,eventid from manual_nts_events where partnerid=(select partnerid from group_partner where userid=?)";

HashMap eventstatusmap=new HashMap();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(Query,new String[]{userid});
if(stobj.getStatus())
{
for(int k=0;k<stobj.getCount();k++)
{			
eventstatusmap.put(dbmanager.getValue(k,"eventid",""),dbmanager.getValue(k,"status",""));
}
}

return eventstatusmap;
}
%>
<%

Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String userid=null;
if (authData!=null){
userid=authData.getUserID();
}


Vector partnerParticipatedNtsEvents=getParticipatedNtsEvents();
HashMap partnerStatus=PartnerApprovalStatusForEvents(userid);
session.setAttribute(userid+"_partnerNtsEvents",partnerParticipatedNtsEvents);
session.setAttribute(userid+"_partnerApprovalStaus",partnerStatus);
response.sendRedirect("/portal/ningapp/canvasownerpartner.jsp");


%>