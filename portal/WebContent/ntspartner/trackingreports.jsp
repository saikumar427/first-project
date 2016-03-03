<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.pdfgen.ReportGenerator"%>
<%@ page import="com.eventbee.general.formatting.*,com.eventbeepartner.partnernetwork.RegistrationReports"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ include file="/listreport/allreports.jsp" %>




<%!
  
      String rowdisplay(int count){
    		if(count%2==0){
    			return " class='oddbase'";
    		}else{
    			return " class='evenbase'";
    	   	}
	}

Vector getTransactionDetails(String groupid,String trackingcode,String eventdate){

Vector v=new Vector();
List params=new ArrayList();
params.add(groupid);
params.add(trackingcode);
String query="select distinct a.tid,a.fname,trackpartner  as trackingcode,a.lname,paymenttype as transactiontype, "
	 +" a.fname || ' ' || a.lname as name,to_char(transaction_date,'mm/dd/yyyy') as trandate, "
	 +" current_amount as grandtotal, "
	 +" current_discount as discount,paymentstatus as payment_status,servicefee as ebeefee,ccfee as cardfee,(servicefee+ccfee) as mgrfee "
	 +" from event_reg_transactions a "
	 +" where a.eventid=?  and lower(trackpartner)=? and bookingsource='online' ";
	
	if(eventdate!=null&&!"".equals(eventdate)){
	query=query+" and eventdate=?";
	params.add(eventdate);
	}
	
	query=query+" order by trandate desc";
	
	DBManager dbmanager=new DBManager();                 
	StatusObj statobj=dbmanager.executeSelectQuery(query,(String[])params.toArray(new String[params.size()]));
        System.out.println("status in gettransactiondetails"+statobj.getStatus());

	if(statobj.getStatus()){
			for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("transactionid",	dbmanager.getValue(i,"tid",""));
			hm.put("trandate", dbmanager.getValue(i,"trandate",""));			
			hm.put("firstname", dbmanager.getValue(i,"fname",""));
			hm.put("lastname", dbmanager.getValue(i,"lname",""));
			hm.put("totalamount", dbmanager.getValue(i,"grandtotal",""));
			hm.put("grandtotal", dbmanager.getValue(i,"grandtotal",""));
			hm.put("ebeefee", dbmanager.getValue(i,"ebeefee",""));		
			hm.put("cardfee", dbmanager.getValue(i,"cardfee",""));			
			hm.put("discount", dbmanager.getValue(i,"discount",""));
			hm.put("name",	dbmanager.getValue(i,"name",""));			
			v.add(hm);
			}
	}
	return v;

}
Vector getRSVPTransactionDetails(String groupid,String trackingcode,String eventdate){

Vector v=new Vector();
List params=new ArrayList();
params.add(groupid);
params.add(trackingcode);
String query="select distinct a.tid,a.fname,a.lname, "
	 +" a.fname || ' ' || a.lname as name,to_char(transaction_date,'mm/dd/yyyy') as trandate "
         +" from event_reg_transactions a "
	 +" where a.eventid=?  and lower(trackpartner)=? and bookingsource='online' ";
	
	if(eventdate!=null&&!"".equals(eventdate)){
	query=query+" and eventdate=?";
	params.add(eventdate);
	}
	
	query=query+" order by trandate desc";
	//System.out.println(query+eventdate);
	DBManager dbmanager=new DBManager();                 
	StatusObj statobj=dbmanager.executeSelectQuery(query,(String[])params.toArray(new String[params.size()]));
	System.out.println("status in get rsvp transactiondetails"+statobj.getStatus());
	if(statobj.getStatus()){
			for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("transactionid",	dbmanager.getValue(i,"tid",""));
			hm.put("trandate", dbmanager.getValue(i,"trandate",""));			
			hm.put("firstname", dbmanager.getValue(i,"fname",""));
			hm.put("lastname", dbmanager.getValue(i,"lname",""));
			hm.put("name",	dbmanager.getValue(i,"name",""));			
			v.add(hm);
			}
	}
	return v;

}








%>

<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String filter=request.getParameter("filter");
String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{groupid});
  if(currency==null)	currency="$";
