<%@ page import="com.eventbee.general.EbeeConstantsF,com.eventbee.general.AuthUtil,com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.authentication.Authenticate,com.eventbee.general.formatting.CurrencyFormat"%>
<%@ page import="com.eventbeepartner.partnernetwork.EarningDetails" %>

<%	
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	String userid=(authData !=null)?authData.getUserID():""; 	
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String url=serveraddress+"/home/links/Myearnings.html";
	String agentid=(String)session.getAttribute(userid+"_partnerid");
	String platform = request.getParameter("platform");
	String oid=request.getParameter("oid");	
	if("ning".equals(platform)){
		userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
		agentid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});					
	}
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
<%	if(!"ning".equals(platform)){
%>
	<tr><td colspan='3' class='colheader'>Network Event Listing </td></tr>
	<tr><td class='evenbase' colspan='3' width='100%'>Total earnings: <%=cf.getCurrencyFormat("$",listingTotalEarning,true)%></td></tr>
	<tr><td colspan='3' class='colheader'>Network Event Advertising </td></tr>
	<tr><td class='evenbase' colspan='3' width='100%'>Total CPM earnings: <%=cf.getCurrencyFormat("$",CPMTotalEarning,true)%></td></tr>
	<tr><td class='evenbase' width='100%' colspan='3'>
	Total CPC earnings: <%=cf.getCurrencyFormat("$",CPCTotalEarning,true)%></td></tr>

<%}%>
	<tr ><td class='evenbase' colspan='3'><font class='smallestfont'>NOTE: We will mail check when your earnings reach $250.</font></td></tr>
	</table>	