<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.EventDB" %>
<%@ include file="/../plaxo_js.jsp" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%!
	Vector getCommissiondetails(String groupid,String partnerid)
	{
		Vector commissionvector=new Vector();
		DBManager dbmanager=new DBManager();
		HashMap hm = null; 
		
		StatusObj statobj=dbmanager.executeSelectQuery("select a.ticket_name,a.networkcommission as commision ,a.price_id,a.ticket_price, partnerlimit from price a where evt_id=cast(? as numeric) and a.price_id not in(select c.price_id from partner_ticket_commision c where partnerid=?) UNION  select b.ticket_name,c.commision,c.price_id,b.ticket_price, c.partnerlimit from price b,partner_ticket_commision c where c.partnerid=? and c.price_id=b.price_id and b.evt_id=cast(c.eventid as integer) and b.evt_id=cast(? as integer)",new String [] {groupid,partnerid,partnerid,groupid});  
		
	if(statobj.getStatus())
	  {   
        for(int k=0;k<statobj.getCount();k++)
			{
			hm=new HashMap();
			hm.put("ticket_name",dbmanager.getValue(k,"ticket_name",""));
			hm.put("networkcommission",dbmanager.getValue(k,"commision",""));
			hm.put("ticket_price",dbmanager.getValue(k,"ticket_price",""));
			hm.put("max_ticket",dbmanager.getValue(k,"partnerlimit","")); 
			
			commissionvector.add(hm);
			}
	  }
	  
	 return commissionvector;
	}
	String getEventinfo(String groupid){
	
	HashMap eventinfoMap=EventDB.getMgrEvtDetails(groupid);
	String startdate=(String)eventinfoMap.get("startdate")+", "+(String)eventinfoMap.get("starttime");
	String enddate=(String)eventinfoMap.get("enddate")+", "+(String)eventinfoMap.get("endtime");
	String address=GenUtil.getCSVData(new String[]{(String)eventinfoMap.get("city"),(String)eventinfoMap.get("state"), (String)eventinfoMap.get("country")});
	StringBuffer evtinfo=new StringBuffer("<b>When:</b><br>Starts - ");
	evtinfo.append(startdate);
	evtinfo.append("<br>Ends - ");
	evtinfo.append(enddate);
	evtinfo.append("<br><b>Where:</b><br>");
	evtinfo.append(address);
	return evtinfo.toString();	
	}

HashMap GetGroupAgentSettings(String groupid)
{
	DBManager dbm =new DBManager();
	HashMap hm=null;
	StatusObj statobj;
	String query="select participationtype,salecommission,webeditable,socialeditable,friendshare,webshare  from group_agent_settings where groupid=? ";
	  statobj=dbm.executeSelectQuery(query,new String[]{groupid});
	 
	  
	  if(statobj.getStatus())
	  {
	  	hm=new HashMap();
		hm.put("participationtype",dbm.getValue(0,"participationtype",""));
		hm.put("salecommission",dbm.getValue(0,"salecommission",""));
		hm.put("webeditable",dbm.getValue(0,"webeditable",""));
		hm.put("socialeditable",dbm.getValue(0,"socialeditable",""));
		hm.put("friendshare",dbm.getValue(0,"friendshare","50"));
		hm.put("webshare",dbm.getValue(0,"webshare","0"));
	  }	
	return hm;

}
%>  

