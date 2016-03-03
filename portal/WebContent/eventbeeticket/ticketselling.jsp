<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat"%>
<%!
Vector getCommissiondetails(String groupid){
 	String query="select ticket_name,price_id,ticket_price,max_ticket,networkcommission,partnerlimit from price where evt_id=?";
 	DBManager dbmanager=new DBManager();
 	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid});
	Vector vec=new Vector();
	if(statobj.getStatus()){
		for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("ticket_name",dbmanager.getValue(i,"ticket_name",""));
			hm.put("priceid",dbmanager.getValue(i,"price_id",""));
			hm.put("ticket_price",dbmanager.getValue(i,"ticket_price",""));
			hm.put("commission",dbmanager.getValue(i,"networkcommission","1"));
			hm.put("partnerlimit",dbmanager.getValue(i,"partnerlimit",""));
			hm.put("maxcount",dbmanager.getValue(i,"max_ticket",""));
			vec.add(hm);
		}
	}
	return vec;
}
%>
<%

CurrencyFormat cf=new CurrencyFormat();
String eventid=request.getParameter("GROUPID");
Vector v=null;
String purpose1="comission";
String purpose2="ticketcount";
 String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eventid});
      if(currency==null)
		currency="$";
String from=request.getParameter("from");
//int position=v.size();
HashMap gm=null;
HashMap pricemap=new HashMap();
String position1="";
if("new".equals(request.getParameter("reload")))
v=getCommissiondetails(eventid);
else 
v=(Vector)session.getAttribute("NetworkCommission");

if(v==null)
v=new Vector();

HashMap updatemap=null;
Vector vec=new Vector();
String base="evenbase";
%>
<table cellpadding="0" cellspacing="0" align="center"  width="100%">
<tr><td id="commerror1" class="error" colspan="2" ></td></tr>
<tr><td class='colheader' ><b>Ticket Name</b></td><td class='colheader'><b>Ticket Price</b></td><td class='colheader'><b>Commission</b></td><td class='colheader'><b>Ticket Allocation/Partner</b></td></tr>
<%
if(v!=null&&v.size()>0){
for(int i=0;i<v.size();i++){
updatemap=(HashMap)v.elementAt(i);

if(updatemap==null)
updatemap=new HashMap();
%>
<%	

base=(i%2==0)?"oddbase":"evenbase";

%>

<tr><td  class='<%=base%>' ><%=(String)updatemap.get("ticket_name")%></td>
<td  class='<%=base%>' ><%=cf.getCurrencyFormat(""+currency+"",GenUtil.getHMvalue(updatemap,"ticket_price","1"),true)%></td>
<td class='<%=base%>'><table><tr><td  class='<%=base%>' id='editamount<%=(i+1)%>'><%=cf.getCurrencyFormat(""+currency+"",GenUtil.getHMvalue(updatemap,"commission","1"),true)%></td>
<td class='<%=base%>' id='editlink<%=(i+1)%>'><span  style="cursor: pointer; text-decoration: underline" onClick="editprice('<%=(i+1)%>','<%=(String)GenUtil.getHMvalue(updatemap,"commission","1.00")%>','<%=eventid%>','<%=purpose1%>');">Edit</span></td></tr></table></td>
<td class='<%=base%>'><table><tr><td  class='<%=base%>' id='ticketcount<%=(i+1)%>'><%=GenUtil.getHMvalue(updatemap,"partnerlimit","1")%></td>
<td class='<%=base%>' id='editcntlink<%=(i+1)%>'><span  style="cursor: pointer; text-decoration: underline" onClick="editprice('<%=(i+1)%>','<%=(String)GenUtil.getHMvalue(updatemap,"partnerlimit","1")%>','<%=eventid%>','<%=purpose2%>');">Edit</span></td></tr></table></td>

       <%     
			
			session.setAttribute("NetworkCommission",v);
			
		}}
	%>
</table>