String trackingcode=request.getParameter("trackcode");
String trackcodetolower=trackingcode.toLowerCase();
String secretcode=request.getParameter("secretcode");
String eventdate=request.getParameter("eventdate");
RegistrationReports regreports=new RegistrationReports();		
HashMap tmap=getTicketInfo(groupid);
Vector vec=new Vector();
String isValid=DbUtil.getVal("select count(*) from trackurls where eventid=? and lower(trackingcode)=? and secretcode=?",new String []{groupid,trackcodetolower,secretcode});

if(!"0".equals(isValid))
{
String powertype=DbUtil.getVal("select value from config where config_id " +
				" in(select config_id from eventinfo where eventid=to_number(?,'999999999')) and name='event.rsvp.enabled'",new  String[]{groupid});
if("yes".equals(powertype)){
vec=getRSVPTransactionDetails(groupid,trackcodetolower,eventdate);
}else{
vec=getTransactionDetails(groupid,trackcodetolower,eventdate);
}


String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String visits=DbUtil.getVal("select count from trackURLs where eventid=? and lower(trackingcode)=? and secretcode=?",new String[]{groupid,trackcodetolower,secretcode});
if(visits==null || "".equals(visits)) visits=""+0;


String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
String rtype=request.getParameter("rtype");
if(rtype==null)rtype="html";
rtype=rtype.trim();
ReportGenerator report=ReportGenerator.getReportGenerator(rtype);
StringBuffer content= new StringBuffer();
report.startContent(content,"");
report.startTable(content,"text-align='center'","1");
 if(!"html".equals(rtype)){
    
report.startRow(content,"font-weight='bold' font-size='12pt'  text-align='center'");
report.fillColumn(content,"border-width='0pt' font-weight='bold'",eventname);
report.endRow(content);

}
report.endTable(content); 

report.startTable(content,"text-align='center'","1");
report.startRow(content,null);
report.fillColumn(content,null,"<b>Visits:</b> " +visits);
report.endRow(content);

report.startTable(content,"text-align='center'","1");
report.startRow(content,null);
if (vec!=null&&vec.size()>0){
report.fillColumn(content,null,"<b>Registrations:</b> ");
}else
report.fillColumn(content,null,"<b>Registrations:</b> None");

report.endRow(content);
report.endTable(content); 
String Style="class='colheader'";
report.startTable(content,null,"7");
if (vec!=null&&vec.size()>0){
               
		report.startRow(content,null);
		
		if("yes".equals(powertype)){
		
		report.fillColumn(content,Style,"Booking Date");
		report.fillColumn(content,Style,"Transaction ID");		
	        report.fillColumn(content,Style,"First Name");		
				report.fillColumn(content,Style,"Last Name");	
				report.fillColumn(content,Style,"Response Type");
				//report.fillColumn(content,Style,"Ticket Price ("+currency+")");
				report.fillColumn(content,Style,"Response Count");
				//report.fillColumn(content,Style,"Discount ("+currency+")");		
				//report.fillColumn(content,Style,"Tickets Total ("+currency+")");		

		
		}else{
		report.fillColumn(content,Style,"Booking Date");
				report.fillColumn(content,Style,"Transaction ID");		
				report.fillColumn(content,Style,"First Name");		
				report.fillColumn(content,Style,"Last Name");	
				report.fillColumn(content,Style,"Ticket Name");
				report.fillColumn(content,Style,"Ticket Price ("+currency+")");
				report.fillColumn(content,Style,"Count");
				report.fillColumn(content,Style,"Discount ("+currency+")");		
				report.fillColumn(content,Style,"Tickets Total ("+currency+")");		

		}
		
				report.endRow(content);
String[] vendorTypes=new String[]{"eventbee", "google", "paypal","zerobased","other"};
        String[] signs =new String[]{"","-","-","-","-"};
        int[] typeSignFactor = new int[]{1,-1,-1,-1,-1};
        
	
double totalnet=0;
	for(int i=0;i<vec.size();i++){
	double cardfee=0.0;
	double ebeefee=0.0;
	String Ticketname="";
	String TicketCount="";
	String discountcode="";
	String TicketPrice="";
HashMap hmt=(HashMap)vec.elementAt(i);
report.startRow(content,null);
String transactionid=(String)hmt.get("transactionid");
HashMap TIDTicketHistory = (HashMap)tmap.get(transactionid);
if(TIDTicketHistory!=null){
TicketCount=GenUtil.getHMvalue(TIDTicketHistory,"Count");
Ticketname=GenUtil.getHMvalue(TIDTicketHistory,"DESC");
String type=GenUtil.getHMvalue(TIDTicketHistory,"TYPE");
TicketPrice=GenUtil.getHMvalue(TIDTicketHistory,"Price");
discountcode=GenUtil.getHMvalue(TIDTicketHistory,"discountcode");
if(discountcode==null&&"null".equals(discountcode))
discountcode="";
}	
String trandate=(String)hmt.get("trandate");
String firstname=(String)hmt.get("firstname");
String lastname=(String)hmt.get("lastname");

String name=(String)hmt.get("name");

if(!"yes".equals(powertype)){
String totalamount=(String)hmt.get("totalamount");
String grandtotal=(String)hmt.get("grandtotal");
ebeefee=Double.parseDouble((String)hmt.get("ebeefee"));
String mgrfee=(String)hmt.get("mgrfee");
cardfee=Double.parseDouble((String)hmt.get("cardfee"));
String attendeefee=(String)hmt.get("attendeefee");
String agentcommission=(String)hmt.get("agentcommission");
String discount=(String)hmt.get("discount");
double grandtotal1=Double.parseDouble((String)hmt.get("grandtotal"));
double net=grandtotal1-ebeefee-cardfee;
int k=0;
if(k==0){
totalnet=net-Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0"));	
}else{
net=0;						
totalnet=(ebeefee+Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0")));	
  }
}


String type=DbUtil.getVal("select transactiontype  from attendeeticket where eventid=? and transactionid=?",new String[]{groupid,GenUtil.AllXMLEncode((String)hmt.get("transactionid"))});

report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("trandate")));
if("manager".equals(filter)){
if(!"html".equals(rtype)){
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("transactionid")));
}else{
report.fillColumn(content,rowdisplay(i) ,"<a href='/portal/mytasks/transaction.jsp?from=trackreport&trackcode="+trackingcode+"&secretcode="+secretcode+"&key="+GenUtil.AllXMLEncode((String)hmt.get("transactionid"))+"&amp;GROUPID="+groupid+"&amp;groupid="+groupid+"&amp;cardtype="+type+"'>"+(String)hmt.get("transactionid")+"</a>");
}}else{
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("transactionid")));

}


