<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.pdfgen.ReportGenerator"%>
<%@ page import="com.eventbee.general.formatting.*"%>

<%!
  
      String rowdisplay(int count){
    		if(count%2==0){
    			return " class='oddbase'";
    		}else{
    			return " class='evenbase'";
    	   	}
	}

Vector getTransactionDetails(String groupid,String agentid){

Vector v=new Vector();
String query="select distinct b.transactionid,grandtotal,discount,friendid,agentcommission, paymentstatus   from transaction b,partner_transactions a" 
	      +"  where  b.transactionid =a.transactionid  and refid=?"
	       +" and b.agentid=?   ";
	  
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid,agentid});
	if(statobj.getStatus()){
			for(int i=0;i<statobj.getCount();i++){
				HashMap hm=new HashMap();


			hm.put("transactionid",	dbmanager.getValue(i,"transactionid",""));
			hm.put("agentcommission",dbmanager.getValue(i,"agentcommission",""));
			hm.put("paymentstatus",dbmanager.getValue(i,"paymentstatus",""));
			hm.put("grandtotal",dbmanager.getValue(i,"grandtotal",""));

			if(dbmanager.getValue(i,"friendid","")!=null&&!"null".equals(dbmanager.getValue(i,"friendid",""))&&!"".equals(dbmanager.getValue(i,"friendid","")))
			{
			hm.put("friendcommission",dbmanager.getValue(i,"discount","0"));

			hm.put("otherscommission","0");
			}
			else{
			hm.put("otherscommission",dbmanager.getValue(i,"discount","0"));

			hm.put("friendcommission","0");
			}
			v.add(hm);

			}
	}
	return v;





}


static final String GET_TICKETS_INFO1="select ticketqty,ticketname,ticketid,transactiontype,transactionid,ticketprice,couponcode  from attendeeticket where eventid=? order by ticketid";
		
public HashMap getTicketInfo1(String groupid){
HashMap hmap=new HashMap();
	DBManager dbmanager=new DBManager();
	HashMap ticketHistory = null;
	StatusObj statobj=dbmanager.executeSelectQuery(GET_TICKETS_INFO1,new String [] {groupid});
	if(statobj.getStatus()&&statobj.getCount()>0){
	for(int i=0;i<statobj.getCount();i++){
		String tid =dbmanager.getValue(i,"transactionid",null);
		String ticketname=dbmanager.getValue(i,"ticketqty","0")+" ("+CurrencyFormat.getCurrencyFormat("$",dbmanager.getValue(i,"ticketprice","0"),true)+"-"+dbmanager.getValue(i,"ticketname","")+")";
		String transactiontype=dbmanager.getValue(i,"transactiontype",null);
		String couponcode=dbmanager.getValue(i,"couponcode",null);

		if(hmap.get(tid)!=null){
		ticketHistory = (HashMap)hmap.get(tid);
		  ticketname=ticketHistory.get("DESC")+", "+ticketname;
		  ticketHistory.put("DESC", ticketname);
		  }else{
			ticketHistory = new HashMap();
			ticketHistory.put("DESC", ticketname);
			ticketHistory.put("TYPE", transactiontype);
			ticketHistory.put("discountcode",couponcode);
		  }
		  hmap.put(tid,ticketHistory);


	}
}
 return hmap;
}


%>

<%
String groupid=request.getParameter("GROUPID");
String agentid=request.getParameter("agentid");
Vector vec=getTransactionDetails(groupid,agentid);
String platform = request.getParameter("platform");
String filter = "";;
String URLBase="mytasks";
if("ning".equals(platform)){
	URLBase="ningapp";
	filter = request.getParameter("filter");
}
 

