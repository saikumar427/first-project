<%@ page import="java.util.ArrayList,java.util.HashMap" %>
<%@ page import="com.eventbee.general.DBManager, com.eventbee.general.StatusObj" %>
<%!
class School{
	private ArrayList<String> attendees = new ArrayList<String>();
	public ArrayList<String> getAttendees(){return attendees;}
	public void addAttendee(String attendee){attendees.add(attendee);}
}
public HashMap<String,School> getAttendeesOfSchools(String eid){
	String query="SELECT DISTINCT fname||' '||lname AS name,  bigresponse AS sname FROM profile_base_info c, custom_questions_response a, custom_questions_response_master b WHERE c.eventid=? AND c.profilestatus='Completed' AND c.transactionid=b.transactionid AND a.ref_id=b.ref_id AND attribid=1 ORDER BY name";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query, new String[]{eid});
	HashMap<String,School> schools=new HashMap<String,School>();
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			String sname=db.getValue(i, "sname","NONE");
			if("NONE".equals(sname)) sname="ZZZZZZZZZZZ";
			School school=schools.get(sname);
			if(school==null) school=new School();
			school.addAttendee(db.getValue(i, "name",""));
			schools.put(sname, school);
		}
	}
	return schools;
}
public String getDisplayHTML(HashMap<String,School> slist){
	if(slist.size()==0) return "";
	StringBuffer html= new StringBuffer("<ul>");
	Object[] snames = slist.keySet().toArray();
	java.util.Arrays.sort(snames);
	for(Object sch : snames) {
    	School schooldata=slist.get(sch);
		String sname=sch.toString();
		sname="ZZZZZZZZZZZ".equals(sname)?"NONE":sname;
		html.append("<li><strong>"+sname+"</strong><ul>");
		ArrayList<String> attendees=schooldata.getAttendees();
		for(int j=0;j<attendees.size();j++){
			html.append("<li>"+attendees.get(j)+"</li>");
		}
		html.append("</ul></li>");
	}
	html.append("</ul>");
	return html.toString();
}
%>

<%
String eid=request.getParameter("groupid");
if(eid==null) eid="166221622";
HashMap<String,School> slist=getAttendeesOfSchools(eid);
out.print(getDisplayHTML(slist));
%>