if("yes".equals(powertype)){

report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("firstname")));
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("lastname")));
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode(Ticketname));
//report.fillColumn(content,rowdisplay(i) ,CurrencyFormat.getCurrencyFormat("",GenUtil.AllXMLEncode(TicketPrice),true));
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode(TicketCount));
//report.fillColumn(content,rowdisplay(i) ,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("discount"),true));
//report.fillColumn(content,rowdisplay(i) ,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("totalamount"),true));
report.endRow(content);	  

}else{
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("firstname")));
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode((String)hmt.get("lastname")));
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode(Ticketname));
report.fillColumn(content,rowdisplay(i) ,CurrencyFormat.getCurrencyFormat("",GenUtil.AllXMLEncode(TicketPrice),true));
report.fillColumn(content,rowdisplay(i) ,GenUtil.AllXMLEncode(TicketCount));
report.fillColumn(content,rowdisplay(i) ,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("discount"),true));
report.fillColumn(content,rowdisplay(i) ,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("totalamount"),true));
report.endRow(content);	  


}

     }
}


else{
}
report.endTable(content);
report.endContent(content);
request.setAttribute("REPORTSCONTENT",content.toString());
if("html".equals(rtype)){
request.setAttribute("subtabtype","My Pages");
%>
<%@ include file="trackingreportslist.jsp" %>
<%}
else if("excel".equals(rtype))
{
%>
<jsp:forward page="excelreports.jsp"/>
<%}
else{%>
<jsp:forward page='/pdfreport1' /> 
<%}}
else
{%>
<table>
<tr>
<td>
Unauthorized Access
</td>
</tr>
</table>

<%}%>
</page1>
