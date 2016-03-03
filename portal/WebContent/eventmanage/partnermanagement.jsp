<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%!
public Vector getApprovedPartnerdetails(String groupid)
{
	String s1="",s2="";
	Vector v= new Vector();
	DBManager dbm =new DBManager();
	HashMap userhashmap=null;
	StatusObj statobj=null;
	String	query1="select a.first_name,a.last_name,a.user_id,a.title,a.email,b.url,b.partnerid from user_profile a,group_partner b where a.user_id=b.userid and b.partnerid in(select partnerid  from manual_nts_events where eventid=? and status='Approved')";
	statobj=dbm.executeSelectQuery(query1,new String[]{groupid});
	
	if(statobj.getStatus()){
		for(int k=0;k<statobj.getCount();k++){
			userhashmap=new HashMap();
			userhashmap.put("first_name",dbm.getValue(k,"first_name",""));
			userhashmap.put("last_name",dbm.getValue(k,"last_name",""));
			userhashmap.put("email",dbm.getValue(k,"email",""));
			userhashmap.put("title",dbm.getValue(k,"title",""));
			userhashmap.put("url",dbm.getValue(k,"url",""));
			userhashmap.put("user_id",dbm.getValue(k,"user_id",""));
			userhashmap.put("partnerid",dbm.getValue(k,"partnerid",""));
			v.add(userhashmap);
		}
	}
	return v;
	}
public Vector getEventtickets(String groupid,String partnerid){

	Vector ticket= new Vector();
	DBManager dbm =new DBManager();
	HashMap hm=null;
	StatusObj statobj=null;

	String	query1="select a.ticket_name,a.networkcommission as commision ,a.price_id,a.ticket_price,a.partnerlimit  from price a where evt_id=cast(? as integer) and a.price_id not in(select c.price_id from partner_ticket_commision c where partnerid=?)"
				  +" UNION "
				  +" select b.ticket_name,c.commision,c.price_id,b.ticket_price,c.partnerlimit from price b,partner_ticket_commision c where c.partnerid=? and c.price_id=b.price_id and b.evt_id=cast(c.eventid as integer) and b.evt_id=cast(? as integer)";

	statobj=dbm.executeSelectQuery(query1,new String[]{groupid,partnerid,partnerid,groupid});

	if(statobj.getStatus()){
		for(int k=0;k<statobj.getCount();k++){
			hm=new HashMap();
			hm.put("ticket_name",dbm.getValue(k,"ticket_name",""));
			hm.put("commision",dbm.getValue(k,"commision",""));
			hm.put("priceid",dbm.getValue(k,"price_id",""));
			hm.put("ticket_price",dbm.getValue(k,"ticket_price",""));
			hm.put("partnerlimit",dbm.getValue(k,"partnerlimit",""));

			ticket.add(hm);
		}

	}
	return ticket;
	}

%>

<script>
function managePartner(groupid){
window.location.href='/mytasks/searchpartner.jsp?GROUPID='+groupid;
}
	   
</script> 

<%
	String groupid=null,grouptype=null;
	String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
   
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	if(hm!=null){
		groupid=(String)hm.get("groupid");
		grouptype=(String)hm.get("grouptype");
	}
	String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{groupid});
	   	      if(currency==null)
		currency="$";
	CurrencyFormat cf=new CurrencyFormat();	
	String base="oddbase";
	Vector v1=getApprovedPartnerdetails(groupid);	
	
%>

<table class="portaltable" align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
        <tr><td class='memberbeelet-header'>Partner Management</td></tr>
        <tr><td class='colheader' align="right"><input type="button" value="Add/Manage Partner" onclick="managePartner(<%=groupid%>);" ></td>
        </tr>
         </table>
<%

if(v1.size()>0){
   if(v1!=null&&v1.size()>0){
   for(int i=0;i<v1.size();i++){
   	   if(i%2==0)
   	  		base="evenbase";
   	  	else
   		base="oddbase";
   		  HashMap hmt=(HashMap)v1.elementAt(i);
   		  String first_name=(String)hmt.get("first_name");	
   		  String last_name=(String)hmt.get("last_name");		 
   		  String title=(String)hmt.get("title");
   		  String email =(String)hmt.get("email");
   		  
		  String partnerid=(String)hmt.get("partnerid");
		  String eventurl= serveraddress+"/eventdetails/event.jsp?eid="+groupid+"&pid="+partnerid;
%>        
<table  class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td colspan="3" class="<%=base%>">
<b>Name:</b> <%=first_name%> <%=last_name%>&nbsp;&nbsp;<a href="/portal/mytasks/partner_reports.jsp?UNITID=13579&filter=manager&GROUPID=<%=groupid%>&agentid=<%=partnerid%>">Report </a>
</td></tr>	
<tr><td class="<%=base%>" colspan="3">
<b>Email:</b> <%=email%>
</td></tr>
<tr><td class="<%=base%>" colspan="3">
<b>URL:</b> <%=eventurl%>
</td></tr>

<%
  Vector tickets=getEventtickets(groupid,partnerid);
  if(tickets!=null&&tickets.size()>0){
   for(int j=0;j<tickets.size();j++){  
   if(i%2==0)
      	  		base="evenbase";
      	  	else
   		base="oddbase";
  	HashMap ticketshashmap=(HashMap)tickets.elementAt(j);
  	String ticket_name=(String)ticketshashmap.get("ticket_name");
  	String commission=(String)ticketshashmap.get("commision");
  	String priceid=(String)ticketshashmap.get("priceid");
  	String ticket_price=(String)ticketshashmap.get("ticket_price");
  	String partnerlimit=(String)ticketshashmap.get("partnerlimit");
  	String sold=DbUtil.getVal("select sold_qty from price where evt_id=? and ticket_name=?",new String[]{groupid,ticket_name});

%>

<tr><td class="<%=base%>" align="left"><%=ticket_name%></td>
<td class="<%=base%>" align="right">(<%=CurrencyFormat.getCurrencyFormat(""+currency+"",ticket_price,true)%>):</td>
<td class="<%=base%>" align="left"><%=sold%>/<%=partnerlimit%>&nbsp;&nbsp;sold</td>

<%}
}%>
</table>
<%
}
}
}
%>