<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*,java.text.DecimalFormat" %>
<%!
static final DecimalFormat TWO_DECIMAL_PLACE = new DecimalFormat("0.00");
int finali=0;
static String GET_TICKET_INFO="select distinct ticketname,ticketprice,ticketid,ticketqty  ,discount ,ticket_groupid as tktgroupid,groupname,ticketstotal from transaction_tickets  where tid=? and eventid=? ";
static String GET_ALL_TICKET_INFO="select distinct ticket_name as ticketname,ticket_price+process_fee as ticketprice,pr.price_id as ticketid,0 as ticketqty,0 as discount,gt.ticket_groupid as tktgroupid,groupname,0 as ticketstotal from price pr,group_tickets gt,event_ticket_groups etg  where   etg.eventid=?   and to_number(etg.eventid,'99999999999999999999')=pr.evt_id and to_number(gt.price_id,'99999999999999999999')=pr.price_id  and gt.ticket_groupid=etg.ticket_groupid";
static String MODIFIED_DETAILS="select current_amount as orgamtfrmevtreg,current_discount as orgdiscountfrmevtreg,current_tax as tax from event_reg_transactions where tid=? and eventid=?";
public Vector getTicketInfo(String transactionid,String eventid){
Vector v= new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(GET_TICKET_INFO,new String[]{transactionid, eventid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			String ticketid=dbmanager.getValue(i,"ticketid","");
			hm.put("ticketid",ticketid);
			String ticketname=(String)dbmanager.getValue(i,"ticketname","");
			hm.put("ticketname",ticketname);
			hm.put("price",dbmanager.getValue(i,"ticketprice",""));
			hm.put("qty",dbmanager.getValue(i,"ticketqty",""));
			hm.put("discount",dbmanager.getValue(i,"discount",""));
			hm.put("tktgroupid",dbmanager.getValue(i,"tktgroupid",""));
			hm.put("groupname",dbmanager.getValue(i,"groupname",""));
			hm.put("ticketstotal",dbmanager.getValue(i,"ticketstotal",""));
			v.addElement(hm);
			
		}
	}
	return v;
}

public Vector getAllTicketInfo(String eventid){
Vector v= new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(GET_ALL_TICKET_INFO,new String[]{eventid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			String ticketid=dbmanager.getValue(i,"ticketid","");
			hm.put("ticketid",ticketid);
			String ticketname=(String)dbmanager.getValue(i,"ticketname","");
			hm.put("ticketname",ticketname);
			hm.put("price",dbmanager.getValue(i,"ticketprice",""));
			hm.put("qty",dbmanager.getValue(i,"ticketqty",""));
			hm.put("discount",dbmanager.getValue(i,"discount",""));
			hm.put("tktgroupid",dbmanager.getValue(i,"tktgroupid",""));
			hm.put("groupname",dbmanager.getValue(i,"groupname",""));
			hm.put("ticketstotal",dbmanager.getValue(i,"ticketstotal",""));

			v.addElement(hm);
			
		}
	}
	return v;
}

public String getKey(HashMap tctDetails){

String price=(String)tctDetails.get("price");
	  String ticketid=(String)tctDetails.get("ticketid");	
	  String ticketgroupid=(String)tctDetails.get("tktgroupid");	
	  String groupName=(String)tctDetails.get("groupname");
	  String ticketName=(String)tctDetails.get("ticketname");
	  String key=ticketid+":"+ticketgroupid+":"+ticketName+":"+groupName+":"+CurrencyFormat.getCurrencyFormat("",price+"",true);
	  return key;
 
}

public void mergeVectors(Vector ticketdetails, Vector allticketdetails){

HashMap uniqueset=new HashMap();
for (int i=0;i<ticketdetails.size();i++){       
          HashMap hm=(HashMap)ticketdetails.elementAt(i);
	  String key=getKey(hm);
	  uniqueset.put(key,"Y");
}
for (int i=0;i<allticketdetails.size();i++){       
          HashMap hm=(HashMap)allticketdetails.elementAt(i);
	  String key=getKey(hm);
	  if(uniqueset.containsKey(key)){
	  }else{
	  ticketdetails.add(hm);
	  uniqueset.put(key,"Y");
	  }  
}

}
%>
<%
String eventid=request.getParameter("eid");
String transactionid=request.getParameter("transactionid");
String cardtype=request.getParameter("cardtype");
String from=request.getParameter("from");
String trackcode=request.getParameter("trackcode");
String secretcode=request.getParameter("secretcode");
String mgrtokenid=request.getParameter("mgrtokenid");
String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eventid});
if(currency==null)
	currency="$";
DBManager dbmanager=new DBManager();
String orgamtfrmevtreg="";
String orgdiscountfrmevtreg="";
String tax="";

