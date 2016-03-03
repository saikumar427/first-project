<%@ page import="java.util.HashMap,com.eventbee.general.EbeeConstantsF,com.eventbee.general.AuthUtil,com.eventbee.general.PageUtil" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.Authenticate" %>
<%@ page import="com.eventbee.eventpartner.PartnerDB" %>

<%
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
String userid=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null) userid=authData.getUserID();
HashMap hm=PartnerDB.getPartnerDetails(userid);
String status=(String)hm.get("status");
String partnerid=(String)hm.get("partnerid");
String platform = request.getParameter("platform");
if(platform==null) platform="";
String URLBase="mytasks";
if("ning".equals(platform)){	
	URLBase="ningapp";
}
%>

<div class='memberbeelet-header'>My Network Event Listing Participation</div>
<% if(hm!=null&&!hm.isEmpty()){%>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<form name="form"  action="/<%=URLBase%>/leavepartner.jsp" method="POST">
<input type="hidden" name="purpose" value="leavepartner"/>
<input type='hidden' name='partnerid' value='<%=partnerid%>'/>
<input type='hidden' name='platform' value='<%=platform%>'/>

<tr class="evenbase"><td colspan='2'align='right'>Status: <%=status%> &nbsp;
<a href="/<%=URLBase%>/eventeditpartner.jsp?partnerid=<%=partnerid%>&UNITID=13579&type=edit&platform=<%=platform%>" >Edit</a>&nbsp;&nbsp;
<input type="submit" name="submit" value="Leave the program"/></td></tr>
<tr ><td class="evenbase"></td></tr>
<tr ><td class="evenbase" colspan="5" align="left">Allow your website or blog visitors to list events directly on your site for a fee. Copy and paste following code on your site to display Events Streamer (widget)
<br/><a href="/portal/<%=URLBase%>/streamingAttributes.jsp?partnerid=<%=(String)hm.get("partnerid")%>&platform=<%=platform%>">Click here to customize your Streamer</a><br/><br/>

<jsp:include page="/partnerstreamer/getStreamCode.jsp">
<jsp:param name="cols" value="36"/>
<jsp:param name="rows" value="4"/>
<jsp:param name="partnerid" value="<%=partnerid%>"/>
</jsp:include>
</td></tr>
</form>
</table>
<%}
else{%>
<table border="0" cellpadding="5" cellspacing="0" width="100%">
<form name="form"  action="/<%=URLBase%>/joinpartner.jsp" method="POST">
<input type="hidden" name="purpose" value="joinprogram"/>
<input type="hidden" name="isnew" value="yes" />
<input type='hidden' name='platform' value='<%=platform%>'/>

<tr >

<%= PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
<td class="colheader" colspan='2' align="right"><input type="submit" name="submit" value="Join Network"/></td></tr>
</form>
</table>


<%}%>

