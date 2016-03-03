<%@ page import="com.eventbee.general.*" %>
<%!
static String ADD_NOTES_QRY="insert into transaction_notes(tid,notes_date,notes,notes_id) values(?,now(),?,nextval('notes_seq'))";
%>
<%
String eventid=request.getParameter("eventid");
String newnote=request.getParameter("newnote");
newnote=newnote.trim();
String transactionid=request.getParameter("transactionid");
if(!"".equals(newnote)){
DbUtil.executeUpdateQuery(ADD_NOTES_QRY,new String[]{transactionid,newnote});
}
%>
