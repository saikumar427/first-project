<%@page import="com.eventbee.layout.DBHelper"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>	
<%@ page import="com.eventbee.creditcard.*,com.eventregister.*" %>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.general.*" %>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file="precheck.jsp"%>
<%@ include file='/globalprops.jsp' %>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String tid=newTrnId;
String eid=request.getParameter("eid");
String reqscheme=request.getParameter("scheme");
System.out.println(eid+"::scheme::"+reqscheme);
if(reqscheme!=null && "https".equals(reqscheme))
serveraddress="https://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

DbUtil.executeUpdateQuery("update event_reg_details_temp set selectedpaytype=?,collected_servicefee=0  where tid=?",new String[]{"eventbee",tid});
RegistrationTiketingManager ticketingManager=new RegistrationTiketingManager();
HashMap buyerDetails=ticketingManager.getBuyerDeails(tid);
String m_cardamount="0";
String status1="";
ProfileData m_ProfileData=new ProfileData();
HashMap regDetails=ticketingManager.getRegTotalAmounts(tid);
if(regDetails!=null&&regDetails.size()>0){
m_cardamount=(String)regDetails.get("grandtotamount");
status1=(String)regDetails.get("status");
}

if(buyerDetails!=null&&buyerDetails.size()>0){
m_ProfileData.setFirstName((String)buyerDetails.get("fname"));
m_ProfileData.setLastName((String)buyerDetails.get("lname"));
m_ProfileData.setEmail((String)buyerDetails.get("email"));
m_ProfileData.setPhone((String)buyerDetails.get("phone"));
}
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"

"http://www.w3.org/TR/xhtml1/DTD/transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
<head profile="http://gmpg.org/xfn/1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="en">
<meta name="robots" content="index, follow">
<meta name="Keywords" content="online registration, registration software, online ticketing, event ticketing,eventbee" />
<script src='/home/js/i18n/<%=DBHelper.getLanguageFromDB(eid) %>/regprops.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/ccstates.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/popup.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/payments_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>
<script src='/home/js/widget/iframehelper.js' type='text/javascript'></script>
<script language="javascript" src="/home/js/enterkeypress.js" ></script>
<style>
#cvvimg{ position: absolute; top: 10px; left:118px; visibility:hidden; z-index: 500;border:20px solid #DDDDDD;border-radius:10px 10px 10px 10px;
}

</style>
<script>
function showimg()
{
document.getElementById('cvvimg').style.visibility = "visible";
}
function hideimg()
{
document.getElementById('cvvimg').style.visibility = "hidden";
}




function cancelRedirect(){
var url="<%=serveraddress%>/embedded_reg/cancelredirect.jsp";
	window.location.href=url;
}
function activatePlaceholders() 
{
	var detect = navigator.userAgent.toLowerCase();
	if (detect.indexOf("") > 0) 
	return false;
	var inputs = document.getElementsByTagName("input");
	for (var i=0;i<inputs.length;i++) 
	{
	  if (inputs[i].getAttribute("type") == "text") 
	  {
		if (inputs[i].getAttribute("placeholder") && inputs[i].getAttribute("placeholder").length > 0) 
		{
			if(inputs[i].value.length==0)
			inputs[i].value = inputs[i].getAttribute("placeholder");
			inputs[i].onfocus = function() 
			{
				 if (this.value == this.getAttribute("placeholder")) 
				 {
					  this.value = "";
					  this.style.color ="black";
				 }
				 return false;
			}
			inputs[i].onblur = function() 
			{
				 if (this.value.length < 1) 
				 {
					  this.value = this.getAttribute("placeholder");
					  this.style.color ="darkgray";
				 }
			}
		}
	  }
	}
}
window.onload=function() {
activatePlaceholders();
}
</script>
<%@include file="eventpagecss.jsp"%>
<style>
#cardScreenContent {background-color:#FFFFFF;}
 #cardScreenContent td{ color: #000000; }
 #cardScreenContent #paymenterror td{ color: #FF0000; } 
.boxcontent{background-color:#FFFFFF;}
.buyticketssubmit{
	height:auto !important;
}
</style>
</head>
<body>

<div class='box' id="cardScreenContent">
<div id='paymenterror' class='error'></div>
<form name='form-register-event'   id="form-register-event" view="payment" action="/embedded_reg/ccvalidateaction.jsp"  method="post"   >
<table width='100%'  class='boxcontent'>
<input type='hidden' name='tid' id='tid' value='<%=tid%>' />
<input type='hidden' name='eid' id='eid' value='<%=eid%>' />
<input type='hidden' name='totalamount' id='totalamount' value='<%=m_cardamount%>' />

<tr><td>
<table class='boxcontent'>
<tr>
<td>
<jsp:include page='CreditCardScreen.jsp'>
<jsp:param name='GROUPID' value='<%=eid%>' />
<jsp:param name='totamount' value='<%=m_cardamount%>' />
</jsp:include>
</td>
</tr> 
</table> 
</td></tr>
<tr><td id='ebeepay'>
<table align="center">
<tr><td align="center"  class="buyticketssubmit">
<input type="button" value="<%=getPropValue("wl.submit",eid) %>" class="buyticketsbutton" onmouseout="javascript:this.className='buyticketsbutton';" onmouseover="javascript:this.className='buyticketsbuttonhover';" onClick="AjaxSubmit('submit'); "/>
</td><td></td>
<td align="center"  class="buyticketssubmit">
<input type="button" value="<%=getPropValue("wl.cancel",eid) %>" class="buyticketsbutton" onmouseout="javascript:this.className='buyticketsbutton';" onmouseover="javascript:this.className='buyticketsbuttonhover';" onClick="cancelRedirect();"/>
</td></tr> 
</table> 
</td></tr>
<tr>
<td align="center" id="paystatus"></td>
</tr>  
</table>
</form>
</div>
<div id="errormsg" style="display:none;">
</div>
</body>
</html>