String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
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
String Style="class='colheader'";
report.startTable(content,null,"7");
if (vec!=null&&vec.size()>0){
                
		report.startRow(content,null);
		
		report.fillColumn(content,Style,"Transaction ID");
		report.fillColumn(content,Style,"Total Amount ($)");
		
		report.fillColumn(content,Style,"Commission ($)");
		
		report.fillColumn(content,Style,"Discount To Friends ($)");
		
		
		report.fillColumn(content,Style,"Discount To Others ($)");
			
		report.fillColumn(content,Style,"My Credited Earnings ($)");
		
		report.fillColumn(content,Style,"My Waiting For Credit Earnings ($)");
		
		
		report.endRow(content);


double totfriendcom=0.0;		
double totothercom=0.0;		
double totagentcom=0.0;		
double totcom=0.0;
double totcreditedearning=0.0;
double totwaitforcreditearning=0.0;
		
	for(int i=0;i<vec.size();i++){
HashMap hmt=(HashMap)vec.elementAt(i);
report.startRow(content,null);
String agentcommssion=(String)hmt.get("agentcommission");
String creditedearning="0";
String waitforcreditearning="0";

if("credited".equals((String)hmt.get("paymentstatus")))
	creditedearning=agentcommssion;
else
	waitforcreditearning=agentcommssion;
String type=DbUtil.getVal("select transactiontype  from attendeeticket where eventid=? and transactionid=?",new String[]{groupid,GenUtil.AllXMLEncode((String)hmt.get("transactionid"))});

		
double agentcomm=0.0;
agentcomm=Double.parseDouble(agentcommssion)+Double.parseDouble((String)hmt.get("friendcommission"))+Double.parseDouble((String)hmt.get("otherscommission"));
totfriendcom+=Double.parseDouble((String)hmt.get("friendcommission"));
totothercom+=Double.parseDouble((String)hmt.get("otherscommission"));
totcreditedearning+=Double.parseDouble(creditedearning);
totwaitforcreditearning+=Double.parseDouble(waitforcreditearning);
report.fillColumn(content,rowdisplay(i) ,"<a href='/"+URLBase+"/partnertransaction.jsp?key="+GenUtil.AllXMLEncode((String)hmt.get("transactionid"))+"&GROUPID="+groupid+"&platform="+platform+"&filter="+filter+"&groupid="+groupid+"&cardtype="+type+"&agentid="+agentid+"'>"+GenUtil.AllXMLEncode((String)hmt.get("transactionid"))+"</a>");
report.fillColumn(content,rowdisplay(i) + " align='right'",CurrencyFormat.getCurrencyFormat("",(String)hmt.get("grandtotal"),true));
report.fillColumn(content,rowdisplay(i) + " align='right'",CurrencyFormat.getCurrencyFormat("",agentcomm+"",true));
report.fillColumn(content,rowdisplay(i) + " align='right'",CurrencyFormat.getCurrencyFormat("",(String)hmt.get("friendcommission"),true));
report.fillColumn(content,rowdisplay(i) + " align='right'",CurrencyFormat.getCurrencyFormat("",(String)hmt.get("otherscommission"),true));
report.fillColumn(content,rowdisplay(i) + " align='right'",CurrencyFormat.getCurrencyFormat("",creditedearning,true));
report.fillColumn(content,rowdisplay(i) + " align='right'",CurrencyFormat.getCurrencyFormat("",waitforcreditearning,true));
report.endRow(content);	  
		}
	
		
		
report.startRow(content,null);
report.fillColumn(content,null,"Total");
report.fillColumn(content,null,"");
report.fillColumn(content,null,"");

report.fillColumn(content,"align='right'",CurrencyFormat.getCurrencyFormat("$", totfriendcom+"", true));
report.fillColumn(content,"align='right'",CurrencyFormat.getCurrencyFormat("$", totothercom+"", true));
report.fillColumn(content,"align='right'", CurrencyFormat.getCurrencyFormat("$", totcreditedearning+"", true) );
report.fillColumn(content,"align='right'", CurrencyFormat.getCurrencyFormat("$", totwaitforcreditearning+"", true) );
report.endRow(content);		



}

else{
report.startRow(content,null);
report.fillColumn(content,null,"No Registrations");
report.endRow(content);
}
report.endTable(content);
report.endContent(content);
request.setAttribute("REPORTSCONTENT",content.toString());
if("html".equals(rtype)){
request.setAttribute("subtabtype","My Pages");
%>
<%@ include file="partnerreportslist.jsp" %>
<%}
else if("excel".equals(rtype))
{
%>
<jsp:forward page="excelreports.jsp"/>
<%}
else{%>
<jsp:forward page='/pdfreport1' /> 
<%}%>
</page1>
