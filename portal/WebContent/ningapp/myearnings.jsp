<%@ page import="com.eventbee.general.EbeeConstantsF,com.eventbee.general.AuthUtil" %>
<%@ page import="com.eventbee.authentication.Authenticate,com.eventbee.general.formatting.CurrencyFormat"%>
<%@ page import="com.eventbeepartner.partnernetwork.EarningDetails" %>

<%	
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	String userid=(authData !=null)?authData.getUserID():""; 	
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String url=serveraddress+"/home/links/Myearnings.html";
	String agentid=(String)session.getAttribute(userid+"_partnerid");
	EarningDetails earningdet=new EarningDetails();
	String creditedtotalNTS=earningdet.getNTSEarningsInfo("credited",agentid);
	String waitforcredittotalNTS=earningdet.getNTSEarningsInfo("waiting for credit",agentid);
	String listingTotalEarning=earningdet.getNListingEarningsInfo(agentid);
    	String CPMTotalEarning=earningdet.getImpressionEarningsInfo(agentid);
    	String CPCTotalEarning=earningdet.getClickEarningsInfo(agentid);
    	CurrencyFormat cf=new CurrencyFormat();
%>
	<script language="javascript" src="/home/js/popup.js">
         	function dummy(){}
	</script>	
	<table cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr><td colspan='3'>
	<div class='memberbeelet-header'>My Earnings [<a href='javascript:popupwindow("<%=url%>","myearnings","600","400");'>?</a>]</div>
	</td></tr>
	<tr><td colspan='3' class='colheader'>Network Ticket Selling </td></tr>
	<tr><td colspan='3' class='evenbase' width='100%'>Total credited earnings: <%=cf.getCurrencyFormat("$",creditedtotalNTS,true)%></td></tr>
	<tr><td colspan='3' class='evenbase' width='100%'>Total waiting for credit earnings: <%=cf.getCurrencyFormat("$",waitforcredittotalNTS,true)%></td></tr>
	
	</table>	