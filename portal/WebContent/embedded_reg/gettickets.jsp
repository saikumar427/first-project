<%@ page import="org.json.JSONObject,org.apache.velocity .*,org.apache.velocity.app.*,java.io.*,java.util.*" %><%@ page import="com.eventbee.general.*,com.eventbee.event.DateTime" %><%@ page import="org.apache.fop.apps.*,javax.xml.transform.*,javax.xml.transform.stream.StreamSource,javax.xml.transform.sax.SAXResult"%><%!
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String TRACKING_QUERY="insert into mytickets_track (tid,status,source,date) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
String getFOPContent(String tid){
	String eventid=DbUtil.getVal("select eventid from event_reg_transactions where tid=? and paymentstatus='Completed' limit 1",new String[]{tid});
	String result="";
	if(eventid!=null && !"".equals(eventid)){
	String ticketlayout="";
	String logoURL="";
	String ticketids="";
	String finalLayout="";
	String ticketlayout_noscancodes="";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery("select * from ticket_pdf_settings where event_id=? ",new String []{eventid});
	if(sb.getStatus()){
	}else{
		String lang=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?) and name='event.i18n.lang'",new String[]{eventid});
		if(lang==null || "".equals(lang)) lang="en_US";
		sb=db.executeSelectQuery("select * from ticket_pdf_settings where event_id='0' and lang=?",new String []{lang});
	}
	if(sb.getStatus()){
		ticketids=db.getValue(0,"ticket_id","");
		ticketlayout = db.getValue(0,"ticket_layout","");
		ticketlayout_noscancodes = db.getValue(0,"ticket_layout_noscancodes","");
		logoURL = db.getValue(0,"logo_url",serveraddress+"/home/images/logo_big.jpg");
	}
	
	ArrayList purchasedtickets=getConfirmationTicketDetails(tid,eventid,ticketids);
	HashMap scancodeMap=getEnableScanbars(eventid);
	if(!purchasedtickets.isEmpty()){
		
		result= result + "<fo:root xmlns:fo='http://www.w3.org/1999/XSL/Format'>"
		+"<fo:layout-master-set>"
		+"<fo:simple-page-master page-height='11.0in' master-name='PageMaster'  margin-top='0.5in' margin-bottom='0.5in' margin-left='0.5in' margin-right='0.25in' >"
		+"<fo:region-body border-width='0in' border-style='solid'/>"
		+"<fo:region-after display-align='after' extent='10mm'/>"
		+"</fo:simple-page-master>"
		+"</fo:layout-master-set>";
		
		HashMap evtmap=getEventInfo(eventid);
		String eventNm = GenUtil.AllXMLEncode((String)evtmap.get("EVENTNAME"));
		String startday = (String)evtmap.get("StartDate_Day");
		String starttime = (String)evtmap.get("STARTTIME");
		String endday = (String)evtmap.get("EndDate_Day");
		String endtime = (String)evtmap.get("ENDTIME");
		String venue = GenUtil.AllXMLEncode((String)evtmap.get("VENUE"));
		String location = GenUtil.AllXMLEncode((String)evtmap.get("LOCATION"));
		String where ="";
		if(!"".equals(venue) && venue!=null)
			where=venue+" "+location;
		else where =location;
		HashMap <String,String>regDetails=getTransactionDetails(tid);
		String eventdate=GenUtil.getHMvalue(regDetails,"eventdate","");
		if(eventdate==null || "".equals(eventdate.trim()) || "null".equals(eventdate.trim()))
			eventdate=startday+" "+starttime+" - "+endday+" "+endtime;
		HashMap buyerDetails=getBuyerInfo(tid,eventid);
		
		String buyerNm="";
		String buyerEmail="";
		if(buyerDetails!=null){
			String buyerFNm=GenUtil.AllXMLEncode((String)buyerDetails.get("firstName"));
			String buyerLNm=GenUtil.AllXMLEncode((String)buyerDetails.get("lastName"));
			buyerNm=buyerFNm+" "+buyerLNm;
			buyerEmail=(String)buyerDetails.get("email");
		}
		try{
			for(int i=0;i<purchasedtickets.size();i++){
				
				HashMap hm=(HashMap)purchasedtickets.get(i);
				String attendeeNm = GenUtil.AllXMLEncode((String)hm.get("attendeeName"));
				if("".equals(attendeeNm)) attendeeNm=buyerNm;
				String ticketNm = GenUtil.AllXMLEncode((String)hm.get("ticketName"));
				String seatCode = (String)hm.get("seatCodes");
				String ticketid=(String)hm.get("ticketId");
				VelocityContext mp = new VelocityContext();
				
				mp.put("eventName",eventNm);
				mp.put("when",eventdate);
				mp.put("where",where);
				mp.put("transactionKey",tid);
				mp.put("orderNumber",GenUtil.getHMvalue(regDetails,"ordernumber","0"));
				mp.put("orderDate",regDetails.get("transactiondate"));
				mp.put("buyerName",buyerNm);
				mp.put("buyerEmail",buyerEmail);
				mp.put("logoUrl",logoURL);
				
				mp.put("attendeeName",attendeeNm);
				mp.put("ticketName",ticketNm);
				mp.put("seatCode",seatCode);
				if("Yes".equalsIgnoreCase((String)scancodeMap.get(ticketid))){
				String barcode = (String)hm.get("barcode");
				String qrcode = (String)hm.get("qrcode");
				mp.put("barcode",barcode);
				mp.put("qrcode",qrcode);
				finalLayout=ticketlayout;
				}else
				finalLayout=ticketlayout_noscancodes;
				
				result=result+getVelocityOutPut(mp,finalLayout);
			}
		}catch(Exception e){
			System.out.println("Exception in gettickets.jsp getPDFTicket: "+e.getMessage());
		}
		result=result+"</fo:root>";
		}
	}
	
	return result;
}

