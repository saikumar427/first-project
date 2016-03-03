<%@ page import="com.eventbee.general.*"%>




<%
         String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

	String evtname=null;
	request.setAttribute("CustomLNF_Type","EventDetails");
	request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));
	
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});
	String listurl=serveraddress+"event?eid="+request.getParameter("GROUPID");
	String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
	request.setAttribute("tasktitle","Event Registration > "+evtlink+" > Confirmation");

%>


<%@ include file="/templates/taskpagetop.jsp" %>


<%

	taskpage="/eventregister/reg/processdata.jsp";
	footerpage="/main/eventfootermain.jsp";
	%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>