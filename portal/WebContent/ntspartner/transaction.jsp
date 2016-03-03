<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.EventbeeConnection"%>
<%@ page import="com.eventbee.general.StatusObj"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="java.sql.*,com.eventbee.event.*"%>
<%@ page import="com.eventbee.event.ticketinfo.AttendeeInfoDB"%>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.GenUtil,com.eventbee.editevent.*"%>
<%@ page import="com.customattributes.*,java.text.DecimalFormat" %>

<%@ page errorPage="transerror.jsp"%>

<%!

 static final DecimalFormat TWO_DECIMAL_PLACE = new DecimalFormat("0.00");
 static String GET_TICKET_INFO="select distinct ticketname,trim(groupname),ticketprice,ticketqty,discount,ticketstotal  from transaction_tickets where tid=? and eventid=? ";
 static String GET_TRANSACTION_INFO="select to_char(transaction_date,'mm/dd/yyyy') as trandate,to_char(transaction_date,'hh:mi AM') as transactiontime,servicefee,ccfee,original_amount as originalamount,current_amount as modifiedamount,original_tax as tax,current_tax as modifiedtax,initcap(bookingsource) as bookingsource,paymenttype ,discountcode,original_discount as originaldiscount,current_discount as modifieddiscount,original_nts as originalnts,current_nts as modifiednts,to_char(modifiedon,'mm/dd/yyyy') as modifiedondate,to_char(modifiedon,'hh:mi AM') as modifiedontime,ordernumber,initcap(paymentstatus) as paymentstatus,paymenttype,partnerid,trackpartner from event_reg_transactions where tid=? and eventid=?";

  String RESPONSE_QUERY_FOR_ATTRIBUTE="select distinct attrib_name from custom_attrib_response a,custom_attrib_response_master b"
				   +" where a.responseid =b.responseid  and b.attrib_setid=?";
  List getAttributes(String setid){
	DBManager dbmanager=new DBManager();
	List attribs_list=new ArrayList();
	StatusObj statobj=null;
	HashMap hm=new HashMap();
	statobj=dbmanager.executeSelectQuery("select attribname from custom_attribs where attrib_setid=? order by attrib_id",new String []{setid});
			int count1=statobj.getCount();
			if(statobj.getStatus()&&count1>0){
				for(int k=0;k<count1;k++){
                                   hm.put(dbmanager.getValue(k,"attrib_name",""),"y");
				    
					attribs_list.add(dbmanager.getValue(k,"attribname",""));
				}
			}
	statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY_FOR_ATTRIBUTE,new String []{setid});
	int count=statobj.getCount();
	if(statobj.getStatus()&&count>0){
		for(int k=0;k<count;k++){
			if(hm.get(dbmanager.getValue(k,"attribname",""))==null)
			attribs_list.add(dbmanager.getValue(k,"attrib_name",""));
		}
	}

	
	return attribs_list;
  }
  
  HashMap getTransactionInfo(String transactionid,String eventid){
    Vector v= new Vector();
    HashMap hm=new HashMap();    			
    DBManager dbmanager=new DBManager();
    StatusObj stobj=dbmanager.executeSelectQuery(GET_TRANSACTION_INFO,new String[]{transactionid,eventid});
    	if(stobj.getStatus()){
    		for(int i=0;i<stobj.getCount();i++){
    			hm.put("trandate",(String)dbmanager.getValue(i,"trandate",""));
    			hm.put("transactiontime", (String)dbmanager.getValue(i,"transactiontime",""));                                
			hm.put("servicefee", (String)dbmanager.getValue(i,"servicefee",""));
			hm.put("ccfee", (String)dbmanager.getValue(i,"ccfee",""));
			hm.put("originalamount", (String)dbmanager.getValue(i,"originalamount",""));
			hm.put("modifiedamount", (String)dbmanager.getValue(i,"modifiedamount",""));
			String bookingsource=(String)dbmanager.getValue(i,"bookingsource","");
			hm.put("paymenttype", (String)dbmanager.getValue(i,"paymenttype",""));
			hm.put("tax", (String)dbmanager.getValue(i,"tax",""));
			hm.put("modifiedtax", (String)dbmanager.getValue(i,"modifiedtax",""));
			hm.put("discountcode", (String)dbmanager.getValue(i,"discountcode",""));
			hm.put("originaldiscount", (String)dbmanager.getValue(i,"originaldiscount",""));
			hm.put("modifieddiscount", (String)dbmanager.getValue(i,"modifieddiscount",""));
			hm.put("originalnts", (String)dbmanager.getValue(i,"originalnts",""));
			hm.put("modifiednts", (String)dbmanager.getValue(i,"modifiednts",""));
			hm.put("modifiedondate", (String)dbmanager.getValue(i,"modifiedondate",""));
			hm.put("modifiedontime", (String)dbmanager.getValue(i,"modifiedontime",""));
			hm.put("ordernumber", (String)dbmanager.getValue(i,"ordernumber",""));
			hm.put("paymentstatus", (String)dbmanager.getValue(i,"paymentstatus",""));
			hm.put("paymenttype", (String)dbmanager.getValue(i,"paymenttype",""));
			String partnerid=(String)dbmanager.getValue(i,"partnerid","");
			hm.put("partnerid", partnerid);
			String trackpartner=(String)dbmanager.getValue(i,"trackpartner","");
			hm.put("trackpartner", trackpartner);		
			if(!"".equals(trackpartner) && trackpartner!=null && !"null".equals(trackpartner)){
			bookingsource="Track URL - "+trackpartner;
			}
			
			if(!"".equals(partnerid) && partnerid!=null && !"null".equals(partnerid)){
			bookingsource="NTS";
			}
			hm.put("bookingsource",bookingsource);			

    			}
    	}
	return hm;

    }


  String rowdisplay(int count){
	if(count%2==0){
	return "<tr class='oddbase'>";
	}else{
		return "<tr class='evenbase'>";
	    } 
	}



  String encode(String city,String state,String country){
        if(city==null || "".equals(city))  return ""; 
        return city+","+state+","+country;
   } 

  Vector getTicketInfo(String transactionid,String eventid){
  Vector v= new Vector();
  DBManager dbmanager=new DBManager();
  StatusObj stobj=dbmanager.executeSelectQuery(GET_TICKET_INFO,new String[]{transactionid,eventid});
  	if(stobj.getStatus()){
  		for(int i=0;i<stobj.getCount();i++){
  			HashMap hm=new HashMap();  			
  			String ticketname=(String)dbmanager.getValue(i,"ticketname","");
  			hm.put("ticketname",ticketname);
  			hm.put("price",dbmanager.getValue(i,"ticketprice",""));
  			hm.put("qty",dbmanager.getValue(i,"ticketqty",""));
  			hm.put("ticketstotal",dbmanager.getValue(i,"ticketstotal",""));
  			hm.put("discount",dbmanager.getValue(i,"discount",""));
  			hm.put("groupname",dbmanager.getValue(i,"groupname",""));
  			v.addElement(hm);
  			
  		}
  	}
	return v;
     }
     
