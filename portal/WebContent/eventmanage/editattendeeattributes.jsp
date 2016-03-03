<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.customattributes.CustomAttributesDB" %>

<%!
	String DELETEQUERY="delete from attendeelist_attributes where eventid=? ";
	String INSERT_ATTENDEE_ATTRIBUTES="insert into attendeelist_attributes(eventid,position,attrib_setid,attribname,updated_at)values(?,?,?,?,now())";
	
%>
<%	String eid=request.getParameter("eid");
	String custom_setid=CustomAttributesDB.getAttribSetID(eid,"EVENT");
	DbUtil.executeUpdateQuery(DELETEQUERY,new String[]{eid});
	String [] sel2vals=request.getParameterValues("sel2");
	DbUtil.executeUpdateQuery(DELETEQUERY,new String[]{eid});
	if(sel2vals!=null ){
	 for(int i=0;i<sel2vals.length; i++){
	  System.out.println("sel2vals[i]===="+sel2vals[i]);
	 DbUtil.executeUpdateQuery(INSERT_ATTENDEE_ATTRIBUTES,new String[]{eid,""+(i+1),custom_setid,sel2vals[i],});
	}
	}

%>
	