public HashMap<String,String> getEnableScanbars(String eid){
	
	 HashMap<String,String> result=new  HashMap<String,String>();
	 String query="select price_id,scan_code_required,isdonation from  price where evt_id=? ::integer ";
	 DBManager db=new DBManager();
	 StatusObj stb=db.executeSelectQuery(query,new String[]{eid} );
	 if(stb.getStatus())
	 { for(int i=0;i<stb.getCount();i++)
	   result.put(db.getValue(i, "price_id", ""),"Yes".equals(db.getValue(i, "isdonation", "No"))?db.getValue(i, "scan_code_required", "No"):db.getValue(i, "scan_code_required", "Yes"));
	 }	
	 
	 System.out.println("scabars ::"+result);
  return result;
	
}



public ArrayList getConfirmationTicketDetails(String tid,String eid,String ticketids){
	ArrayList al=new ArrayList();
	HashMap <String,String>attendeemap=null;
	ArrayList purchasedTickets=getpurchasedTickets(tid,eid,ticketids);
	JSONObject jobj=null;
	String objstring=null;
	if(purchasedTickets!=null){
	try{
	for(int i=0;i<purchasedTickets.size();i++){
		HashMap hm=(HashMap)purchasedTickets.get(i);
		ArrayList profile=(ArrayList)hm.get("profiles");
		for(int p=0;p<profile.size();p++){
			attendeemap=(HashMap)profile.get(p);
			jobj=new JSONObject();
			jobj.put("eid",eid);
			jobj.put("xid",tid);
			jobj.put("on","1");
			jobj.put("tn",(String)hm.get("ticketName"));
			jobj.put("tId",(String)hm.get("ticketId"));
			jobj.put("pkey",attendeemap.get("profilekey"));
			jobj.put("fn",attendeemap.get("fname"));
			jobj.put("ln",attendeemap.get("lname"));
			objstring=jobj.toString();
			
			HashMap gm=new HashMap();
			gm.putAll(hm);
			gm.put("attendeeName",attendeemap.get("name"));
			gm.put("profilekey",attendeemap.get("profilekey"));
			String seatcode=attendeemap.get("seatcode");
			if("".equals(seatcode) || seatcode==null){}
			else{
				gm.put("seatCodes",attendeemap.get("seatcode"));
			}
			
			HashMap qr_barcodemsg=getQrCodeBarCode(eid);
			String pdfbarcode="",pdfqrcode="";
			pdfbarcode=(String)qr_barcodemsg.get("pdfbarcode");
			pdfqrcode=(String)qr_barcodemsg.get("pdfqrcode");
			try{
				
				String pdfbar[]=pdfbarcode.split("#msg");
				pdfbarcode=serveraddress+"/"+pdfbar[0]+jobj.get("pkey")+pdfbar[1];
				System.out.println("in gettickets.jsp pdfbarcode: "+pdfbarcode);
				String pdfqr[]=pdfqrcode.split("#msg");
				pdfqrcode=pdfqr[0]+java.net.URLEncoder.encode(objstring);
				System.out.println("in gettickets.jsp pdfqrcode: "+pdfqrcode);
				
			}catch(Exception e){System.out.println("exception in gettickets.jsp scancodes: "+e.getMessage());}
			gm.put("barcode", pdfbarcode);
			gm.put("qrcode", pdfqrcode);
			gm.put("ticketId",(String)hm.get("ticketId"));
			al.add(gm);
		}
	}
	}catch(Exception e){
		System.out.println("Exception in gettickets.jsp getConfirmationTicketDetails: "+e.getMessage());
	}
	}
	return al;
}