<%
	String userid="";
	String serveradd="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData!=null)	userid= authData.getUserID();
	String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
	String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid"});
	String mgrname=DbUtil.getVal("select login_name from authentication where user_id=(select mgr_id::varchar from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{groupid});	
	String regurl=ShortUrlPattern.get(mgrname)+"/event?eventid="+groupid+"&fid=1&pid="+partnerid;
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	String config_id="0";
	String fbconnapi=(String)session.getAttribute("FBCONNECTAPIKEY");
	if(fbconnapi==null){
		fbconnapi=DbUtil.getVal("select value from config where name='ebee.fbconnect.api' and config_id=?",new String[]{"0"});
		session.setAttribute("FBCONNECTAPIKEY", fbconnapi);
}
	
	String bundleid=DbUtil.getVal("select value from config where name='ebee.fbconnect.publishfeed.invitefriendtoevent.bundleid' and config_id=?",new String[]{config_id});
	String arrowchar="&raquo;";
	HashMap detailsmap=GetGroupAgentSettings(groupid);
	String participationtype="";
	String friendshare="";
	String webshare="";
	if(detailsmap!=null)  {
		participationtype=(String)detailsmap.get("participationtype");
		friendshare=(String)detailsmap.get("friendshare");
		webshare=(String)detailsmap.get("webshare");
}
	String WebMessage="";
	String SocialMessage="";
	int socialcomm=100-Integer.parseInt(friendshare);
	int webcomm=100-Integer.parseInt(webshare);
	if(webcomm==100) 
		WebMessage="Selling with Website Integration - "+webcomm+"% to you.";
	else
		WebMessage="Selling with Website Integration - "+webcomm+"% to you, "+webshare+"% to Attendee.";
	SocialMessage="Selling with Inform Friends - "+socialcomm+"% to you, "+friendshare+"% to friend.";
	String Message="";
	if("2".equals(participationtype)){
		Message=SocialMessage;
		}
	if("3".equals(participationtype)){
		Message=SocialMessage + " " + WebMessage;
		
	}if("1".equals(participationtype)){
		Message=WebMessage;
	}
	
%>
<body>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Ticket Selling");
%>
<jsp:include page='/ningapp/mytabsmenu.jsp' />


<link rel="stylesheet" type="text/css"  href="/home/css/webintegration.css" />
<script language="JavaScript" type="text/javascript" src="/home/js/webintegration_ning.js" >
	function dummy(){}
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/dhtmlpopup.js">
        function dummy1() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy3() { }
</script>
	
<table>
<tr><td></td><td >
<%if("yes".equals(request.getParameter("success"))){%>
	<span align="right"  width="20" height="10"  id="loginerror"/>Invitation sent to your selected Friends
</span>
	<%}%>
	<%if("y".equals(request.getParameter("changed"))){%>
	<span align="right"  width="10" height="10"  id="loginerror"/>Changed Commission Settings
	</span>
	<%}%>
	<%if("yes".equals(request.getParameter("error"))){%>
		<span align="right"  width="10" height="10"  id="loginerror"/>Invitation is not sent
		</span>
	<%}%>
	</td></tr>
	<table>
	<%if("3".equals(participationtype) || "1".equals(participationtype)){%>
<tr><td colspan="2"><b> Website Integration</b></td></tr>
<tr><td></td><td> <%=arrowchar%> <a href="#" onclick="webintegration('<%=partnerid%>','<%=request.getParameter("groupid")%>');">Text & Button Links
</a></td></tr>
<%}%>
<%if("3".equals(participationtype) || "2".equals(participationtype)){%>
<tr><td height="15"></td></tr>
<tr><td colspan="2"><b>Inform Friends</b></td></tr>

<tr><td></td><td> <%=arrowchar%> <a href="#" onclick="invitefriends('<%=partnerid%>','<%=request.getParameter("groupid")%>');"> Invite  Friends</a>
</td></tr>
<tr><td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;Enter your friends email IDs to invite to the event
</td></tr>
<%}%>
<tr><td height="2"></td></tr>

<tr><td colspan="2"><br><b>Commission</b></td></tr>
<tr><td></td><td>

<table cellpadding="0" cellspacing="0" align="center"  width="100%">

 	<tr><td height="15"></td></tr>
<table cellpadding="0" cellspacing="0" align="center"  width="100%">
<tr><td id="commerror1" class="error" ></td></tr>
<tr>
<td class='colheader' ><b>Ticket Name</b></td>
<td class='colheader'><b>Ticket Price</b></td>
<td class='colheader'><b>Commission</b></td>
<td class='colheader'><b>Ticket Allocation/Partner</b></td>

</tr>

<%
    Vector v1=null;		
	String base="evenbase";
	v1=getCommissiondetails(groupid,partnerid);
    if(v1!=null&&v1.size()>0){
	for(int i=0;i<v1.size();i++){
		base=(i%2==0)?"oddbase":"evenbase";
	HashMap hmt=(HashMap)v1.elementAt(i);
	String ticket_name = (String)hmt.get("ticket_name"); 
	String networkcommission = (String)hmt.get("networkcommission"); 
	String ticket_price = (String)hmt.get("ticket_price"); 
	String max_ticket = (String)hmt.get("max_ticket");
	
%>
<tr ><td class=<%=base %>><%=ticket_name %></td>
<td class=<%=base %>><%=CurrencyFormat.getCurrencyFormat("$",ticket_price,true)%></td>
<td class=<%=base %>><%=CurrencyFormat.getCurrencyFormat("$",networkcommission,true)%></td>
<td class=<%=base %> align="center"><%=max_ticket%></td>

</tr>


<%    
  }
    }
%>
<tr><td height="15"></td></tr>
<tr></table>


<font class='smallestfont'>Default commission split: <%=Message%>
</font>
</td></tr>
<tr><td></td><td> <%=arrowchar%> <a href="#" onclick="commissionsettings('<%=partnerid%>','<%=request.getParameter("groupid")%>');"> Edit Commission Settings</a></td></tr>
</table>  


</body>
