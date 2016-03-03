<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.creditcard.*" %>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.general.*" %>
<%@ include file="TicketingManager.jsp" %>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
TicketingManager ticketingManager=new TicketingManager();
String oid=null;
String domain=null;
HashMap networkMap=ticketingManager.getNetWorkDetails(tid);
if(networkMap!=null&&networkMap.size()>0){
domain=(String)networkMap.get("domain");
oid=(String)networkMap.get("oid");
}
String m_cardamount="0";
String status="";
String eventpageLink="/event?eid="+eid+"&platform=ning"+(oid!=null?"&oid="+oid:"")+(domain!=null?"&domain="+domain:"");
ProfileData m_ProfileData=new ProfileData();
HashMap regDetails=ticketingManager.getRegTotalAmounts(tid);
if(regDetails!=null&&regDetails.size()>0){
m_cardamount=(String)regDetails.get("grandtotamount");
status=(String)regDetails.get("status");
}

Vector attendeeDetails=ticketingManager.getProfileResponses(tid);
if(attendeeDetails!=null&&attendeeDetails.size()>0){
HashMap attendee=(HashMap)attendeeDetails.elementAt(0);
m_ProfileData.setFirstName((String)attendee.get("fname"));
m_ProfileData.setLastName((String)attendee.get("lname"));
m_ProfileData.setEmail((String)attendee.get("email"));
m_ProfileData.setPhone((String)attendee.get("phone"));
}
String registrationlink="/ningregister/register.jsp?eid="+eid+"&tid="+tid;
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eid});
CreditCardModel m_card=new CreditCardModel();
HashMap hm=new HashMap();
hm.put(CardConstants.INTERNAL_REF,tid);
hm.put(CardConstants.REQUEST_APP,"EVENT_REGISTRATION");
hm.put(CardConstants.TRANSACTION_TYPE,CardConstants.TRANS_ONE_TIME);
hm.put(CardConstants.BASE_REF,"/card");
hm.put(CardConstants.LOGO_URL,"");
hm.put(CardConstants.AUTH_POLICY,"");
hm.put(CardConstants.AUTH_URL,"");
hm.put(CardConstants.AMOUNT,""+m_cardamount);
m_card.setParams(hm);
m_card.setProfiledata(m_ProfileData);  
request.setAttribute("ccm",m_card);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<link rel="stylesheet" type="text/css" href="/home/customlisting.css" />
<style>
<%@ include file="ticketpagecss.jsp" %>
</style>
<!--------*****************************************BEGIN MANDATORY SECTION DO NOT CHANGE*******************************----->
<script type="text/javascript" language="JavaScript" src="/home/js/ajaxjson.js"></script>
<script type="text/javascript" language="JavaScript" src="ccprocessingjs.jsp"></script>
<script language="javascript" src="/home/js/enterkeypress.js" ></script>

<!--------*****************************************END MANDATORY SECTION *******************************----->

</head>
<body >
<div id="topcontainer">
<div id="container">
<table width="100%">
<tr><td class='taskheader'>
<div  style='float:left'>
<a href='<%=eventpageLink%>'><%=eventname%></a> > <a href='<%=registrationlink%>'>Registration</a> > Payment
</div>
</td>
</tr>
</table>

<div id='paymenterror' class='error'></div>
<div id='center'>

<form name='form-register-event'   id="form-register-event" view="payment" action="/ningregister/ccvalidateaction.jsp"  method="post"   >
<input type='hidden' name='tid' value='<%=tid%>' />
<input type='hidden' name='totalamount' id='totalamount' value='<%=m_cardamount%>' />
<table width='100%'>
<tr><td>
<table>
<tr>
<td>
<jsp:include page='CreditCardScreen.jsp'>
<jsp:param name='GROUPID' value='<%=eid%>' />
</jsp:include>
</td>
</tr> 
</table> 
</td></tr>
<tr><td>
<table align="center">
<tr><td align="center">
<input type="button" value="Submit" onClick="ajaxValidateCard()"/>
</td>
<td align="center">
<input type="button" value="Previous" onClick="javascript:window.history.back()"/>
</td></tr> 
</table> 
</td></tr>  
</table>
</form>
<form name='confirmationform' id='confirmationform' action='<%=serveraddress%>/ningregister/registrationdone.jsp' method='post'>
<input type='hidden' name='tid' value='<%=tid%>' />
<input type='hidden' name='eid' value='<%=eid%>' />
<input type='hidden' name='paytype' value='eventbee' />
</form>

</div>
</div> <!--container-->
<script>
getTransactionAmounts('<%=tid%>','<%=eid%>');
</script>
<div id='footer'>
<%@ include file="footer.jsp" %>
</div>
</div><!--topcontainer-->
</body>
</html>
  
  

