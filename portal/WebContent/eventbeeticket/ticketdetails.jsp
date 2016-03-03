<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat"%>
<%!

Vector getcommdetails(String eventid){


String query="select ticket_name,ticket_price,networkcommission from price where evt_id=?";
DBManager dbmanager=new DBManager();
StatusObj stob=dbmanager.executeSelectQuery(query, new String []{eventid});
Vector v=new Vector();

if(stob.getStatus()){
for(int i=0;i<stob.getCount();i++){
HashMap hm=new HashMap();
hm.put("priceval",dbmanager.getValue(i,"networkcommission",""));
hm.put("ticketname",dbmanager.getValue(i,"ticket_name",""));
hm.put("price",dbmanager.getValue(i,"ticket_price",""));
v.add(hm);
}
}

return(v);
}
%>




<%
String eventid=request.getParameter("GROUPID");
String position=request.getParameter("result");
Vector vec=getcommdetails(eventid);

%>


<table cellpadding="0" cellspacing="0" align="left"   style='background: #ddd;border: 1px solid #000; left: 0px; >
<tr><td  id="commerrordisp" class='error' ></td></tr>
<tr ><td></td><td></td><td align="right" ><span style="cursor: pointer; text-decoration: underline"  onClick=javascript:closepopup1('<%=position%>')>x</span></td></tr>
<tr><td class='colheader' align="left" ><b>TicketName</b></td><td class='colheader'><b>price</b></td><td class='colheader'><b>Giveout</b></td><td class='colheader'></td></tr>
<%
if(vec!=null&&vec.size()>0){
for(int i=0;i<vec.size();i++){




HashMap  hm1=(HashMap)vec.elementAt(i);

%>
<tr><td  ><%=(String)hm1.get("ticketname")%></td><td><%=(String)hm1.get("price")%></td><td><%=(String)hm1.get("priceval")%></td></tr>

<%
}}
%>

</table>
