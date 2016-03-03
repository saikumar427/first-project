<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*"%>

<%
String title="";
request.setAttribute("layout", "DEFAULT");

request.setAttribute("CustomLNF_Type","Community");
request.setAttribute("CustomLNF_ID",request.getParameter("partnerid"));

title=DbUtil.getVal("select title from group_partner where partnerid=? and status='Active'",new String[]{request.getParameter("partnerid")});
if(title!=null && !"".equals(title)){
title+=" Network Event Listing";
}else
title="Network Event Listing";
String evtinfolink="<a href='/guesttasks/addevent.jsp?GROUPID="+request.getParameter("GROUPID")+"&partnerid="+request.getParameter("partnerid")+"'>Event Information</a>";
request.setAttribute("tasktitle",title+" > "+evtinfolink+" > Login");

String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	

%>


<%@ include file="/templates/beeletspagetop.jsp" %>

<%
    String signupurl="/networkeventlisting/newsignup.jsp";
    String error=request.getParameter("showerr");	
    if("y".equals(error))
	signupurl="/networkeventlisting/newsignup.jsp?showerr=y";

	com.eventbee.web.presentation.beans.BeeletItem item;
	
       	if(authData ==null){
       		item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Descr");
		item.setResource("/networkeventlisting/partnerdescription.jsp");
		leftItems.add(item);   

		item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Signup");
		item.setResource(signupurl);
		leftItems.add(item);


		item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Login");
		item.setResource("/networkeventlisting/checklogin.jsp");
		rightItems.add(item);      
	}

	 
%>

<%@ include file="/templates/beeletspagebottom.jsp" %>
	

	