%>
<link rel="stylesheet" type="text/css"  href="/home/css/modal.css" />
<script type="text/javascript" language="JavaScript" src="/home/js/modal.js"></script>
<script type="text/javascript" language="JavaScript" src="/ntspartner/transactiondetails_js.jsp"></script> 
<script type="text/javascript" language="JavaScript" src="/home/js/enterkeypress.js"></script>

<%
    String platform = request.getParameter("platform");
    String URLBase="mytasks";
    if("ning".equals(platform)){
    	URLBase="ningapp/ticketing";	
    }
    boolean DISPLAY_ACTIVATE_TRN=true;
    boolean DISPLAY_DELETE_TRN=true;
    boolean DISPLAY_EDIT_TICKETS=true;
    boolean DISPLAY_EDIT_ATTENDEE=true;
    boolean DISPLAY_DELETE_ATTENDEE=true;
	boolean DISPLAY_ADD_NOTES=true;
    String tokenid=request.getParameter("tokenid");
    String mgrtokenid=(String)request.getAttribute("mgrtokenid");
    String cardtype=request.getParameter("cardtype");
    if("eventbee".equals(cardtype)){
    cardtype="Eventbee";
    }else if("paypal".equals(cardtype)){
    cardtype="PayPal";
    }else if("google".equals(cardtype)){
    cardtype="Google";
    }else if("other".equals(cardtype)){
    cardtype="Other";
    }
    String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
    String eventid="";
    StatusObj sobj=null;
    HashMap transinfo=null;
    SurveyAttendee survey=null;
    String paymentstatus="";
    String paymentstatustemp="";
    String key=request.getParameter("key");
    eventid=request.getParameter("groupid");
    String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});	
    EditEventDB evtDB=new EditEventDB();
    String payee=evtDB.getConfig(eventid,EventConstants.TRANS_FEE_PAYEE);
    String selindex=request.getParameter("selindex");
    if ((selindex!=null) && ("2".equals(selindex)))
    response.sendRedirect(appname+"/attendeelist/listregistrations.jsp?GROUPID="+request.getParameter("GROUPID"));
    HashMap newhm=(HashMap)session.getAttribute("groupinfo");
    if(key==null || "".equals(key.trim()) || key.length()<2){
    	response.sendRedirect(appname+"/mytasks/transerror.jsp");
    }else{
    	if ("AK".equals(key.substring(0,2))){
          key=AttendeeInfoDB.getTransactionKey(key,eventid);
    	}
    if(key!=null) transinfo=getTransactionInfo(key,eventid);
    if(transinfo==null){
          response.sendRedirect(appname+"/mytasks/transerror.jsp");
    }
    String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eventid});
    if(currency==null)
    currency="$";
    String paytype=request.getParameter("cardtype");   
    Vector v1=getTicketInfo(key,eventid);   
    Vector v2=AttendeeInfoDB.getPromoInfo(key,eventid);
    Vector v3=AttendeeInfoDB.getAttendeeInfo(key,eventid);
    survey=new SurveyAttendee();
    request.setAttribute("tasktitle","Registrations");
        request.setAttribute("tabtype","event");
    request.setAttribute("subtabtype","My Events");
    String custom_setid=CustomAttributesDB.getAttribSetID(eventid,"EVENT");
    List list=getAttributes(custom_setid);
    HashMap mainhm=CustomAttributesDB.getResponses(custom_setid);
    String[] numbers=new String[]{ " One"," Two"," Three"," Four"," Five"," Six", " Seven", " Eight"," Nine"," Ten"," Eleven"," Tweleve"," Thirteen"," Fourteen" };
    if("Bulk".equals(cardtype)) cardtype="Manual";
    String from=request.getParameter("from");
    String trackcode=request.getParameter("trackcode");
   String secretcode=request.getParameter("secretcode");
