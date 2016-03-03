<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%!
	String DELETE_TEMPLATE="delete from email_templates where  purpose='EVENT_REGISTARTION_CONFIRMATION' and groupid=?";
	
	String INSERT_TEMPLATE="insert into email_templates(groupid,subjectformat,htmlformat,textformat, replytoemail,fromemail,purpose,unitid) values (?,?,?,?,?,?,?,?)";
%>
<%
	String groupid=request.getParameter("groupid");
	String format=request.getParameter("format");	
	String emailtemplate=request.getParameter("emailtemp");	
	String purpose="EVENT_REGISTARTION_CONFIRMATION";
	StatusObj statobjn=null;	
	DbUtil.executeUpdateQuery(DELETE_TEMPLATE,new String[]{groupid});
	if("html".equals(format)){
	statobjn= DbUtil.executeUpdateQuery(INSERT_TEMPLATE,new	String[]{groupid,"Registration - $eventName",emailtemplate,null,"$mgrEmail", "$mgrEmail",purpose,"13579"});
	}
	else{
	statobjn= DbUtil.executeUpdateQuery(INSERT_TEMPLATE,new	String[]{groupid,"Registration -$eventName",null,emailtemplate,"$mgrEmail","$mgrEmail",purpose,"13579"});
	 }
	response.sendRedirect("/portal/mytasks/emailtemplatedone.jsp?GROUPID="+groupid);

     
%>


	