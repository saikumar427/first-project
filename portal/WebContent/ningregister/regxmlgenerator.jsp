<%@ page import="java.util.*,com.eventbee.general.*"%>
<%@ page import="org.dom4j.Document,org.dom4j.DocumentHelper,org.dom4j.Element"%>
<%!
private ArrayList getReqTicketDetails(String tid,String tickettype){
try{
	String query="select * from event_reg_ticket_details where tid=? and tickettype=?";
	ArrayList ar=new ArrayList();
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query,new String[]{tid,tickettype});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			HashMap ticketMap=new HashMap();
			ticketMap.put("ticketname",db.getValue(i,"ticketname","0"));
			ticketMap.put("ticketid",db.getValue(i,"ticketid","0"));
			ticketMap.put("price",db.getValue(i,"price","0"));
			ticketMap.put("qty",db.getValue(i,"qty","0"));
			ticketMap.put("discount",db.getValue(i,"discount","0"));
			ticketMap.put("processfee",db.getValue(i,"processfee","0"));
			ar.add(ticketMap);
		}
	}
	return ar;
}catch(Exception ebeeexcep){
	EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "regxmlgenerator.jsp", "getReqTicketDetails()", ebeeexcep.getMessage(), ebeeexcep ) ;
}
return null;
}

private HashMap getRegistrationDetails(String tid,String eventid){
try{
	String query="select * from event_reg_details where tid=? and eventid=?";
	DBManager db=new DBManager();
	HashMap regMap=new HashMap();
	StatusObj sb=db.executeSelectQuery(query,new String[]{tid,eventid});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			regMap.put("grandtotal",db.getValue(i,"grandtotal","0"));
			regMap.put("granddiscount",db.getValue(i,"granddiscount","0"));
			regMap.put("tax",db.getValue(i,"tax","0"));
			regMap.put("paymenttype",db.getValue(i,"selectedpaytype","0"));
			regMap.put("ebeefee",db.getValue(i,"ebeefee","0"));
			regMap.put("attendeefee","0");
			regMap.put("mgrfee",db.getValue(i,"mgrfee","0"));
			regMap.put("cardfee",db.getValue(i,"cardfee","0"));
			regMap.put("discountcode",db.getValue(i,"discountcode","0"));
		}
	}
	return regMap;
}catch(Exception ebeeexcep){
	EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "regxmlgenerator.jsp", "getRegistrationDetails()", ebeeexcep.getMessage(), ebeeexcep ) ;
}
return null;
}

