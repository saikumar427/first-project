<%@ page import="java.util.*,java.io.*,javax.servlet.http.*,com.eventbee.event.ticketinfo.AttendeeInfoDB,com.eventbee.general.GenUtil,com.eventbee.general.*"%>
<%@ page import="com.customattributes.*" %>
<%!
static final String GET_TICKETS_INFO="select ticketqty,ticketname,ticketid,transactionid from attendeeticket where eventid=? and transactiontype='card'order by ticketid";

public HashMap getTicketInfo(String groupid){
HashMap hmap=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(GET_TICKETS_INFO,new String [] {groupid});
	if(statobj.getStatus()&&statobj.getCount()>0){
		for(int i=0;i<statobj.getCount();i++){
			String tid =dbmanager.getValue(i,"transactionid",null);
			String ticketname=dbmanager.getValue(i,"ticketqty","0")+" ("+dbmanager.getValue(i,"ticketname","")+")";
			if(hmap.get(tid)!=null)
			  ticketname=hmap.get(tid)+", "+ticketname;
			  hmap.put(tid,ticketname);
			
		}
	}
 return hmap;
}



%>
<%
response.setContentType("application/vnd.ms-excel");
String CLASSNAME="excelreport.jsp";
double totalagentcomm=0.0;
double totalamt=0.0;
double net=0.0;
double grandtotal1=0;
String cardfee1="";
String ebeefee1="";
double totalnet=0;
double distotal=0;
 double netsum=0.0;

Vector v1=null;
String type="";
String userid=null;

Vector vec=(Vector)session.getAttribute("attendeelist");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASSNAME,null,"attendeelist vector value is---"+vec,null);
String groupid=(String)session.getAttribute("GROUPID");
String agentid=(String)session.getAttribute("agentid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASSNAME,null,"agentid  value is---"+agentid,null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASSNAME,null,"groupid  value is---"+groupid,null);
String custom_setid=CustomAttributesDB.getAttribSetID(groupid,"EVENT");

out = pageContext.getOut();

out.print("Book Date "+'\t'+"Transaction ID"+'\t'+"Name "+'\t'+"Type "+'\t'+"Tickets Count"+'\t'+"Discounts"+'\t'+"TicketsTotal ($)"+'\t'+"EventbeeFee ($)"+'\t'+"AmexFee ($)"+'\t'+"Net ($)"+'\t'+"Eventbee Network Ticket Selling Commission"+'\t'+"TotalNet"+'\t'+"");


out.println("\n");
			
for(int i=0;i<vec.size();i++){
	HashMap hmt=(HashMap)vec.elementAt(i);	
	try{	grandtotal1=Double.parseDouble((String)hmt.get("grandtotal"));
		net=grandtotal1-Double.parseDouble((String)hmt.get("ebeefee"))-Double.parseDouble((String)hmt.get("cardfee"));
	}catch(Exception e)
	{
			net=0.0;
	}
	v1=AttendeeInfoDB.getTicketInfo((String)hmt.get("transactionid"),groupid);
		 HashMap tmap=getTicketInfo(groupid);
	if (v1!=null&&v1.size()>0){
	
		 for (int j=0;j<v1.size();j++)
		 {
			HashMap regdata=(HashMap)v1.elementAt(j);
			type=GenUtil.getInitCapString(GenUtil.AllXMLEncode((String)regdata.get("paymenttype")));
			cardfee1=(String)hmt.get("cardfee");
			ebeefee1=(String)hmt.get("ebeefee");
			if("Card".equals(type)&&grandtotal1>0){
			}else{
					cardfee1="0";
					ebeefee1="0";
					net=0;
			}
			}
			
			totalamt=totalamt+net;
			totalnet=net - Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0"));
                        netsum=netsum+totalnet;
			totalagentcomm=totalagentcomm+Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0"));
	                distotal=distotal+Double.parseDouble(GenUtil.getHMvalue(hmt,"discount","0"));
	type=("Card".equals(type))?"Credit "+type:type;
	
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASSNAME,null,"type value is---"+type,null);
	out.print((String)hmt.get("trandate")+'\t'+hmt.get("transactionid")+'\t'+((String)hmt.get("firstname"))+" "+((String)hmt.get("lastname"))+'\t'+type+'\t'+GenUtil.getHMvalue(tmap,(String)hmt.get("transactionid"),"")+'\t'+hmt.get("discount")+'\t'+hmt.get("totalamount")+'\t'+cardfee1+'\t'+ebeefee1+'\t'+net+'\t'+GenUtil.getHMvalue(hmt,"agentcommission","0")+'\t'+totalnet);

	
	out.println("");
}
         
    }     
         out.println("Total"+'\t'+'\t'+'\t'+'\t'+'\t'+"$"+distotal+'\t'+'\t'+'\t'+'\t'+"$ "+totalamt+'\t'+"$ "+totalagentcomm+'\t'+"$"+netsum);

%>


		
	