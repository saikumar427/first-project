<%@ page import="java.util.*,java.sql.*,java.io.*,java.net.*" %>
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>




<%
	//request.setAttribute("tasktitle","Blog");
	//request.setAttribute("tasksubtitle","Search");
	
	request.setAttribute("tabtype","lifestyle");
	request.setAttribute("subtabtype","My Lifestyle");
//String UNITID=(request.getParameter("UNITID")!=null)?request.getParameter("UNITID"):"13579";
%>

<%@ include file="/stylesheets/toplnf.jsp" %>

<style type="text/css">
.box{ border: #999999 solid; border-width: 1px 1px 1px 1px; font-family: Verdana, Arial, Helvetica, sans-serif;padding-left:10px;padding-top:10px;margin-top:10px}
.entry{background-color:  #9999CC; }
p1{background-color: #6699FF; }
</style>


<%
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String qurey=request.getParameter("q");
String username=(request.getParameter("username")==null)?"":request.getParameter("username");


//  http://192.168.1.50:8080/lifestyle/searchblog1.jsp?q=second&username=reddynr
%>
<%--="qurey"+ qurey--%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class="portalback">


<%--<tr><td><jsp:include page='searchblog.jsp' /></td></tr>--%>
  <tr>
    <td valign="top">

<%



String myservername="http://"+request.getServerName();
String serverport=""+request.getServerPort();


//String url="http://"+EbeeConstantsF.get("serveraddress","192.168.1.51:8080")+rollercontext+"/maineroller.do" ;
String url=myservername+":"+serverport+rollercontext+"/search" ;
HashMap parammap=new HashMap();
CoreConnector cc1=new CoreConnector(url);
parammap.put("q",qurey);
cc1.setTimeout(30000);
cc1.setArguments(parammap);
 out.println(cc1.MGet() );

%>
</td>
</tr>

<tr><td>
	<table width='100%'>
	<tr>
	<td class='inputlabel'>Search Again </td>
	<td class='inputvalue'>
	<form  method="get" action="/lifestyle/searchblog1.jsp" style="margin: 0; padding: 0" onsubmit="return validateSearch(this)">
	<input type="text" id="q" name="q" size="20" maxlength="255" value="<%= qurey%>" />
	<input type="submit" value="Go" />
	<!--input type='hidden' name="UNITID" value="<%--=UNITID --%>" /-->
	</form>
	
	</td>
	</tr>
	
	<tr><td align='center' colspan='3'><a href="/portal/lifestyle/lifestyleview.jsp" >Back to Lifestyle</a> </td></tr>
	
	</table>
</td></tr>


</table>
<%@ include file="/stylesheets/bottomlnf.jsp" %>
