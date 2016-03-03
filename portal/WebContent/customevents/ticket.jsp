<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent,com.eventbee.general.*" %>
<%@ page import="com.eventbee.contentbeelet.*"%>
<%@ page import="com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.general.formatting.CurrencyFormat"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%!





 Vector getReqGroupDetails(String evtid,Vector vm_pub,String tickettype){
	  	Vector vec=new Vector();
	  	HashMap pm=new HashMap();
	  	for(int p=0;p<vm_pub.size();p++){
	  	HashMap tmp=(HashMap)vm_pub.elementAt(p);
	  	
		   	pm.put((String)tmp.get("price_id"),"");
		   	}
   	
	  			
	  	DBManager dbmanager=new DBManager();
	  	StatusObj st=dbmanager.executeSelectQuery("select groupname,price_id,g.position from group_tickets g,event_ticket_groups e where e.ticket_groupid=g.ticket_groupid and e.eventid=? and e.tickettype=? order by e.position,g.position ",new String []{evtid,tickettype});
	  	if(st.getStatus()){
	  	   	int a=0;
	  	   	for(int k=0;k<st.getCount();k++){
	  	   	
	  	       if(pm.containsKey(dbmanager.getValue(k,"price_id",""))){
	  	       HashMap hm=new HashMap ();
		   	
		   	hm.put("name"+a,dbmanager.getValue(k,"groupname",""));
		   	a++;
		   	hm.put(dbmanager.getValue(k,"price_id",""),String.valueOf(a));
		   	vec.add(hm);
		   	}
   	   		   	
	  	   	}
	  	   	}
	  	   	return vec;
	  	   	
	   	}
	 




 Vector orderTickets(Vector tickets,Vector v){
	 
	 Vector evttkt=new Vector();
	    	int m=0;
	    	if(v.isEmpty()){
	    	
	    	return tickets;
	    	
	    	}
	    	for(int j=0;j<v.size();j++){
	    	HashMap hm=(HashMap)v.elementAt(j);
	    	for(int i=0;i<tickets.size();i++){
	    	HashMap hm1= (HashMap)tickets.elementAt(i);
	    	String ticketid=(String)hm1.get("price_id");
	    	if(hm.containsKey(ticketid)){
	    	int pos=Integer.parseInt((String)hm.get(ticketid));
	    	evttkt.add(hm1);
	    	}
	    	else
	    	continue;
	    	}
	    	}
	    	
	    	
	    	return evttkt;
	    	
   	}

HashMap getTicketDiscounts(String groupid,String code)
{
String query="select price_id from coupon_ticket  where couponid in(select couponid from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?)";
HashMap hmp=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{code,groupid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
hmp.put(db.getValue(i,"price_id",""),"");
}

}
return hmp;
}

%>
<%
String discount=request.getParameter("code");
				     
HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
String groupid=(String)request.getAttribute("GROUPID");
Vector vm_pub=new Vector();
Vector vm_mem=new Vector();
Vector vm_evt=new Vector();
Vector vm_opt=new Vector();
Vector v1=new Vector();
Vector v=new Vector();

Vector alltickets=null;
String ticketheader="";
String ticketprintableversion="";
String ticketprintableversionlink="";


//Special partner settings details


String partnerid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String pfriendid=Presentation.GetRequestParam(request,  new String []{"fid","friendid"});