public HashMap <String,String>getTransactionDetails(String tid){
	HashMap <String,String>transactionMap=new HashMap<String,String>();
	try{
	String  TRANSACTION_DETAILS="select ordernumber,eventdate,to_char(transaction_date, 'Month DD, YYYY') as transactiondate from event_reg_transactions where tid=?";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(TRANSACTION_DETAILS,new String []{tid});
	if(sb.getStatus()){
	transactionMap.put("ordernumber",db.getValue(0,"ordernumber",""));
	transactionMap.put("eventdate",db.getValue(0,"eventdate"," "));
	transactionMap.put("transactiondate",db.getValue(0,"transactiondate"," "));
	}
	}
	catch(Exception e){
	System.out.println("Exception in gettickets.jsp getTransactionDetails: "+e.getMessage());
	}
	return transactionMap;
	}

public ArrayList getpurchasedTickets(String tid,String eid,String ticketids){
	HashMap <String,ArrayList>attendeeDetails=getAttendeeDetails(tid);
	ArrayList ticketlist=new ArrayList();
	try{
		String ticketsQuery="";
		if(!"".equals(ticketids))
			ticketsQuery="select ticketid,ticketname,ticketqty from transaction_tickets where tid=? and ticketid in ("+ticketids+")";
		else
			ticketsQuery="select ticketid,ticketname,ticketqty from transaction_tickets where tid=?";
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(ticketsQuery,new String[]{tid});
		if(sb.getStatus()){
		for(int k=0;k<sb.getCount();k++){
		HashMap hm=new HashMap();
		hm.put("ticketId",db.getValue(k,"ticketid",""));
		hm.put("ticketName",db.getValue(k,"ticketname",""));
		hm.put("ticketQuantity",db.getValue(k,"ticketqty",""));
		if(attendeeDetails.containsKey(db.getValue(k,"ticketid",""))){
			hm.put("profiles",attendeeDetails.get(db.getValue(k,"ticketid","")));
		}
		ticketlist.add(hm);
		}
		}
		
	}
	catch(Exception e){
	System.out.println("Exception in gettickets.jsp getting getpurchasedTickets: "+e.getMessage());
	}
	return ticketlist;
}

HashMap<String,ArrayList>getAttendeeDetails(String tid){
	HashMap <String,ArrayList>hm=new HashMap<String,ArrayList>();
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery("select ticketid,profilekey,fname,lname,tickettype,seatcode from profile_base_info where transactionid=?",new String[]{tid});
	if(sb.getStatus()){
	ArrayList attndeelist=null;
	for(int k=0;k<sb.getCount();k++){
	HashMap hmap=new HashMap();
	hmap.put("profilekey",db.getValue(k,"profilekey",""));
	String fname=db.getValue(k,"fname","");
	String lname=db.getValue(k,"lname","");
	hmap.put("fname",fname);
	hmap.put("lname",lname);
	hmap.put("name",fname+" "+lname);
	hmap.put("tickettype",db.getValue(k,"tickettype",""));
	hmap.put("seatcode",db.getValue(k, "seatcode", ""));
	
	if(hm.containsKey(db.getValue(k,"ticketid",""))){
	attndeelist=hm.get(db.getValue(k,"ticketid",""));
	attndeelist.add(hmap);
	}else{
	attndeelist=new ArrayList();
	attndeelist.add(hmap);
	}
	hm.put(db.getValue(k,"ticketid",""),attndeelist);
	}
	}
	return hm;
	}

public HashMap getBuyerInfo(String tid,String eid){
	HashMap hm=new HashMap();
	try{
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery("select * from buyer_base_info where transactionid=?",new String[]{tid});
		if(sb.getStatus()){
		hm.put("firstName",db.getValue(0,"fname",""));
		hm.put("lastName",db.getValue(0,"lname",""));
		hm.put("email",db.getValue(0,"email",""));
		hm.put("phone",db.getValue(0,"phone",""));
		}
	}catch(Exception e){
		System.out.println("Exception in getting buyerInfo"+e.getMessage());
		}
	return hm;
}

