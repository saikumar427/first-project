<%@page import="com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>

<%!
String getSelectedMenu(String rmik, String tab){
String ret="";
if(rmik !=null){
ret=rmik.equals(tab)?"id='ebeemenuhighlightlink'":ret;
}
return ret;
}
%>


<%
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String subtype=(request.getParameter("stype")==null)?"view":request.getParameter("stype");

MemberFeatures featuresofunitreq1=(MemberFeatures)request.getAttribute("memberfeatures");

//String UNITID=(request.getParameter("UNITID")!=null)?request.getParameter("UNITID"):"13579";


String linktohighlight =(String)request.getAttribute("linktohighlight");
System.out.println("linktohighlight   is "+linktohighlight);

Authenticate authData=(Authenticate) com.eventbee.general.AuthUtil.getAuthData(pageContext);
com.eventbee.myaccount.MyAccount myacct=(com.eventbee.myaccount.MyAccount)authData.UserInfo.get("MyAccount");


boolean displaypagetemplate=false;
if(myacct !=null){
	displaypagetemplate=myacct.displayPageTemplate();
}



%>




<span >

<table width='100%'  cellspacing="0" cellpadding="5" class='tabhighlightcolor' id='ebeemenu' >



<tr>
 <td   align='left'  >
	
 	
	 <table cellpadding='0' cellspacing='0' align='left' >
	 <tr><td <%=getSelectedMenu("About Me", linktohighlight ) %>>
	<a href='/portal/pagecontent/pagecontentmain.jsp?type=Snapshot'>About Me</a>&nbsp;|&nbsp;
	</td></tr>
	</table>
	
	
	 <table cellpadding='0' cellspacing='0' align='left' >
	<tr><td <%=getSelectedMenu("Content", linktohighlight ) %> >
	<a href='/portal/preferences/editpref.jsp?type=Snapshot'>Content</a>&nbsp;|&nbsp;
	</td></tr>
	</table>


	 

	 <table cellpadding='0' cellspacing='0' align='left' >
	<tr><td <%=getSelectedMenu("theme", linktohighlight ) %> >
	<a href='/lifestyle/lifestyle.jsp?type=Snapshot&stype=theme'>Theme</a>&nbsp;|&nbsp;
	
	<%--if(displaypagetemplate){ 
	
	}--%>
	</td></tr>
	</table>
	
	
	
	
	
	<table cellpadding='0' cellspacing='0' align='left' >
	<tr><td <%=getSelectedMenu("Settings", linktohighlight ) %> >
	<a href='/lifestyle/settings.jsp?type=Snapshot&stype=settings'>Settings</a>&nbsp;
	</td></tr>
	</table>

	
	

</td></tr>

<tr>
<%--
<%
Authenticate authData_auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String loggusername=(authData_auth !=null)?authData_auth.getLoginName():"";
%>

	  <td class='previewmylifestyle'><a href="/member/<%=loggusername%>/photos/">Preview My Photos Page</a></td>
	</tr>
--%>
</table>


</span>