String partnercommision=null;
HashMap splcommision=null;
HashMap partnerticcomdetails=null;
HashMap resultmap=null;
String currencyformat=null;
double splprice=0;
double origprice=0;
HashMap dismap=null;
String discountamt=null;
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"event.poweredbyEB","no")));
if(registrationAllowed){
	//alltickets=getAllActiveTicketInfo(groupid);
	alltickets=EventTicketDB.getAllActiveTicketInfo(groupid);
	EventConfigScope evt_scope=new EventConfigScope();
  HashMap scopemap=evt_scope.getEventConfigValues(groupid,"Registration");
   currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{groupid});
  if(currencyformat==null)
		currencyformat="$";
		 if(partnerid!=null){
 resultmap=PartnerCommisions.getSplcommission(groupid,partnerid,pfriendid);
 if(resultmap!=null&&resultmap.size()>0){
 
 partnercommision=(String)resultmap.get("partnercommision");
 
 splcommision=(HashMap)resultmap.get("splcommisionmap");
 partnerticcomdetails=(HashMap)resultmap.get("partnerticcomdetailsmap");

 }
 
  }
  if(discount!=null){
dismap= getTicketDiscounts(groupid,discount);
discountamt=DbUtil.getVal("select discount from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?",new String[]{discount,groupid});
}
  
  
	for(int i=0;i<alltickets.size();i++){
				
	  
				HashMap ticketmp=(HashMap)alltickets.elementAt(i);
				
			
				//System.out.println("t")
				// Special commision price sending throug ticket price.
				try{    
					origprice=Double.valueOf((String)ticketmp.get("price")).doubleValue();
					splprice=(origprice)-((Double.valueOf((String)partnerticcomdetails.get((String)ticketmp.get("price_id"))).doubleValue())*(Double.valueOf(partnercommision).doubleValue())/100);
					
					if(origprice>splprice)
					ticketmp.put("splprice",CurrencyFormat.getCurrencyFormat("",Double.toString(splprice),true));
					}catch(Exception e){
						//System.out.println("Exception at special price-->"+e.getMessage());
					}
				
				         if(dismap!=null&&dismap.size()>0){
					
					String ticketid=(String)ticketmp.get("price_id");
					
					if(dismap.get(ticketid)!=null){
					
					origprice=Double.valueOf((String)ticketmp.get("price")).doubleValue();
					splprice=(origprice)-(Double.valueOf(discountamt).doubleValue());
					if(origprice>splprice)
					ticketmp.put("splprice",CurrencyFormat.getCurrencyFormat("",Double.toString(splprice),true));

					
					}
					
					
					
					
					
					
					}
				
				if ("Public".equals((String)ticketmp.get("tickettype")))
								{	vm_pub.addElement(ticketmp);
									 v=getReqGroupDetails(groupid,vm_pub,"Public");
									
									vm_pub=orderTickets(vm_pub,v);
									
									}
								if ("Optional".equals((String)ticketmp.get("tickettype")))
									{vm_opt.addElement(ticketmp);
									
									 v1=getReqGroupDetails(groupid,vm_opt,"Optional");
														
									vm_opt=orderTickets(vm_opt,v1);
									
					}
			request.setAttribute("TICKETHEADER",new String [] {"Name","Description","Price ("+currencyformat+")"});
		  ticketprintableversion="<input type='button' name='button1' value='Printable version' onclick=javascript:popupwindow('/portal/printdetails/ticketinfo.jsp?groupid="+groupid+"','Print','400','400') />";
		  ticketprintableversionlink="<a href=javascript:popupwindow('/portal/printdetails/ticketinfo.jsp?groupid="+groupid+"','Print','400','400') >";
	}
	
	
	
}


String reqcount="0";
if(vm_opt!=null&&vm_opt.size()>0){
reqcount=DbUtil.getVal("select count(*) from price where evt_id=? and ticket_type  in('Public')",new String []{groupid});
if("".equals(reqcount)||reqcount==null)reqcount="0";
if(Integer.parseInt(reqcount)==0)
request.setAttribute("ONLYOPTTICKETS","yes");

}


request.setAttribute("TICKETPRINTABLEVERSIONBUTTON",ticketprintableversion);
request.setAttribute("TICKETPRINTABLEVERSIONLINK",ticketprintableversionlink);
if(vm_pub.size()==0)vm_pub=null;
if(vm_opt.size()==0)vm_opt=null;
request.setAttribute("OPTIONALTICKETS",vm_opt);
request.setAttribute("REQUIREDTICKETS",vm_pub);

request.setAttribute("CURRENCYFORMAT",currencyformat);


%>