HashMap getEventInfo(String eventid){
	HashMap hm=new HashMap();
	try{
		String EVENT_INFO_QUERY="select venue,starttime,endtime,eventname, "
			+"trim(to_char(start_date,'Day')) ||', '|| to_char(start_date,'Month DD, YYYY') as start_date,"
			+"trim(to_char(end_date,'Day')) ||', '|| to_char(end_date,'Month DD, YYYY') as end_date,"
			+"city,state,address1,address2,country from eventinfo where eventid=CAST(? AS INTEGER)";
		DBManager dbmanager = new DBManager();
		StatusObj statobj=null;
		statobj=dbmanager.executeSelectQuery(EVENT_INFO_QUERY,new String []{eventid});
		int count=statobj.getCount();
        if(statobj.getStatus()&&count>0){
        	hm.put("EVENTNAME", dbmanager.getValue(0,"eventname",""));
        	hm.put("StartDate_Day",dbmanager.getValue(0,"start_date",""));
        	hm.put("EndDate_Day",dbmanager.getValue(0,"end_date",""));
        	hm.put("STARTTIME", DateTime.getTimeAM(dbmanager.getValue(0,"starttime","")));
        	hm.put("ENDTIME", DateTime.getTimeAM(dbmanager.getValue(0,"endtime","")));
        	hm.put("LOCATION",GenUtil.getCSVData(new String[]{dbmanager.getValue(0,"city",""),dbmanager.getValue(0,"state",""),dbmanager.getValue(0,"country","")}));
        	hm.put("VENUE",GenUtil.getCSVData(new String[]{dbmanager.getValue(0,"venue",""),dbmanager.getValue(0,"address1",""),dbmanager.getValue(0,"address2","")}));
		}
	}catch(Exception e){
              System.out.println("Exceptio in getEventInfo ERROR: "+e.getMessage());
	}
	return hm;
   }

String getVelocityOutPut(VelocityContext vc,String Template){
	StringBuffer str=new StringBuffer();
	java.io.StringWriter out1=new java.io.StringWriter();
	VelocityEngine ve= new VelocityEngine();
	try{
		ve.init();
		boolean abletopares=ve.evaluate(vc,out1,"pdftickettemplate",Template );
		str=out1.getBuffer();
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return str.toString();
	}

public HashMap getQrCodeBarCode(String eid) {
	HashMap codemap=new HashMap();
	String code_query="select * from barcode_qrcode_settings where eventid=?";
	DBManager db=new DBManager();
	StatusObj code_sb=db.executeSelectQuery(code_query, new String[]{eid});
	if(code_sb.getStatus()){
		codemap.put("pdfbarcode",db.getValue(0, "pdfbarcode", ""));
		codemap.put("pdfqrcode",db.getValue(0, "pdfqrcode", ""));
	}
	else{
		code_sb=db.executeSelectQuery(code_query, new String[]{"0"});
		codemap.put("pdfbarcode",db.getValue(0, "pdfbarcode", ""));
		codemap.put("pdfqrcode",db.getValue(0, "pdfqrcode", ""));
	}
	return codemap;
}
%><%
String tid = request.getParameter("tid");
try{
    System.out.println("PDF Tickets for Transaction ID: "+tid);
	if(tid==null){
		tid="";
		DbUtil.executeUpdateQuery(TRACKING_QUERY,new String[]{tid,"Invalid TID","PDF Ticket",DateUtil.getCurrDBFormatDate()});
		response.sendRedirect("/main/user/gettickets?error=invalid&tid="+tid);
		return;
	}
    String result=getFOPContent(tid.trim());
	if(result==null || "".equals(result)){
		DbUtil.executeUpdateQuery(TRACKING_QUERY,new String[]{tid,"Invalid TID","PDF Ticket",DateUtil.getCurrDBFormatDate()});
		response.sendRedirect("/main/user/gettickets?error=invalid&tid="+tid);
		return;
	}
    StringReader reader = new StringReader(result);
    FopFactory fopFactory = FopFactory.newInstance();
    FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
    ByteArrayOutputStream outStream = new ByteArrayOutputStream();
    Fop fop = fopFactory.newFop("application/pdf",foUserAgent, outStream);
    TransformerFactory factory = TransformerFactory.newInstance();
    Transformer transformer = factory.newTransformer();
    Result res = new SAXResult(fop.getDefaultHandler());
    transformer.transform(new StreamSource(reader), res);
    byte[] pdfBytes = outStream.toByteArray();
    response.setContentLength(pdfBytes.length);
    response.setContentType("application/pdf");
    response.getOutputStream().write(pdfBytes);
    response.getOutputStream().flush();
	DbUtil.executeUpdateQuery(TRACKING_QUERY,new String[]{tid,"Success","PDF Ticket",DateUtil.getCurrDBFormatDate()});

}catch(Exception exception){
	System.out.println("Exception In pdftest.jsp: "+exception.getMessage());
	DbUtil.executeUpdateQuery(TRACKING_QUERY,new String[]{tid,"FOP Failed","PDF Ticket",DateUtil.getCurrDBFormatDate()});
	response.sendRedirect("/main/user/gettickets?error=exception&tid="+tid);
	return;
}
%>