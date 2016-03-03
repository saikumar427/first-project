<%@ page import="java.util.HashMap,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.Authenticate" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<%
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
String domain=(String)session.getAttribute("domain");
if(domain==null)
domain=request.getParameter("domain");
String domainurl="http://"+domain+"/opensocial/application/show?appUrl=http://www.eventbee.com/home/ning/networkticketselling.xml";


String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null) userid=authData.getUserID();

HashMap hm=PartnerDB.getPartnerDetails(userid);
String status=(String)hm.get("status");
String partnerid=(String)hm.get("partnerid");
String owner=(String)session.getAttribute("owner");
String oid=(String)session.getAttribute("ning_oid");
if(oid==null)
oid=DbUtil.getVal("select nid from ebee_ning_link where ebeeid=?",new String []{userid});
%>

<script>
function manage(oid){
top.location.href="<%=domainurl%>&owner="+oid;
}
</script>

<div class='memberbeelet-header'>My Network Event Listing Participation</div>
<% if(hm!=null&&!hm.isEmpty()){%>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<form name="form"  action="/ningapp/listauth.jsp" method="POST">
<input type="hidden" name="purpose" value="leavepartner"/>
<input type='hidden' name='partnerid' value='<%=partnerid%>'/>

<tr ><td class="evenbase" align='left'>Status: <%=status%>&nbsp;</td>
<td class="evenbase" align='right'>
<a href="#" onclick="manage('<%=oid%>')" >Manage</a></td></tr>

<tr ><td class="evenbase" colspan="5" align="left">Allow your website or blog visitors to list events directly on your site for a fee. Copy and paste following code on your site to display Events Streamer (widget)
<br/>

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
