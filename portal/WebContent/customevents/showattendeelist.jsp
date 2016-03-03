<%@ page import="java.io.*, java.util.*,com.event.dbhelpers.DisplayAttribsDB" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/customevents/attributesresponses.jsp" %>

<%@ include file="/customevents/rsvpattribresponses.jsp" %>

<%!
public static  String VIEW_ATTENDEE_QUERY="select a.profilekey as attendeekey,a.fname || ' ' || a.lname as name"		
		+" from profile_base_info a,event_reg_transactions  b where a.eventid=CAST(? AS INTEGER)  and a.tickettype not in('nonAttendee','donationType','nonattendee') and a.transactionid=b.tid and b.paymentstatus in('Pending','Completed','CHARGED') order by profileid desc";

public static  String VIEW_ATTENDEE_QUERY_By_Date="select a.profilekey as attendeekey,a.fname || ' ' || a.lname as name"		
		+" from profile_base_info a,event_reg_transactions  b where a.eventid=CAST(? AS INTEGER)  and a.tickettype not in('nonAttendee','donationType','nonattendee') and a.transactionid=b.tid and b.paymentstatus in('Pending','Completed','CHARGED') and b.eventdate=? order by profileid desc";

public static HashMap<String,String> getAtrribNames(String eid,String purpose){
	HashMap<String,String> attribsMap=new HashMap();
	String query="select attrib_id,attribname from custom_attrib_master a,custom_attribs b"+
  " where a.groupid=?::INTEGER and a.attrib_setid=b.attrib_setid and a.purpose=?";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query, new String[]{eid,purpose});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			attribsMap.put(db.getValue(i, "attrib_id",""), db.getValue(i, "attribname",""));
		}
	}
	return attribsMap;
}
public static Vector getAttendeeListInfo(String groupid,String evtdate)
	{
	try{Integer.parseInt(groupid);}
		catch(Exception e){	
		System.out.println("groupid in getAttendeeListInfo is:"+groupid);
		return null; }
	DBManager dbmanager=new DBManager();
	HashMap<String,String> attribnames=getAtrribNames(groupid,"EVENT");
	String custom_setid=CustomAttributesDB.getAttribSetID(groupid,"EVENT");	
	Vector requiredList=getRequiredAtribs(groupid);
	if(requiredList.size()==0){
	requiredList.add("0");
	}
	String query=null;
	HashMap attribsHm=null;
	HashMap<String,HashMap<String,String>> basicResponses=null;
	if(requiredList.size()==1 && "0".equals(requiredList.get(0).toString())){
	}else{
	attribsHm=getResponses(custom_setid,groupid);
	if(requiredList.contains("-1") || requiredList.contains("-2"))
	{
		basicResponses=getBasicResponses(groupid);
	}
	}
	ArrayList params=new ArrayList();
	 params.add(groupid);
	if(!"".equals(evtdate)){
	 query=VIEW_ATTENDEE_QUERY_By_Date;
	
	 params.add(evtdate);
	 }
	 else
	  query=VIEW_ATTENDEE_QUERY;
	 	StatusObj stobj=dbmanager.executeSelectQuery(query,(String[])params.toArray(new String[params.size()]));
	  
	
	Vector v=null;
		if(stobj.getStatus()){
		v=new Vector();
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				String atendeeKey=dbmanager.getValue(i,"attendeekey","");
				hm.put("attendeekey",atendeeKey);
				String name="<b>"+dbmanager.getValue(i,"name","")+"</b>";	
		
				String otherAttribs="";
				HashMap responseHm=new HashMap();
				if(attribsHm!=null&& attribsHm.get(atendeeKey)!=null){
				responseHm=(HashMap)attribsHm.get(atendeeKey);
				}
					for(int k=0;k<requiredList.size();k++){
					String attribid=(String)requiredList.get(k);
					String attribname=attribnames.get(attribid);
					String attribVal=(String)responseHm.get(attribid);
					if("-1".equals(attribid)){
						attribname="Email";
						attribVal=basicResponses.get(atendeeKey).get("email");
					}
					else if("-2".equals(attribid)){
						attribname="Phone";
						attribVal=basicResponses.get(atendeeKey).get("phone");
					}
					if(attribVal==null) attribVal="";
					if("0".equals(attribid)){
					attribVal=name+"<br/>";
					}else{
					if(attribVal!=null && !"".equals(attribVal.trim())){
					String temp=attribVal.toLowerCase();
					if((temp.startsWith("http://"))||(temp.startsWith("https://"))){
					temp="<a href='"+attribVal+"' target='_blank'>"+attribVal+"</a>";
					}
					attribVal=attribname+": "+temp+"<br/>";
					}
					}
					otherAttribs+=attribVal;					
					}					
				if(i==stobj.getCount()-1)
					hm.put("name",otherAttribs);
				else{
					if(!"".equals(otherAttribs)){
						hm.put("name",otherAttribs+"<hr class='hrline'/>");				
					}
					else
						hm.put("name",otherAttribs);
				}
				hm.put("comments",dbmanager.getValue(i,"comments","") );
				v.addElement(hm);
			}
		}
		return v;
	}
%>

<%
String groupid=request.getParameter("groupid");
String eventtype=request.getParameter("eventtype");
String eventdate=request.getParameter("eventdate");
boolean invalid=false;
try{
	int eventid=Integer.parseInt(groupid);
}
catch(Exception e){
	System.out.println("groupid is:"+groupid); 
	invalid=true;
}
if(!invalid){
HashMap countMap=new HashMap();
Map attendeelistmap=null;
Vector attendeelist=null;
boolean flag=true;
String eventid=groupid;
if("rsvp".equals(eventtype)&&" ".equals(eventdate))
	flag=false;
if(flag){
	attendeelist=getAttendeeListInfo(groupid,eventdate);
	
}
String checkrsvp=DbUtil.getVal("Select value from config where name='event.rsvp.enabled' and config_id in (select config_id from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{eventid});

if("yes".equals(checkrsvp)){
	HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");
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
<b><br><%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notsuretoattend.label","Maybe")%>
 (<%=countMap.get("notsure")%>)</b>
<%}
for(int k=0;k<notsurevector.size();k++){
HashMap hmt=(HashMap)notsurevector.elementAt(k);
String name = (String)hmt.get("name");
if(!"".equals(name) || !" ".equals(name)){			
%>
<li><%=name%></li>
<hr/>
<%    
}
}	

		
%>


<%    

 }}
 else{
	if(attendeelist!=null&&attendeelist.size()>0){
	    	for(int i=0;i<attendeelist.size();i++){
	    		HashMap hmt=(HashMap)attendeelist.elementAt(i);
	    			String name = (String)hmt.get("name");
	if(!"".equals(name)){			
	%>
	<li><%=name%></li>
	<%
	    	}
	    	}
	    }
}}
%>