StatusObj stobj=dbmanager.executeSelectQuery(MODIFIED_DETAILS,new String[]{transactionid,eventid});
if(stobj.getStatus()){
orgamtfrmevtreg=dbmanager.getValue(0,"orgamtfrmevtreg","");
orgdiscountfrmevtreg=dbmanager.getValue(0,"orgdiscountfrmevtreg","");
tax=dbmanager.getValue(0,"tax","");
}
//double net=Double.parseDouble(orgamtfrmevtreg)-Double.parseDouble(orgdiscountfrmevtreg)-Double.parseDouble(tax);
double net=Double.parseDouble(orgamtfrmevtreg)+Double.parseDouble(tax);
String net1=TWO_DECIMAL_PLACE.format(net);
Vector ticketdetails=getTicketInfo(transactionid,eventid);
Vector allticketdetails=getAllTicketInfo(eventid);
mergeVectors(ticketdetails, allticketdetails);
String base="oddbase";
if (ticketdetails!=null){ 
%>
<form name="modifyform" id="modifyform" method="POST" action="/ntspartner/backendmodifytransactiondetails.jsp" >
<input type="hidden" name="eventid" value="<%=eventid%>">
<input type="hidden" name="transactionid" value="<%=transactionid%>"> 
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td class="subheader" colspan="6" width="10%">Tickets</td></tr>
<tr><td colspan="6" align="right">
Make sure to click on Submit button after making changes&nbsp;&nbsp;</td>
</tr>
<tr><td colspan="5" align="center" id="error"></td></tr>
<tr><td class='colheader' width="60%"><b>Name</b></td>
<td class='colheader' width="10%"><b>Price (<%=currency%>)</b></td>
<td class='colheader'  width="10%"><b>Quantity</b></td>
<td class='colheader'  width="10%" ><b>Discount (<%=currency%>)</b></td>
<td class='colheader'  width="10%" align="right"><b>Total (<%=currency%>)</b></td>
</tr>
<%
      int totalindex=ticketdetails.size();
      for (int i=0;i<ticketdetails.size();i++)
       {
       if(i%2==0)
       	  	base="evenbase";
       	  	else
		base="oddbase";
          HashMap hm=(HashMap)ticketdetails.elementAt(i);
	  double totprice=Double.parseDouble((String)hm.get("price"));
	  double discnt=Double.parseDouble((String)hm.get("discount"));
	  double cnt=Double.parseDouble((String)hm.get("qty"));	 
	  double total=(totprice*cnt)-(cnt*discnt);	
	  String ticketid=(String)hm.get("ticketid");	
	  String ticketgroupid=(String)hm.get("tktgroupid");	
	  String groupName=(String)hm.get("groupname");
	  double ticketstotal=Double.parseDouble((String)hm.get("ticketstotal"));	 


  	  
 %>
<tr>
<td class="<%=base%>" align="left" >
<span id="ticketname<%=i+1%>"><%=GenUtil.XMLEncode((String)hm.get("ticketname"))%> </span>
</td>
<input type="hidden" name="ticketprices<%=i+1%>" id="ticketprices<%=i+1%>" value="<%=CurrencyFormat.getCurrencyFormat("",totprice+"",true)%>">
<td class="<%=base%>" align="left" >
<span  id="ticketprice<%=i+1%>"><%=CurrencyFormat.getCurrencyFormat("",totprice+"",true)%></span>
</td>
<td class="<%=base%>" align="left" ><input type="text" size="3" id="qty<%=i+1%>" name="qty<%=i+1%>" value="<%=hm.get("qty")%>"  onChange="calculateamount('<%=i+1%>','<%=totalindex%>');" /></td>
<td class="<%=base%>" align="left" ><input type="text" size="7" id="discount<%=i+1%>" name="discount<%=i+1%>" value="<%=CurrencyFormat.getCurrencyFormat("",(String)hm.get("discount"),true)%>"  onChange="calculateamount('<%=i+1%>','<%=totalindex%>');" /></td>

<td class="<%=base%>" align="right" ><div id="total<%=i+1%>">
<input type="text" size="7"   id="totalval<%=i+1%>" name="total<%=i+1%>" value="<%=CurrencyFormat.getCurrencyFormat("",ticketstotal+"",true)%>" onChange="changetotal('<%=i+1%>','<%=totalindex%>');"/></div>
</td>
</tr>
<tr><td colspan="5" class="<%=base%>"><%=GenUtil.XMLEncode(groupName)%></td></tr>
<input type="hidden" name="ticketid<%=i+1%>" value="<%=ticketid%>">
<input type="hidden" name="ticketgroupid<%=i+1%>" value="<%=ticketgroupid%>">
<input type="hidden" name="ticketname<%=i+1%>" value="<%=GenUtil.XMLEncode((String)hm.get("ticketname"))%>">
<input type="hidden" name="groupname<%=i+1%>" value="<%=groupName%>">
<% 
finali=i;

}%>
<input type="hidden" name="totaldiscount1" id="totaldiscount1">
<input type="hidden" name="totalamount1" id="totalamount1">
<input type="hidden" name="finali" value="<%=++finali%>">
<tr>
<td colspan="3" class="evenbase" align="right"><b>Total Discount(<%=currency%>)</b></td>
<td class="evenbase" align="left" >
<span id="totaldiscount"><%=orgdiscountfrmevtreg%></span>
<td class="evenbase"></td>
</tr>
<tr>
<td colspan="4" class="evenbase" align="right"><b>Total Amount(<%=currency%>)</b></td>
<td class="evenbase" align="left" >
<span id="totalamount"><%=orgamtfrmevtreg%></span>

</td>
</tr>
<tr>
<td colspan="4" class="evenbase" align="right"><b>Tax(<%=currency%>)</b></td>
<td class="evenbase" align="left">
<input type="text" size="7" name="tax" id="tax" value="<%=tax%>" onChange="changetax1()" >
</td>
</tr>
<tr>
<td colspan="4" class="evenbase" align="right"><b>Net Amount(<%=currency%>)</b></td>
<td class="evenbase" align="left">
<span id="net"><%=net1%></span>
</td>
</tr>
<tr>
<td colspan="6" align="center" >
<input type="button" value="Submit" onclick="finalSubmit('<%=eventid%>','<%=finali%>','<%=transactionid%>','<%=cardtype%>','<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>')">
<input type="button" value="Cancel" onclick="hideattendee();">
</td>
</tr>
</table>

</form>
<% }

%>

