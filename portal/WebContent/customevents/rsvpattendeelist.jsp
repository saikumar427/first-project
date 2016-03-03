<%@ page import=" java.io.*,java.util.*,com.eventbee.general.*,com.event.dbhelpers.DisplayAttribsDB" %>
<%@ include file="/customevents/rsvpattribresponses.jsp" %>


<%
String groupid=request.getParameter("groupid");
String eventid=groupid;
String eventdate=request.getParameter("eventdate");
if(eventdate == null){
eventdate="";
}
Map attendeelistmap=null;
HashMap countMap=new HashMap();
Vector attendeelist=new Vector();
String rsvprecurring=DbUtil.getVal("Select value from config where name='event.recurring' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");

if(!"Y".equals(rsvprecurring)){
	eventdate="";
	attendeelist=RsvpAttendeeList.getRSVPList(groupid,countMap,eventdate);
	if(attendeelist!=null&&attendeelist.size()>0){
	Vector attendingvector=(Vector)attendeelist.get(0);
	Vector notsurevector=(Vector)attendeelist.get(1);
	Vector notattending=(Vector)attendeelist.get(2);
%>

<%if(!"0".equals(countMap.get("yes"))){%>

<b><%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.attending.label","Attending")%> (<%=countMap.get("yes")%>)</b>


<%
for(int i=0;i<attendingvector.size();i++){
	HashMap hmt=(HashMap)attendingvector.elementAt(i);
	String name = (String)hmt.get("name");
	if(!"".equals(name)){			
%>
<li><%=name%></li>
<hr/>

<%    
	}
}
}
if(notsurevector.size()>0){%>
<b><%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notsuretoattend.label","May be")%>
 (<%=countMap.get("notsure")%>)</b>
<%}
for(int k=0;k<notsurevector.size();k++){
HashMap hmt=(HashMap)notsurevector.elementAt(k);
String name = (String)hmt.get("name");
if(!"".equals(name)){			
%>
<li><%=name%></li>
<hr/>
<%    
}
}	
if(notattending.size()>0){%>
<b>No (<%=countMap.get("no")%>)</b>
<%}
for(int p=0;p<notattending.size();p++){
HashMap hmt=(HashMap)notattending.elementAt(p);
String name = (String)hmt.get("name");
if(!"".equals(name)){			
%>
<li><%=name%></li>
<hr/>

<%    
}
}	
}


}
else{
if(!"".equals(eventdate) || !"Select Date".equals(eventdate)){


}

}

%>