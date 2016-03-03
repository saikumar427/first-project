<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<%
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";

String userid=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null) userid=authData.getUserID();

HashMap hm=PartnerDB.getPartnerDetails(userid);
String status=(String)hm.get("status");
String partnerid=(String)hm.get("partnerid");
%>




<div class='memberbeelet-header'>My Network Event Listing Participation</div>
<% if(hm!=null&&!hm.isEmpty()){%>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<form name="form"  action="/ningapp/listauth.jsp" method="POST">
<input type="hidden" name="purpose" value="leavepartner"/>
<input type='hidden' name='partnerid' value='<%=partnerid%>'/>

<tr class="evenbase"><td colspan='2'align='right'>Status: <%=status%> &nbsp;
<a href="/ningapp/editpartner.jsp?partnerid=<%=partnerid%>&UNITID=13579&type=edit" >Edit</a>&nbsp;&nbsp;
<input type="submit" name="submit" value="Leave the program"/></td></tr>
<tr ><td class="evenbase"></td></tr>
<tr ><td class="evenbase" colspan="5" align="left">Allow your website or blog visitors to list events directly on your site for a fee. Copy and paste following code on your site to display Events Streamer (widget)
<br/><a href="/portal/ningapp/streamingAttributespage.jsp?partnerid=<%=(String)hm.get("partnerid")%>">Click here to customize your Streamer</a><br/><br/>

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
<form name="form"  action="/auth/listauth.jsp" method="POST">
<input type="hidden" name="purpose" value="joinprogram"/>
<input type="hidden" name="isnew" value="yes" />
<tr >

<%= PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
<td class="colheader" colspan='2' align="right"><input type="submit" name="submit" value="Join Network"/></td></tr>
</form>
</table>


<%}%>

