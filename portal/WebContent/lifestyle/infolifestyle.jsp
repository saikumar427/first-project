<%@page import="com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%!
String getSelectedMenu(String rmik, String tab){
String ret="tmItemLink";
if(rmik !=null){
ret=rmik.equals(tab)?"tmItemLinkSelected":ret;
}
return ret;
}
%>


<%

String serveraddress1 =(String)session.getAttribute("HTTP_SERVER_ADDRESS");

String lifestylescrname =(request.getAttribute("lifestylescrname") !=null)?(String)request.getAttribute("lifestylescrname"):"none";
String appname=EbeeConstantsF.get("application.name","");

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String subtype=(request.getParameter("stype")==null)?"view":request.getParameter("stype");

MemberFeatures featuresofunitreq1=(MemberFeatures)request.getAttribute("memberfeatures");

//String UNITID=(request.getParameter("UNITID")!=null)?request.getParameter("UNITID"):"13579";

String lifestyleurl=(request.getAttribute("lifestyleurl")!=null)?(String)request.getAttribute("lifestyleurl"):"";
%>

<%
if(request.getParameter("frompagebuilder") !=null)
//out.println(PageUtil.startContent("My Lifestyle",request.getParameter("border"),request.getParameter("width"),true) );
out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) );
%>

<table width="100%" class1="portaltable"   class='notitletable1'>
<%--<tr><td>My Lifestyle URL:</td></tr>
<tr><td><%=lifestyleurl %></td></tr>
--%>

<%--<tr><td align='left' valign='center' class='evenbase'>
 <a href="<%=ShortUrlPattern.get(lifestylescrname)%>"><img src="/home/images/mylifestyle.gif" border="0"></a>

</td></tr>
--%>
<tr><td class='evenbase'><b>Copy following HTML to link to your <%=appname%> Lifestyle page:</b></td></tr>

<tr><td class='evenbase'>
&lt;a href='<%=ShortUrlPattern.get(lifestylescrname)%>/network'&gt;&lt;img src='<%=serveraddress1 %>/home/images/mylifestyle.gif' border=0 /&gt;&lt;/a&gt;
</td></tr>


</table>

<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>
