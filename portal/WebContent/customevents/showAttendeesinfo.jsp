<%@ page import="java.io.*, java.util.*" %>
<%@ include file="/listreport/attributesresponses.jsp" %>
<%!
public static  String VIEW_ATTENDEE_QUERY="select a.attendeekey,a.firstname || ' ' || a.lastname as name"		
		+" from eventattendee a,event_reg_transactions  b where a.eventid=?  and a.transactionid=b.tid and b.paymentstatus in('Pending','Completed','CHARGED') order by attendeeid desc";

public static Vector getAttendeeListInfo(String groupid)
	{
	try{Integer.parseInt(groupid);}
		catch(Exception e){	return null; }
	DBManager dbmanager=new DBManager();
	String custom_setid=CustomAttributesDB.getAttribSetID(groupid,"EVENT");	
	
	Vector requiredList=getRequiredAtribs(groupid);
	if(requiredList.size()==0){
	requiredList.add("Attendee Name");
	}
	
	HashMap attribsHm=null;
	if(requiredList.size()==1 && "Attendee Name".equals(requiredList.get(0).toString())){
	}else{
	attribsHm=getResponses(custom_setid,groupid);
	}
	
	StatusObj stobj=dbmanager.executeSelectQuery(VIEW_ATTENDEE_QUERY,new String[]{groupid});
	Vector v=null;
		if(stobj.getStatus()){
		v=new Vector();
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				String atendeeKey=dbmanager.getValue(i,"attendeekey","");
				hm.put("attendeekey", atendeeKey);
				String name="<b>"+dbmanager.getValue(i,"name","")+"</b>";	
		
				String otherAttribs="";
				HashMap responseHm=new HashMap();
				if(attribsHm!=null&& attribsHm.get(atendeeKey)!=null){
				responseHm=(HashMap)attribsHm.get(atendeeKey);
				}
					for(int k=0;k<requiredList.size();k++){
					String attribname=(String)requiredList.get(k);
					String attribVal=(String)responseHm.get(requiredList.get(k));
					if(attribVal==null) attribVal="";
					if("Attendee Name".equals(attribname)){
					attribVal=name+"<br/>";
					}else{
					if(attribVal!=null && !"".equals(attribVal.trim())){
					String temp=attribVal.toLowerCase();
					if((temp.startsWith("http://"))||(temp.startsWith("https://"))){
					temp="<a href='"+attribVal+"' target='_blank'>"+attribVal+"</a>";
					}
					attribVal=requiredList.get(k)+": "+temp+"<br/>";
					}
					}
					otherAttribs+=attribVal;					
					}					
				if(i==stobj.getCount()-1)
					hm.put("name",otherAttribs);
				else{
					if(!"".equals(otherAttribs)){
						hm.put("name",otherAttribs+"<hr/>");				
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
Map attendeelistmap=null;
Vector attendeelist=getAttendeeListInfo(groupid);
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
		
%>