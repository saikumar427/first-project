<%@ page import="java.util.*,java.sql.*,java.io.*,java.net.*" %>
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<%
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String forcont=request.getParameter("forcont");
if(forcont==null)forcont="recentposts";

String displaylabel="Recent Blog Postings";

if("search".equals(forcont) )displaylabel="Search Blogs";
if("hotentries".equals(forcont) )displaylabel="Hot Blogs";

%>


<%-- out.println(PageUtil.startContentForGuest(displaylabel,request.getParameter("border"),request.getParameter("width"),true, "beelet-header" ) ); --%>
<div class='beelet-header'><%=displaylabel%></div>


<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class="portalback">
  <tr>
    <td valign="top">

<%



String myservername="http://"+request.getServerName();
String serverport=""+request.getServerPort();


//String url="http://"+EbeeConstantsF.get("serveraddress","192.168.1.51:8080")+rollercontext+"/maineroller.do" ;
String url=myservername+":"+serverport+rollercontext+"/maineroller.do" ;
HashMap parammap=new HashMap();
CoreConnector cc1=new CoreConnector(url);
parammap.put("forcont",forcont);
cc1.setTimeout(30000);
cc1.setArguments(parammap);
 out.println(cc1.MGet() );

%>
</td>
</tr>
</table>
<%-- out.println(PageUtil.endContent());--%>
