<%--@page import="com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.general.*"%>
<%!
String [] lifestyle={"Friends","Messages","Guestbook","Network"};
String [] lifestyle1={"/portal/nuser/NuserFriends.jsp",
			"/portal/club/allMessages.jsp",
			"/portal/guestbook/GBookManage.jsp",
			"/portal/lifestyle/lifestyle.jsp"};
String [] lifestyle2={"Friends","Messages","Guestbook","Snapshot"};
%>


					<%

					String tabtype=request.getParameter("type");
					
					int len=lifestyle.length;
					      
					String tabclass="desitabcont mytab2";
					if(tabtype==null||"null".equals(tabtype))
					tabtype=(String)request.getAttribute("type");
					if(tabtype==null||"null".equals(tabtype))
					tabtype=lifestyle[0];
System.out.println("tabtype: "+tabtype);
					
					
					for(int i=0;i<lifestyle.length;i++){
					if(tabtype.equals(lifestyle2[i]))
						tabclass="desitabcont mytab1";
						else
						tabclass="desitabcont mytab2";
					
					
					

					%>
					
					<span class="<%=tabclass %>" ><a href='<%=lifestyle1[i]%>?type=<%=lifestyle2[i]%>'><%=lifestyle[i] %></a></span>
					<%
					}//end for
					%>

					<%
Authenticate authData_auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String loggusername=(authData_auth !=null)?authData_auth.getLoginName():"";


boolean displaymypreviewlink=(authData_auth !=null)?true:false;


%>

<%
if(displaymypreviewlink){
String label="";
String labellink="";
if(  "mylifestyle".equals(  (String) request.getAttribute("subtabtype")     ) ) {
label="my_network.gif";
labellink=ShortUrlPattern.get(loggusername);
}
else if(  "LFPhotom".equals(  (String) request.getAttribute("subtabtype")     ) ) {
label="my_photos.gif";
labellink=ShortUrlPattern.get(loggusername)+"/photos/";
}

%>

<!--span style="float:right;padding-top:0px"  >
<a href='<%=ShortUrlPattern.get(loggusername)%>'   style="padding-left:5px;text-decoration:none">
<img  src='/home/images/my_network.gif' border='0'   />
</a>
<a href='<%=ShortUrlPattern.get(loggusername)%>/blog'    style="padding-left:5px;text-decoration:none"  >
<img  src='/home/images/my_blog.gif' border='0' />
</a>
<a href='<%=ShortUrlPattern.get(loggusername)%>/photos'    style="padding-left:5px;text-decoration:none"  >
<img  src='/home/images/my_photos.gif' border='0' />
</a><br/>
</span-->

<%
}
--%>


<%@ page import="com.eventbee.authentication.*,java.util.*" %>
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
String ntype=(String)request.getParameter("type");


String linktohighlight=(String)request.getAttribute("linktohighlight");

%>
<span >
<table width='100%'  cellspacing="0" cellpadding="5" class='tabhighlightcolor' id='ebeemenu' >
<tr>
 <td   align='left'  >
 	<table cellpadding='0' cellspacing='0' align='left' >
	 <tr><td <%=getSelectedMenu("Friends",ntype) %>>
	<a href='/portal/nuser/NuserFriends.jsp?type=Friends'>Friends </a>&nbsp;|&nbsp;
	</td></tr>
	</table>
	<table cellpadding='0' cellspacing='0' align='left' >
	 <tr><td <%=getSelectedMenu("Messages",ntype) %>>
	<a href='/portal/club/allMessages.jsp?type=Messages'>Messages </a>&nbsp;|&nbsp;
	</td></tr>
	</table>
	<table cellpadding='0' cellspacing='0' align='left' >
	 <tr><td <%=getSelectedMenu("GuestBook",ntype)%>>
	 
	<a href='/portal/guestbook/GBookManage.jsp?type=GuestBook'>GuestBook</a>&nbsp;|&nbsp;
	</td></tr>
	</table>
	<table cellpadding='0' cellspacing='0' align='left' >
	 <tr><td <%=getSelectedMenu("Network",ntype)%>>
	<a href='/portal/lifestyle/lifestyle.jsp?type=Network'>Network</a>&nbsp;|&nbsp;
	</td></tr>
	</table>
	
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
</table>
</span>
