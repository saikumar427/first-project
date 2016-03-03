<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures,com.eventbee.listmanagement.*" %>

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
String appheading="Network Ticket Selling";
if("app".equals(request.getParameter("eventregister")))
 appheading="Event Register Application";
%>

<table ><tr><td align='left' >
<img  src="http://www.eventbee.com/home/images/logo_big.jpg" border='0'/>
<td align='left' width='500' valign='center'  ><b><%=appheading%></b></td>
<td >
<%
String url="/ningapp/ticketing/canvasownerpagebeelets.jsp";
if("profile".equals(request.getParameter("from")))
url="/ningapp/ticketing/myeventsbeelet.jsp";
else if("ntsapp".equals(request.getParameter("homelink")))
url="http://www.eventbee.com/ningapp/ntstab";
else if("ntsappprofile".equals(request.getParameter("homelinkprofile")))
url="/ningapp/profileearningspage.jsp";
if(!"ntsappprofile".equals(request.getParameter("homelinkprofile"))){
if("ntsapp".equals(request.getParameter("homelink"))){
%>
<a href='#' onclick="ntstab();"  id="homelink">Home</a></td>

<%}else{%>
<a href='<%=url%>'  id="homelink">Home</a></td>

<%}%>

<td> | </td>
<td >



<a href='http://help.eventbee.com' target="_blank" id="helplink">Help</a></td>
</tr>
<%}%>
</table>

<%

String tabtype=(String)request.getAttribute("stype");
									

String tabclass="desitabcont mytab2";

String type=request.getParameter("type");

String [] mymenutabs={};
String [] mymenutabnames={};
String [] mymenutablinks={};

String [] mysubmenus={};
String [] mysubmenulinks={};
String mtype=(String)request.getAttribute("mtype");
String stype=(String)request.getAttribute("stype");
String ltype=(String)request.getAttribute("ltype");
String showtabs=(String)request.getAttribute("showtabs");
String GROUPID=request.getParameter("GROUPID");
String oid=request.getParameter("oid");


if("Network Ticket Selling".equalsIgnoreCase(mtype )  ){
 mymenutabs=new String[]{"My Network Ticket Selling","My Earnings"};
 mymenutabnames=new String[]{"My Network Ticket Selling ","My Earnings"};
 mymenutablinks=new String[]{"http://www.eventbee.com/ningapp/ntstab?oid="+oid,"http://www.eventbee.com/ningapp/earningstab?oid="+oid};

}
else if("Transaction Management".equalsIgnoreCase(mtype )  ){
 mymenutabs=new String[]{"Google Transactions","PayPal Transactions","Eventbee Transactions"};
 mymenutabnames=new String[]{"Google Transactions ","PayPal Transactions","Eventbee Transactions"};
 mymenutablinks=new String[]{"http://www.eventbee.com/ningapp/ticketing/transactionmanagement.jsp?type=google&platform=ning&status=v&GROUPID="+GROUPID,"http://www.eventbee.com/ningapp/ticketing/transactionmanagement.jsp?type=paypal&platform=ning&status=v&GROUPID="+GROUPID,"http://www.eventbee.com/ningapp/ticketing/transactionmanagement.jsp?type=eventbee&platform=ning&status=v&GROUPID="+GROUPID};

}



%>




<table height='10'><tr><td></td></tr></table>

<%
if(mymenutabs.length>0){

if(tabtype==null||"null".equals(tabtype))
tabtype=mymenutabs[0];

%>
<table width='100%'  cellspacing="0" cellpadding="0"  >
<tr>
 <td   align='left'  >
<%
	for(int i=0;i<mymenutabs.length;i++){
	    if(tabtype.equals(mymenutabs[i]))
		tabclass="desitabcont mytab1";
		else
		tabclass="desitabcont mytab2";
if("ntsapp".equals(request.getParameter("homelink"))){	
%>
<span class="<%=tabclass %>" ><a href="#" onclick="tabsmenu('<%=mymenutablinks[i]%>');">
	<%=mymenutabnames[i] %></a></span>

<%}else{%>
	
	<span class="<%=tabclass %>" ><a href="<%=mymenutablinks[i]%>">
	<%=mymenutabnames[i] %></a></span>
	
<%}
	}//end for
%>
					


</td></tr>
<tr class='tabhighlightcolor' id='ebeemenu'>
<td   height="20" align='left' id='linkstd'>
<%
	for(int i=0;i<mysubmenus.length;i++){
	
%>
	
	<span  <%=getSelectedMenu(mysubmenus[i],ltype) %>>	
	<a href='<%=mysubmenulinks[i]%>'><%=mysubmenus[i]%></a>
	<%if(i<mysubmenus.length-1){%> | <%}%>
	</span>
<%
	}//end for
%>
</td>	
</tr>
<div id="gap" height='10'></div>
<tr><td id='updatemembers'></td></tr>
</table>
<%}%>

<table width="100%">

<tr>

 	<td <%=  (request.getAttribute("tasktitle")!=null)?"class='taskheader'":""  %>     >
	
	 <% if(request.getAttribute("tasktitle") !=null){ %>
	 	<div  style='float:left'>
		 <%=request.getAttribute("tasktitle") %>
		 </div>
		 <% }%>
		
<% 
String tmp_subtitle=" ";
		 if(request.getAttribute("tasksubtitle") !=null)
	 tmp_subtitle=((String)request.getAttribute("tasksubtitle")).trim();
	  if("".equals(tmp_subtitle))
		tmp_subtitle=" ";
	  %>
	  <% if(request.getAttribute("tasktitle") !=null){%>
	   <div style='float:right'><%=tmp_subtitle%></div>
	   <%}%>
	</td>
 	
 </tr>
 </table>