private ArrayList getEventAttendees(String tid,String eid){
try{
	String query="select * from event_attendee_info where tid=? and eventid=?";
	ArrayList al=new ArrayList();
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query,new String[]{tid,eid});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			HashMap attendeeMap=new HashMap();
			attendeeMap.put("fname",db.getValue(i,"fname","0"));
			attendeeMap.put("lname",db.getValue(i,"lname","0"));
			attendeeMap.put("email",db.getValue(i,"email","0"));
			attendeeMap.put("phone",db.getValue(i,"phone","0"));
			attendeeMap.put("priattendee",db.getValue(i,"priattendee","0"));
			attendeeMap.put("attendeekey",db.getValue(i,"attendeekey","0"));
			attendeeMap.put("attendeeid",db.getValue(i,"attendeeid","0"));
			attendeeMap.put("attendeeid",db.getValue(i,"attendeeid","0"));
			attendeeMap.put("authid",db.getValue(i,"authid","0"));
			al.add(attendeeMap);
		}
	}
	return al;
}catch(Exception ebeeexcep){
	EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "regxmlgenerator.jsp", "getEventAttendees()", ebeeexcep.getMessage(), ebeeexcep ) ;
}
return null;
}
public String getXmlContent(String eventid,String transactionId){
try{
	Document document = DocumentHelper.createDocument();
	document.setXMLEncoding("iso-8859-1");
    Element element_eventregistration = document.addElement( "event-registration" );
	String unitid="13579";
	String source="online";
	String userid="0";
	String paytype="";
	String ebeefee="";
	ArrayList reqTickets=getReqTicketDetails(transactionId,"required");
	ArrayList optTickets=getReqTicketDetails(transactionId,"optional");
	ArrayList eventattendees=getEventAttendees(transactionId,eventid);
	HashMap regMap=getRegistrationDetails(transactionId,eventid);
	
	Element element_ebeetransid = element_eventregistration.addElement( "ebee-trans-id" ).addText( transactionId );
	Element element_ebeeeventid = element_eventregistration.addElement( "ebee-event-id" ).addText( eventid );
	Element element_ebeeuserid = element_eventregistration.addElement( "ebee-user-id" ).addText( userid );
	Element element_ebeeunitid = element_eventregistration.addElement( "ebee-unit-id" ).addText( unitid );
	Element element_source = element_eventregistration.addElement( "source" ).addText( source );
	Element element_paytype = element_eventregistration.addElement( "paytype" ).addText( GenUtil.getHMvalue(regMap,"paymenttype") );
	if("eventbee".equals(regMap.get("paymenttype"))){
		Element element_mgrfee = element_eventregistration.addElement( "mgr-fee" ).addText( GenUtil.getHMvalue(regMap,"mgrfee") );
	}else{
		Element element_mgrfee = element_eventregistration.addElement( "mgr-fee" ).addText( GenUtil.getHMvalue(regMap,"ebeefee") );
	}
	Element element_grandtotal = element_eventregistration.addElement( "grand-total" ).addText( GenUtil.getHMvalue(regMap,"grandtotal") );
	Element element_granddiscount = element_eventregistration.addElement( "grand-discount" ).addText( GenUtil.getHMvalue(regMap,"granddiscount") );
	Element element_cardfee = element_eventregistration.addElement( "card-fee" ).addText( GenUtil.getHMvalue(regMap,"cardfee") );
	Element element_ebeefee = element_eventregistration.addElement( "ebee-fee" ).addText( GenUtil.getHMvalue(regMap,"ebeefee") );
	Element element_taxamount = element_eventregistration.addElement( "tax-amount" ).addText( GenUtil.getHMvalue(regMap,"tax") );
	Element element_attendeefee = element_eventregistration.addElement( "attendee-fee" ).addText( GenUtil.getHMvalue(regMap,"attendeefee") );
	Element element_attendeeTickets =element_eventregistration.addElement( "attendee-Tickets" );	
	if(reqTickets!=null && reqTickets.size()>0){
		HashMap reqTicketsMap=(HashMap)reqTickets.get(0);
		String processfee=(String)reqTicketsMap.get("processfee");
		double reqtotamount=0;
		double reqdisamount=0;
		if(processfee == null){
			processfee = "0";
		}
		String price=(String)reqTicketsMap.get("price");
		if(price == null){
			price = "0";
		}
		double ticketprice=0;
		try{
			ticketprice=Double.parseDouble(price)+Double.parseDouble(processfee);
		}catch(Exception e){
			ticketprice=0;
		}
		String discount=GenUtil.getHMvalue(reqTicketsMap,"discount");
		try{
		reqdisamount=Double.parseDouble(discount);
		
		}
		catch(Exception e){
		reqdisamount=0;
		}
		try{
			reqtotamount=(ticketprice-reqdisamount)*Integer.parseInt((String)reqTicketsMap.get("qty"));
		}catch(Exception e){
			reqtotamount=0;
		}
		Element element_attendeereqTicket = element_attendeeTickets.addElement( "attendee-req-Ticket" );
		Element element_ticketname = element_attendeereqTicket.addElement( "ticket-name" ).addText( GenUtil.getHMvalue(reqTicketsMap,"ticketname") );
		Element element_price = element_attendeereqTicket.addElement( "price" ).addText( Double.toString(ticketprice) );
		Element element_quantity = element_attendeereqTicket.addElement( "quantity" ).addText( GenUtil.getHMvalue(reqTicketsMap,"qty") );
		Element element_couponcode = element_attendeereqTicket.addElement( "coupon-code" ).addText( GenUtil.getHMvalue(regMap,"discountcode") );
		Element element_discount = element_attendeereqTicket.addElement( "discount" ).addText( GenUtil.getHMvalue(reqTicketsMap,"discount") );
		Element element_ticektid = element_attendeereqTicket.addElement( "ticekt-id" ).addText( GenUtil.getHMvalue(reqTicketsMap,"ticketid") );
		Element element_ticektfee = element_attendeereqTicket.addElement( "ticekt-fee" ).addText( processfee );
		Element element_ticektdisplayprice = element_attendeereqTicket.addElement( "ticekt-display_price" ).addText( price );
		Element element_reqtickettotalamount = element_attendeereqTicket.addElement( "req-ticket-total-amount" ).addText( Double.toString(reqtotamount) );
	}
	if(optTickets!=null&&optTickets.size()>0){
		for(int i=0;i<optTickets.size();i++){
			HashMap optTicketsMap=(HashMap)optTickets.get(i);
			String processfee=(String)optTicketsMap.get("processfee");
			double optdisamount=0;
		         if(processfee == null){
				processfee = "0";
			}
			String price=(String)optTicketsMap.get("price");
			if(price == null){
				price = "0";
			}
			double ticketprice=0;
			try{
				ticketprice=Double.parseDouble(price)+Double.parseDouble(processfee);
			}catch(Exception e){
				ticketprice=0;
			}
			String optdiscount=GenUtil.getHMvalue(optTicketsMap,"discount");
			try{
			optdisamount=Double.parseDouble(optdiscount);
			}
			catch(Exception e){
			optdisamount=0;
			}
			double opttotamount=0;
			try{
				opttotamount=(ticketprice-optdisamount)*Integer.parseInt((String)optTicketsMap.get("qty"));
			}catch(Exception e){
				opttotamount=0;
			}
			Element element_attendeeoptTicket = element_attendeeTickets.addElement( "attendee-opt-Ticket" ).addAttribute("index",""+i);
			Element element_ticketname = element_attendeeoptTicket.addElement( "ticket-name" ).addText( GenUtil.getHMvalue(optTicketsMap,"ticketname") );
			Element element_price = element_attendeeoptTicket.addElement( "price" ).addText(Double.toString(ticketprice));
			Element element_quantity = element_attendeeoptTicket.addElement( "quantity" ).addText( GenUtil.getHMvalue(optTicketsMap,"qty") );
			Element element_couponcode =element_attendeeoptTicket.addElement( "coupon-code" ).addText( GenUtil.getHMvalue(regMap,"discountcode"));
			Element element_discount = element_attendeeoptTicket.addElement( "discount" ).addText( GenUtil.getHMvalue(optTicketsMap,"discount") );;
			Element element_ticektid = element_attendeeoptTicket.addElement( "ticekt-id" ).addText( GenUtil.getHMvalue(optTicketsMap,"ticketid") );
			Element element_ticektfee = element_attendeeoptTicket.addElement( "ticekt-fee" ).addText( processfee );
			Element element_ticektdisplayprice = element_attendeeoptTicket.addElement( "ticekt-display_price" ).addText(GenUtil.getHMvalue(optTicketsMap,"price")  );
			Element element_opttickettotalamountamount = element_attendeeoptTicket.addElement( "opt-ticket-total-amount" ).addText( Double.toString(opttotamount) );
		}
	}
	if(eventattendees!=null&&eventattendees.size()>0){
		Element element_eventattendees = element_eventregistration.addElement( "event-attendees" );
		for(int i=0;i<eventattendees.size();i++){
			HashMap attendeeMap=(HashMap)eventattendees.get(i);
			String fname=(String)attendeeMap.get("fname");
			String lname=(String)attendeeMap.get("lname");
			String preattendee="";
			String uname=fname.substring(0,1)+lname;
			if(fname == null){
				fname = "";
			}
			if(lname == null){
				lname = "";
			}
			if(uname == null){
				uname = "";
			}
			Element element_eventattendee = element_eventattendees.addElement( "event-attendee" ).addAttribute("index",""+i);
			if(i!=0){
				userid="0";
				preattendee="N";
			}else
				preattendee="Y";
				Element element_uname = element_eventattendee.addElement( "u-name" ).addText( uname );
				Element element_fname = element_eventattendee.addElement( "f-name" ).addText( fname );
				Element element_lname = element_eventattendee.addElement( "l-name" ).addText( lname );
				Element element_email = element_eventattendee.addElement( "email" ).addText( GenUtil.getHMvalue(attendeeMap,"email") );
				Element element_phone = element_eventattendee.addElement( "phone" ).addText( GenUtil.getHMvalue(attendeeMap,"phone") );
				Element element_company = element_eventattendee.addElement( "company" ).addText( GenUtil.getHMvalue(attendeeMap,"company") );
				Element element_title = element_eventattendee.addElement( "title" ).addText( GenUtil.getHMvalue(attendeeMap,"title") );
				Element element_city = element_eventattendee.addElement( "city" ).addText( GenUtil.getHMvalue(attendeeMap,"city") );
				Element element_state = element_eventattendee.addElement( "state" ).addText( GenUtil.getHMvalue(attendeeMap,"state") );
				Element element_country = element_eventattendee.addElement( "country" ).addText( GenUtil.getHMvalue(attendeeMap,"country") );
				Element element_zip = element_eventattendee.addElement( "zip" ).addText( GenUtil.getHMvalue(attendeeMap,"zip") );
				Element element_attendeeid = element_eventattendee.addElement( "attendee-id" ).addText( GenUtil.getHMvalue(attendeeMap,"attendeeid") );
				Element element_attendeekey = element_eventattendee.addElement( "attendee-key" ).addText( GenUtil.getHMvalue(attendeeMap,"attendeekey") );
				Element element_gender = element_eventattendee.addElement( "gender" ).addText( GenUtil.getHMvalue(attendeeMap,"gender") );
				Element element_comments = element_eventattendee.addElement( "comments" ).addText( GenUtil.getHMvalue(attendeeMap,"comments") );
				Element element_street1 = element_eventattendee.addElement( "street1" ).addText( GenUtil.getHMvalue(attendeeMap,"address1") );
				Element element_street2 = element_eventattendee.addElement( "street2" ).addText( GenUtil.getHMvalue(attendeeMap,"address2") );
				Element element_priattendee = element_eventattendee.addElement( "priattendee" ).addText( preattendee );
		}
	}
	return document.asXML();
}catch(Exception ebeeexcep){
	EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "regxmlgenerator.jsp", "getXmlContent()", ebeeexcep.getMessage(), ebeeexcep ) ;
}
return null;
}
%>
