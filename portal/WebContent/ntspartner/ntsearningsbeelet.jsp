<%@ page import="java.util.HashMap,java.util.Vector,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbeepartner.partnernetwork.EarningDetails" %>

<% 
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	String userid=(authData !=null)?authData.getUserID():"";
 	String creditedearning="";
 	String waitforcreditearning="";
 	String agentid=(String)session.getAttribute(userid+"_partnerid");
   	String platform = request.getParameter("platform");
	String linktarget="_self";
	String URLBase="mytasks";
        String oid=request.getParameter("oid");
	if("ning".equals(platform)){
		userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
		agentid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
		System.out.println("agentid--->"+agentid);		
		linktarget="_blank";
		URLBase="ningapp";
	}
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");	
   	
   	EarningDetails earningdet=new EarningDetails();
	Vector eventsList=earningdet.getEarningEventsInfo(agentid);
	HashMap creditedEarningsMap=earningdet.getEarningsInfo("credited", agentid);
	HashMap waitforcreditEarningsMap=earningdet.getEarningsInfo("waiting for credit", agentid);
	 


%>
  <script> 
  function reports(eid,partnerid,platform){ 
 	window.location.href="/portal/<%=URLBase%>/partner_reports.jsp?platform="+platform+"&UNITID=13579&GROUPID="+eid+"&agentid="+partnerid;
	  } 
  </script>
  <table cellpadding="0" cellspacing="0" align="center" width="100%">
    <tr><td colspan='3'>
    <div class='memberbeelet-header'>Network Ticket Selling</div>
  </td></tr>
  </table>
  <div STYLE=" height: 210px; overflow: auto;">
  <table cellpadding="0" cellspacing="0" align="center" width="100%">
  
  
<%		
 if(eventsList.size()>0){	
	for(int i=0;i<eventsList.size();i++){
		HashMap hm=(HashMap)eventsList.elementAt(i);
		String eid=GenUtil.getHMvalue(hm,"eventid","");
	 	creditedearning=GenUtil.getHMvalue(creditedEarningsMap,eid,"0");
		waitforcreditearning=GenUtil.getHMvalue(waitforcreditEarningsMap,eid,"0");
		String base=(i%2==0)?"evenbase":"oddbase";			
	String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eid});
	         if(currency==null)
		currency="$";
%>
  <tr>
  <td align="left" class="<%=base%>" valign='top' colspan='3'>
<%
if("ning".equals(platform)){
%>
  <a href='#' onclick=registerevent('<%=eid%>','<%=platform%>')><%= GenUtil.TruncateData(GenUtil.getHMvalue(hm,"eventname",""),26)%></a>
<%}else{%>               
  <a href="<%=serveraddress%>/event?eid=<%=eid%>" target="<%=linktarget%>"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hm,"eventname",""),26)%></a>
<%}%>
</td>
<input type='hidden' name='agentid' value='<%=agentid%>' />
<td class="<%=base%>" align="center"><a href="#" onclick="javascript:reports('<%=eid%>','<%=agentid%>','<%=platform%>');">Report</a></td>
  
  </tr>
  <!--<tr > 
  <td align="left" class="<%=base%>"><%=currency%><%=creditedearning%> (credited)</td>
  <td align="left" class="<%=base%>"><%=currency%><%=waitforcreditearning%> (waiting for credit)</td>
 
  
  <td class="<%=base%>" align="center"><a href="#" onclick="javascript:reports('<%=eid%>','<%=agentid%>','<%=platform%>');">Report</a></td>
  </tr> -->
<%
   	}		
  }else{	
%>
  <tr><td class="evenbase" colspan="4" width="100%">No Tickets Sold</td></tr>
<%}%>
</table>	
</div>