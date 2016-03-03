<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat"%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy3() { }
</script>
<link rel="stylesheet" type="text/css"  href="/home/css/webintegration.css" />
<script language="JavaScript" type="text/javascript" src="/home/js/webintegration.js" >
        function dummy() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/dhtmlpopup.js">
        function dummy1() { }
</script>
<%!
	Vector getCommissiondetails(String groupid){
		Vector commissionvector=new Vector();
		DBManager dbmanager=new DBManager();
		HashMap hm = null; 
		StatusObj statobj=dbmanager.executeSelectQuery("select distinct c.position,b.position, ticket_name,networkcommission,ticket_price from price a,group_tickets b ,event_ticket_groups c where to_number(b.price_id,'999999999999')=a.price_id and b.ticket_groupid=c.ticket_groupid  and evt_id=? order by c.position, b.position",new String [] {groupid});  
		if(statobj.getStatus()){   
			for(int k=0;k<statobj.getCount();k++){
				hm=new HashMap();
				hm.put("ticket_name",dbmanager.getValue(k,"ticket_name",""));
				hm.put("networkcommission",dbmanager.getValue(k,"networkcommission",""));
				hm.put("ticket_price",dbmanager.getValue(k,"ticket_price","")); 
				commissionvector.add(hm);
			}
		}	  
	return commissionvector;
	}
%>  
<table cellpadding="0" cellspacing="0" align="center"  width="100%">
<tr><td height="15" colspan="3"></td></tr>
<tr>
<td align="center" colspan="3">
Sell these event tickets and earn commissions on each ticket sale!
</td>
</tr>
<tr><td height="15" colspan="3"></td></tr>
<tr>
<td class='colheader' width="50%"><b>Ticket Name</b></td>
<td class='colheader' ><b>Ticket Price</b></td>
<td class='colheader' ><b>Commission</b></td>
</tr>

<%     
	String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id"});
	String base="evenbase";
	Vector v1=getCommissiondetails(groupid);
    	if(v1!=null&&v1.size()>0){
	for(int i=0;i<v1.size();i++){
		base=(i%2==0)?"oddbase":"evenbase";
	HashMap hmt=(HashMap)v1.elementAt(i);
	String ticket_name = (String)hmt.get("ticket_name"); 
	String networkcommission = (String)hmt.get("networkcommission"); 
	String ticket_price = (String)hmt.get("ticket_price"); 
%>
<tr ><td class="<%=base%>"><%=ticket_name %></td>
<td class="<%=base%>" ><%=CurrencyFormat.getCurrencyFormat("$",ticket_price,true)%></td>
<td class="<%=base%>" ><%=CurrencyFormat.getCurrencyFormat("$",networkcommission,true)%></td>
</tr>
<%    
  }
}
%>
<tr><td height="15" colspan="3"></td></tr>
<tr>
<td align="center" colspan="3">
<input type="button" value="Participate" onclick=getAuthdata('/portal/mytasks/partnerlinks.jsp?groupid=<%=groupid%>','/portal/fbauth/authdatacheck.jsp');>
 </td>
 </tr>
 <tr>
<td align="center" colspan="3" class="smallestfont"><a href='/portal/helplinks/partnernetwork.jsp' target='_blank'>Learn More</a></td></tr>
<tr><td height="15" colspan="3"></td></tr>
<tr><td height="15" colspan="3"></td></tr>
<tr><td height="15" colspan="3"></td></tr>
</table>

