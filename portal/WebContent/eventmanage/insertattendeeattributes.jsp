<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<%
String eid=request.getParameter("eid");
String custom_setid=CustomAttributesDB.getAttribSetID(eid,"EVENT");
String [] sel2vals=request.getParameterValues("sel2");
String DELETEQUERY="delete from attendeelist_attributes where eventid=? ";
DbUtil.executeUpdateQuery(DELETEQUERY,new String[]{eid});
String INSERT_ATTENDEE_ATTRIBUTES="insert into attendeelist_attributes(eventid,position,attrib_setid,attribname,created_at)values(?,?,?,?,now())";
if(sel2vals!=null ){
 for(int i=0;i<sel2vals.length; i++){
 DbUtil.executeUpdateQuery(INSERT_ATTENDEE_ATTRIBUTES,new String[]{eid,""+(i+1),custom_setid,sel2vals[i]});
}
}
%>