%>
<script>
var urlbase='<%=URLBase%>';
</script>
<form method="post" action="<%=appname%>/attendeelist/transaction">
<%
    String base="oddbase";
    String booksource="",agentid="";
    String partnerid="";
    String trackpartner="";
String ticketname="";
String groupname="";

%>

<% 
if (transinfo!=null){ 
partnerid=(String)transinfo.get("partnerid");
trackpartner=(String)transinfo.get("trackpartner");

String FLG_DELETE_TRN="";
booksource=(String)transinfo.get("bookingsource");
String name="";
paymentstatus=(String)transinfo.get("paymentstatus");
paymentstatustemp=paymentstatus;
if("Cancelled".equals(paymentstatustemp))
{
paymentstatustemp="Deleted";
}
if("Completed".equals(paymentstatus)||"Charged".equals(paymentstatus)||"Pending".equals(paymentstatus))
{
FLG_DELETE_TRN="1";
}
if(partnerid==null ||"null".equals(partnerid)) partnerid="";
if(!"".equals(partnerid)||"Denied".equals(paymentstatus))
{
DISPLAY_ACTIVATE_TRN=false;
DISPLAY_DELETE_TRN=false;
DISPLAY_EDIT_TICKETS=false;
DISPLAY_EDIT_ATTENDEE=false;
DISPLAY_DELETE_ATTENDEE=false;
DISPLAY_ADD_NOTES=false;
}
else
{
	if("Completed".equals(paymentstatus)||"Charged".equals(paymentstatus)||"Pending".equals(paymentstatus))
	{
	DISPLAY_ACTIVATE_TRN=false;
	}
	if("Cancelled".equals(paymentstatus))
	{
	DISPLAY_ACTIVATE_TRN=true;
	DISPLAY_DELETE_TRN=false;
	DISPLAY_EDIT_TICKETS=false;
	DISPLAY_EDIT_ATTENDEE=false;
	DISPLAY_DELETE_ATTENDEE=false;
	DISPLAY_ADD_NOTES=true;
	}
}
String paymenttype=(String)transinfo.get("paymenttype");
    if("eventbee".equals(paymenttype)){
    paymenttype="Eventbee";
    }else if("paypal".equals(paymenttype)){
    paymenttype="PayPal";
    }else if("google".equals(paymenttype)){
    paymenttype="Google";
    }else if("other".equals(paymenttype)){
    paymenttype="Other";
    }else if("Bulk".equals(paymenttype)){
    paymenttype="Manual";
    }else if("nopayment".equals(paymenttype)){
    paymenttype="No Payment";
    }
if(partnerid!=null){
name=DbUtil.getVal("select getMemberName(userid||'') as name from group_partner where partnerid=?",new String []{partnerid});
}
String ordernumber=(String)transinfo.get("ordernumber");
if("null".equals(ordernumber)  || ordernumber==null)
{
ordernumber="";
}

%>
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<%if("yes".equals(request.getParameter("updated"))){%>
<tr>
<td  colspan="10" class="evenbase" align="center"><b>Attendee Information Updated Successfully</b>
</td>
</tr>
<%}%>
<tr><td class="subheader" width="140">Transaction Info</td>
<td colspan="9" align="left">
<%if(DISPLAY_DELETE_TRN){%>[<a href="#" onClick="canceltransaction('<%=key%>',<%=eventid%>,'<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>');return false;">Delete Transaction</a>&nbsp;|&nbsp;<%}if(DISPLAY_ACTIVATE_TRN){%>[<a href="#" onClick="reactivatetransaction('<%=key%>',<%=eventid%>,'<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>');return false;">Undelete Transaction</a>&nbsp;|&nbsp;<%}if(DISPLAY_ADD_NOTES){%><a href="#" onClick="ViewAddNotes('<%=key%>','<%=eventid%>','<%=cardtype%>','<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>');return false;">Notes</a>]<%}%>
</td>
</tr>
<tr><td class="<%=base%>" colspan="10"></td></tr>
<tr>
<td class='colheader' colspan="2"><b>Order Number</b></td>
<td class='colheader' colspan="2"><b>Transaction ID</b></td>
<td class='colheader' colspan="2"><b>Purchase Date &Time</b></td>
<td class='colheader' colspan="2"><b>Booking Source</b></td>
<td class='colheader' colspan="2"><b>Transaction Status</b></td>
</tr>
<tr><td class="<%=base%>" colspan="10"></td></tr>
<tr>
<tr><td class="<%=base%>" colspan="2"><%=ordernumber%></td>
<td class="<%=base%>" colspan="2"><%=key%></td>
<td class="<%=base%>" align="left" valign="top" colspan="2"><nobr><%=transinfo.get("trandate")%> <%=transinfo.get("transactiontime")%></nobr></td>
<td class="<%=base%>" align="left" valign="top" colspan="2"><%=booksource%></td>
<td class="<%=base%>" align="left" valign="top" colspan="2"><%=paymentstatustemp%></td>

</tr>
<tr><td  colspan="10" height="10"></td></tr>
<tr><td class="subheader" colspan="">Payment Details
</td>
</tr>
<tr><td class="<%=base%>" colspan="10"></td></tr>

<tr>
<!--<td class='colheader' colspan="2"><b>Tickets Total&nbsp;(<%=currency%>)</b></td>-->
<td class='colheader' colspan="2"><b>Discount Code </b></td>
<td class='colheader' valign="top" colspan="2"><b>Total Discount&nbsp;(<%=currency%>)</b></td>
<td class='colheader' valign="top" colspan="2"><b>Tax&nbsp;(<%=currency%>)</b></td>
<td class='colheader' ><b>Total Amount&nbsp;(<%=currency%>)</b></td>
<td class='colheader' colspan="4"><b>Payment Method</b></td>

</tr>
<%
double finaltotal=Double.parseDouble((String)transinfo.get("modifiedamount"));
String finaltotal1=TWO_DECIMAL_PLACE.format(finaltotal);
String discountcode=(String)transinfo.get("discountcode");
if("null".equals(discountcode)  || discountcode==null)
{
discountcode="";
}
%>
<tr>
<!--<td class="<%=base%>" align="left" valign="top" colspan="2"><%=(String)transinfo.get("modifiedamount")%></td>-->
<td class="<%=base%>" align="left" valign="top" colspan="2"><%=discountcode%></td>
<td class="<%=base%>" align="left" valign="top" colspan="2"><%=(String)transinfo.get("modifieddiscount")%></td>
<td class="<%=base%>" align="left" valign="top" colspan="2"><%=(String)transinfo.get("modifiedtax")%></td>
<td class="<%=base%>" align="left" valign="top" ><%=finaltotal1%></td>
<td class="<%=base%>" align="left" valign="top" colspan="4"><%=paymenttype%></td>

</tr>
</table>
 <% } %>
<% 
if (v1!=null){ %>
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td  colspan="8" height="10"></td></tr>
<tr>
<td class="subheader" width="5%">
Tickets&nbsp;</td><td >
<%if(DISPLAY_EDIT_TICKETS){%>
[<a href="#" onClick="modifyTicketReg('<%=key%>','<%=eventid%>','<%=cardtype%>','<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>');return false;">Edit</a>]
<%}%>
</td>
</tr>
<tr><td class="<%=base%>" colspan="8"></td></tr>
<tr><td class='colheader' colspan="4"><b>Name</b></td>
<td class='colheader'><b>Price</b></td>
<td class='colheader'><b>Count</b></td>
<td class='colheader'><b>Discount</b></td>
<td class='colheader'><b>Total</b></td>
</tr>
<%

      for (int i=0;i<v1.size();i++)       {
       if(i%2==0)
       	  	base="evenbase";
       	  	else
		base="oddbase";
          HashMap hm=(HashMap)v1.elementAt(i);
          ticketname=(String)hm.get("ticketname");
 	  ticketname=ticketname.replaceAll("'","&#39;");
          ticketname=GenUtil.XMLEncode(ticketname);
          groupname=(String)hm.get("groupname");
 	  groupname=groupname.replaceAll("'","&#39;");
          groupname=GenUtil.XMLEncode(groupname);
          if((!"".equals(groupname))){          
          groupname="-"+groupname;
          }
          double totprice=Double.parseDouble((String)hm.get("price"));
	  double discnt=Double.parseDouble((String)hm.get("discount"));
	  if(totprice==0.0) totprice=discnt;
	  double cnt=Double.parseDouble((String)hm.get("qty"));	 
	  double total=(totprice*cnt)-(cnt*discnt);	
	  double ticketstotal=Double.parseDouble((String)hm.get("ticketstotal"));	 
	  	  
 %>
<tr>
<td class="<%=base%>" align="left" width="60%" colspan="4"><%=GenUtil.XMLEncode(ticketname)%><%=GenUtil.XMLEncode(groupname)%></td>
<td class="<%=base%>" align="left" ><%=CurrencyFormat.getCurrencyFormat(""+currency+"",totprice+"",true)%></td>
<td class="<%=base%>" align="left" ><%=hm.get("qty")%></td>
<td class="<%=base%>" align="left" ><%=CurrencyFormat.getCurrencyFormat(""+currency+"",(String)hm.get("discount"),true)%></td>
<td class="<%=base%>" align="left" ><%=CurrencyFormat.getCurrencyFormat(""+currency+"",ticketstotal+"",true)%></td>
</tr>
<% } %> 
</table>
<% } %> 
<% if (v2!=null){ %>  
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td  colspan="10" height="10"></td></tr>
<tr><td class="subheader">Promotions</td></tr>
<tr><td class="<%=base%>"></td></tr>
<tr><td class='colheader' ><b>Name</b></td>
<td class='colheader'><b>Price</b></td>
<td class='colheader'><b>Count</b></td>
<td class="inform" align="left" valign="top">Booking Type</td>
</tr>
<% 
      for (int i=0;i<v2.size();i++)
       {
          HashMap hm=(HashMap)v2.elementAt(i);
          out.println(rowdisplay(i));
 %>
 <tr>
<td class="<%=base%>" align="left" valign="top"><%=GenUtil.XMLEncode((String)hm.get("itemname"))%>
</td><td class="<%=base%>" align="left" valign="top"><%=CurrencyFormat.getCurrencyFormat(""+currency+"",(String)hm.get("price"),true)%></td>
<td class="<%=base%>" align="left" valign="top"><%=hm.get("qty")%></td>
<td class="<%=base%>" align="left" valign="top"><%=GenUtil.XMLEncode((String)hm.get("type"))%></td>
</tr>
<% } %> 
</table>
<% } %> 
<%if (v3!=null){ %>
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td  colspan="10" height="10"></td></tr>
<tr><td class="subheader" colspan="2">Attendees</td></tr>
<tr><td class="<%=base%>" colspan="2"></td></tr>
<% 
     for (int i=0;i<v3.size();i++)
       {
          HashMap hm=(HashMap)v3.elementAt(i);
          out.println(rowdisplay(i+1));
%> 
<tr>
<td class="oddbase" width="13%">
<b><nobr>Attendee<%=numbers[i]%>:</nobr></b></td>
<td class="oddbase"><%if(DISPLAY_EDIT_ATTENDEE){%>[<a href="#" onclick="editdetails('<%=key%>',<%=eventid%>,'<%=(String)hm.get("attendeekey")%>','<%=tokenid%>','<%=platform%>','<%=cardtype%>','<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>');return false;">Edit</a><%if(v3.size()>1 && DISPLAY_DELETE_ATTENDEE){%>&nbsp;|&nbsp;<a href="#" onclick="deleteattendee('<%=key%>',<%=eventid%>,'<%=(String)hm.get("attendeekey")%>','<%=tokenid%>','<%=platform%>','<%=cardtype%>','<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>');return false;">Delete Attendee</a><%}%>]<%}%>
</td>
</tr>
<tr>
<td class="<%=base%>" colspan="2" ><b>Name:</b> <%=GenUtil.XMLEncode((String)hm.get("firstname"))%> <%=GenUtil.XMLEncode((String)hm.get("lastname"))%>
<br/>
<b>Email:</b> <%=GenUtil.XMLEncode((String)hm.get("email"))%>
<% 
if (!("".equals(GenUtil.getHMvalue(hm,"phone","")))){
String phone=(String)hm.get("phone");
if("null".equals(phone))phone="";
out.println("<br/><b>Phone:</b> "+phone+"<br/>");
}

	%>
<%if ((String)hm.get("company")!=null){} %>
<%=GenUtil.XMLEncode(encode((String)hm.get("city"),(String)hm.get("state"),(String)hm.get("country")))%><br/>
<% if(!("".equals((String)hm.get("zip")))){
     out.println("<b>Zip:</b> "+hm.get("zip"));
}

%>
</td></tr>
<%
      survey.setSurvey(eventid,"EVENT_ATTENDEE_QUESTIONAIRE","survey");     
      if((survey.getSurveyObject())!=null){
             survey.setResponsesFromDB((String)hm.get("attendeekey"));
             out.println(SurveyPresentor.DisplayResponses(survey,true,true,"Attendee Survey"));
      }
 } 
 } 
      survey.setSurvey(eventid,"EVENT_TICKET_REG_PAGE","survey");
      if((survey.getSurveyObject())!=null){
             survey.setResponsesFromDB(key);
             out.println(SurveyPresentor.DisplayResponses(survey,true,true,"Event Survey"));
      }
%>
</table>
<%}%>
</form>

