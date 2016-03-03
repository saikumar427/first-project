<?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent,com.eventbee.general.*" %>
<%@ page import="com.eventbee.contentbeelet.*"%>
<%@ page import="com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>


<%!


Vector getTicketDetails(String groupid)
{

String query="select price_id,ticket_type,ticket_price from price where evt_id=? and  now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) and max_ticket>sold_qty ";

Vector vec=new Vector();
HashMap hm=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{groupid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
hm=new HashMap();
hm.put("price_id",db.getValue(i,"price_id",""));
hm.put("price",db.getValue(i,"ticket_price",""));
hm.put("tickettype",db.getValue(i,"ticket_type",""));
vec.add(hm);
}

}

return vec;
}	

%>


<%
	Vector alltickets=null;
	String groupid=request.getParameter("GROUPID");	
	String partnerid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
	String pfriendid=Presentation.GetRequestParam(request,  new String []{"fid","friendid"});

	double splprice=0;
	double origprice=0;
	HashMap splcommision=null;
	String partnercommision=null;
	HashMap partnerticcomdetails=null;
	StringBuffer sb=new StringBuffer();
	double discount=0;
	HashMap resultmap=null;

	String tickettype="";
	String price="";
	double newprice=0.0;
	String ticketid="";
	
	//Remove following condition once parner id is get from request.
	//if(partnerid==null)
		//partnerid="3809";
		//pfriendid=null;
		
	  if(partnerid!=null){
	 resultmap=PartnerCommisions.getSplcommission(groupid,partnerid,pfriendid);
	 if(resultmap!=null&&resultmap.size()>0){
	 
	 partnercommision=(String)resultmap.get("partnercommision");
	 
	 splcommision=(HashMap)resultmap.get("splcommisionmap");
	 partnerticcomdetails=(HashMap)resultmap.get("partnerticcomdetailsmap");
	
	 }
	 
  }
	
	
	
	alltickets=getTicketDetails(groupid);
	if(alltickets.size()>0){
	
		if(partnercommision!=null){
  				
  		
  		  
  				sb.append("<tickets codestatus='success'>");
	
  
  		}else
  			sb.append("<tickets codestatus='INVALID'>");
	
		for(int i=0;i<alltickets.size();i++){
		
				HashMap ticketmp=(HashMap)alltickets.elementAt(i);
				ticketid=(String)ticketmp.get("price_id");
				price=(String)ticketmp.get("price");
				tickettype=(String)ticketmp.get("tickettype");
				
				if("Public".equals(tickettype))
					tickettype="publicTickets";
				else
					tickettype="Optional";
				
				try{    
				
				     origprice=Double.valueOf(price).doubleValue();
				     if(partnercommision!=null){
				     discount=(Double.valueOf((String)partnerticcomdetails.get(ticketid)).doubleValue())*(Double.valueOf(partnercommision).doubleValue())/100;
				     } splprice=(origprice)-(discount);
					
					
					}catch(Exception e){
					splprice=origprice;
					discount=0;
						System.out.println("Exception at special price-->"+e.getMessage());
					}
				
										
			
				
					sb.append("<ticket id='"+ticketid+"' type='"+tickettype+"' price='"+CurrencyFormat.getCurrencyFormat("",price,true)+"'");
					sb.append(" discount='"+discount+"' newprice='"+CurrencyFormat.getCurrencyFormat("",Double.toString(splprice),true)+"'");
					sb.append("/>");
				
		}
		sb.append("</tickets>");

	}
	
out.print(sb.toString());
					
%>