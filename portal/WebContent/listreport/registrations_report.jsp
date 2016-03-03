<%@ page import="java.util.*,java.sql.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbee.event.ticketinfo.AttendeeInfoDB"%>
<%@ page import="com.eventbee.pdfgen.ReportGenerator"%>
<%@ page import="com.eventbeepartner.partnernetwork.AttendeeListReports,com.eventbeepartner.partnernetwork.RegistrationReports"%>
<%!
public static final String GET_OTHER_PAYMENT_REGISTRATIONS_TILLDATE="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
  +" to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,discount  from transaction a, eventattendee b,attendeeticket c where "
  +" refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and"
  +" priattendee='Y' and a.source='online' and c.transactiontype ='other' "
  +" order by trandate desc";

public static final String GET_OTHER_PAYMENT_REGISTRATIONS_BETWEENDATES="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
  +" to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,a.discount from transaction a, eventattendee b,attendeeticket c "
  +" where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and "
  +" priattendee='Y'and a.source='online' and  c.transactiontype ='other' and  trandate>=? and trandate<=? "
  +" order by trandate desc";


public static final String GET_OTHER_PAYMENT_TRANSACTION_DETAILS="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
    +" to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,a.discount  from transaction a, eventattendee b,attendeeticket c "
    +" where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and "
    +" priattendee='Y' and a.source='online' and  c.transactiontype ='other'  and a.transactionid=? "
    +" order by trandate desc";

public static final String GET_OTHER_PAYMENT_ATTENDEE_DETAILS="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
    +" to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,a.discount   from transaction a, eventattendee b,attendeeticket c "
    +" where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and "
    +" priattendee='Y' and a.source='online' and  c.transactiontype ='other' and firstname||' '||lastname like ? "
    +" order by trandate desc";

public static final String GET_OTHER_PAYMENT_REGISTRATIONS_TILLDATE_AGENT="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
   +" to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,discount  from transaction a, eventattendee b,attendeeticket c  where "
   +" refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and "
   +" priattendee='Y'  and a.source='online' and  c.transactiontype ='other' and  a.agentid=? ";

public static final String GET_OTHER_PAYMENT_REGISTRATIONS_BETWEENDATES_AGENT="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
   +"to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,discount from transaction a, eventattendee b,attendeeticket c"
   +"where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and "
   +"priattendee='Y'  and a.source='online' and  c.transactiontype ='other' and trandate>=? and trandate<=? and agentid=? ";

public static final String GET_OTHER_PAYMENT_TRANSACTION_DETAILS_AGENT="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
    +"to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,a.discount  from transaction a, eventattendee b,attendeeticket c "
    +"where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and "
    +"priattendee='Y'  and a.source='online' and  c.transactiontype ='other' and a.transactionid=? and agentid=? ";


public static final String GET_OTHER_PAYMENT_ATTENDEE_DETAILS_AGENT="select distinct a.agentid,a.transactionid,firstname,lastname,firstname || ' ' || lastname as name,"
    +"to_char(trandate,'mm/dd/yyyy') as trandate,grandtotal,totalamount,a.ebeefee,mgrfee,attendeefee,cardfee,agentcommission,a.discount from transaction a, eventattendee b,attendeeticket c "
    +"where refid=? and purpose='EVENT_REGISTRATION' and a.transactionid=b.transactionid and a.transactionid=c.transactionid and "
    +"priattendee='Y'  and a.source='online' and  c.transactiontype ='other' and firstname||' '||lastname like ? and agentid=? ";




public Vector getOtherTransactionInfo(String groupid,int selectedvalue, HttpServletRequest req,String cardtype){
      Connection con=null;
	Vector tv=null;
	HashMap traninfo=null;
	java.sql.PreparedStatement pstmt=null;
	ResultSet rs=null;
	  if(selectedvalue!=5){ 
	
	String[] queries =new String[]{GET_OTHER_PAYMENT_REGISTRATIONS_TILLDATE,GET_OTHER_PAYMENT_REGISTRATIONS_BETWEENDATES,GET_OTHER_PAYMENT_TRANSACTION_DETAILS,GET_OTHER_PAYMENT_ATTENDEE_DETAILS} ;
	String agentid=req.getParameter("agentid");
	if(agentid!=null){
		try{
			Integer.parseInt(agentid);
			queries =new String[]{GET_OTHER_PAYMENT_REGISTRATIONS_TILLDATE_AGENT,GET_OTHER_PAYMENT_REGISTRATIONS_BETWEENDATES_AGENT,GET_OTHER_PAYMENT_TRANSACTION_DETAILS_AGENT,GET_OTHER_PAYMENT_ATTENDEE_DETAILS_AGENT};
		}catch(Exception e){
			agentid=null;
		}
	}
	try{
	        String cardtype2="";
	        if("PAYPALPRO".equals(cardtype))
	        cardtype2="SKIPJACK";
	        else
	        cardtype2=cardtype;
	        con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(queries[selectedvalue-1]);
		pstmt.setString(1,groupid);
		if(selectedvalue==2){
			String startdate=req.getParameter("startMonth")+"-"
				+ req.getParameter("startDay")+"-"
				+ req.getParameter("startYear");
			String enddate=req.getParameter("endMonth")+"-"
				+req.getParameter("endDay")+"-"
				+req.getParameter("endYear");
			pstmt.setString(2,startdate);
			pstmt.setString(3,enddate);
			if(agentid!=null){
				pstmt.setString(4,agentid);

			}
		}else if(selectedvalue==3){
		String transactionid=req.getParameter("key");
		pstmt.setString(2,transactionid);
			if(agentid!=null){
				pstmt.setString(3,agentid);

			}

		}else if(selectedvalue==4){
		String attendee=req.getParameter("attendee");
		pstmt.setString(2,"%"+attendee+"%");
		if(agentid!=null){
				pstmt.setString(3,agentid);

			}
		}else{
			if(agentid!=null){
				pstmt.setString(2,agentid);

			}
		}
		rs=pstmt.executeQuery();
		if(rs.next()){
			tv=new Vector();
			do{
				traninfo=new HashMap();
				traninfo.put("transactionid", rs.getString("transactionid"));
				traninfo.put("trandate", rs.getString("trandate"));
				traninfo.put("firstname", rs.getString("firstname"));
				traninfo.put("lastname", rs.getString("lastname"));
				traninfo.put("totalamount", rs.getString("totalamount"));
				traninfo.put("grandtotal", rs.getString("grandtotal"));
				traninfo.put("ebeefee", rs.getString("ebeefee"));
				traninfo.put("mgrfee", rs.getString("mgrfee"));
				traninfo.put("cardfee", rs.getString("cardfee"));
				traninfo.put("attendeefee", rs.getString("attendeefee"));
				traninfo.put("agentcommission", rs.getString("agentcommission"));
				traninfo.put("agentid", rs.getString("agentid"));
				traninfo.put("discount", rs.getString("discount"));
				traninfo.put("name", rs.getString("name"));
				tv.add(traninfo);
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
		System.out.println("There is an error in registration_reportssssssss  :"+ e.getMessage());
		traninfo=null;
	}finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	}
	return tv;
}

%>


<%


        String paystatus=request.getParameter("paymentstaus");
        
      
	String process_vendor=EbeeConstantsF.get("cardvendor","PAYPALPRO");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"registrations_report.jsp","Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String platform = request.getParameter("platform");	    
	String URLBase="mytasks";
	  if("ning".equals(platform)){
		URLBase="ningapp";	
	  }
	String filter = request.getParameter("filter");    
	String groupid=request.getParameter("groupid");
   	String groupname=GenUtil.getEncodedXML((String)request.getParameter("groupname"));    
   	String submitbtn=request.getParameter("submit");
	String selindex=request.getParameter("selindex");
	String currency=DbUtil.getVal("select currency_code from event_currency where eventid=?", new String[]{groupid});
	if("USD".equals(currency)){
			currency="$";
		}else if("EUR".equals(currency)){
		currency="&euro;";
		}else if("GBP".equals(currency)){
		currency="&pound;";
		}else if("JPY".equals(currency)){
		currency="&yen;";
		}else if("AUD".equals(currency)){
		currency="AU$";
		}else if("CAD".equals(currency)){
		currency="C$";
		}else if("DKK".equals(currency)){
		currency="kr ";
		}else if("HKD".equals(currency)){
		currency="HK$";
		}else if("HUF".equals(currency)){
		currency="Ft";
		}else if("NZD".equals(currency)){
		currency="NZ$";
		}else if("NOK".equals(currency)){
		currency="kr ";
		}else if("SGD".equals(currency)){
		currency="S$";
		}else if("SEK".equals(currency)){
		currency="kr ";
		}else if("CHF".equals(currency)){
		currency="Fr ";
		}else if("MXN".equals(currency)){
		currency="MX$";
		}else{
		currency="$";
			}
	String type="";
	String key=request.getParameter("key"); 
	String rtype=request.getParameter("rtype");
	int selectedvalue=0;     
	if (selindex!=null) selectedvalue=Integer.parseInt(selindex);
	
	java.util.Date date=new java.util.Date();	
	SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
	String currentdate=format.format(date);
	if(rtype==null)  rtype="html";
	rtype=rtype.trim();
	AttendeeListReports reports=new AttendeeListReports(); 
	HashMap evtmap=reports.getEventDetails(groupid);
	RegistrationReports regreports=new RegistrationReports();		
	HashMap tmap=regreports.getTicketInfo(groupid); //Contains mappings for each registration transaction of this event
	
	ArrayList ar=(ArrayList)evtmap.get("address");
	String address="";
	
	if(ar!=null){
	for(int i=0;i<ar.toArray().length;i++){
	if("".equals(address))
	address=address+ar.toArray()[i];
	else
	address=address+", "+ar.toArray()[i];       
	}
	}
	String boldStyle="";
	String boldPreAppend="<b>";
	String boldAppend="</b>";
	boolean xmlEncode=false;
	if("html".equals(rtype)){
		boldStyle="padding-before='3pt' border-width='0pt' border-color='black' ";
	}else{
		boldStyle="font-weight='bold' font-size='12pt' padding-before='3pt' border-width='0pt' border-color='black' border-style='solid'   ";
		boldPreAppend="";
		boldAppend="";
		xmlEncode=true;
	}
	ReportGenerator report=ReportGenerator.getReportGenerator(rtype);
	StringBuffer content= new StringBuffer();
	report.startContent(content,"");      
	if(!"html".equals(rtype)){
		report.startTable(content,"text-align='center'","1");
		report.startRow(content,"font-weight='bold' font-size='12pt'  text-align='center'");
		report.fillColumn(content,"border-width='0pt' font-weight='bold'",regreports.getDisplayValue((String)evtmap.get("eventname"), xmlEncode));
		report.endRow(content);
		report.startRow(content,"font-weight='bold' font-size='12pt'  text-align='center'");
		report.fillColumn(content,"border-width='0pt' font-weight='bold'","When - Starts: "+(String)evtmap.get("startdate")+"  Ends: "+(String)evtmap.get("enddate"));
		report.endRow(content);
		report.startRow(content,"border-width='0pt' font-weight='bold' font-size='12pt'  text-align='center'");
		report.fillColumn(content,"border-width='0pt' font-weight='bold'","Where - "+regreports.getDisplayValue(address, xmlEncode));
		report.endRow(content);
		report.endTable(content);         
	}      
	
	String ColHeaderStyle="class='colheader'";
	boolean transactionsExists=false;
	String[] displayCols=request.getParameterValues("displayFields");
	String cols=""+displayCols.length;
	String[] headers=new String[]{"Eventbee Processing Transactions", "Google Processing Transactions", "Paypal Processing Transactions","Zero Payment Transactions","Other Payment Type Transactions"};
        String[] vendorTypes=new String[]{"eventbee", "google", "paypal","zerobased","other"};
        String[] signs =new String[]{"","-","-","-","-"};
        int[] typeSignFactor = new int[]{1,-1,-1,-1,-1};
        double grandDiscount=0.0; 
        double grandServiceFee=0.0;
        double grandCCFee=0.0;
        double grandTotalAmount=0.0;
        double grandTicketsTotalAmount=0.0;
        double grandNetPay=0.0;
        report.startTable(content,null,cols);
        
        HashMap colheaderNames=new HashMap();
	colheaderNames.put("Book Date","Booking Date");
	colheaderNames.put("Transaction ID","Transaction ID");
	colheaderNames.put("Status","Payment Status");
	colheaderNames.put("First Name","First Name");
	colheaderNames.put("Last Name","Last Name");
	colheaderNames.put("Ticket Name","Ticket Name");
	colheaderNames.put("Ticket Price","Ticket Price");
	colheaderNames.put("Tickets Count","Tickets Count");
	colheaderNames.put("Discount","Discount ("+currency+")");
	colheaderNames.put("Discount Code","Discount Code");
	colheaderNames.put("Tickets Total","Tickets Total ("+currency+")");
	colheaderNames.put("Service Fee","Service Fee ($)");
	colheaderNames.put("CC Processing Fee","CC Processing Fee ("+currency+")");
	colheaderNames.put("Net","Net Amount ("+currency+")");
	colheaderNames.put("NTS Commission","NTS Commission");
	colheaderNames.put("Total Net","Total Net ($)");
        
        HashMap colStyles=new HashMap();
	colStyles.put("Book Date","");
	colStyles.put("Transaction ID","");
	colStyles.put("Status","");
	colStyles.put("First Name","");
	colStyles.put("Last Name","");
	colStyles.put("Ticket Name","");
	colStyles.put("Ticket Price"," align='right' ");
	colStyles.put("Tickets Count"," align='right' ");
	colStyles.put("Discount"," align='right' ");
	colStyles.put("Discount Code","");
	colStyles.put("Tickets Total"," align='right' ");
	colStyles.put("Service Fee"," align='right' ");
	colStyles.put("CC Processing Fee"," align='right' ");
	colStyles.put("Net"," align='right' ");
	colStyles.put("NTS Commission"," align='right' ");
        colStyles.put("Total Net"," align='right' ");
        
        HashMap colContent=new HashMap();
        Vector tv=null;
	for(int k=0;k<5;k++) {
		double typeTotalAmount=0.0;
		double typeDiscountTotal=0.0;
		double typeTicketsTotalAmount=0.0;
		double typeServiceFeeTotal=0.0;
		double typeCCFeeTotal=0.0;
		double typeNetTotal=0.0;
		if(k==3)
		tv=regreports.getZeroTransactionInfo(groupid,selectedvalue,request,vendorTypes[k]);
		else if(k==4){
		tv=getOtherTransactionInfo(groupid,selectedvalue,request,vendorTypes[k]);
			
		}
		else
		tv=regreports.getTransactionInfo(groupid,selectedvalue,request,vendorTypes[k]);
		if (tv!=null&&tv.size()>0){
			
			report.startRow(content,"class='subheader'");
			if("html".equals(rtype))
			report.fillColumn(content,"colspan='"+cols+"' padding-end='3pt' padding-start='3pt' padding-after='3pt' padding-before='3pt' border-width='0pt' border-color='black' border-style='solid'","<b>"+headers[k]+"</b>");
			else
			report.fillColumn(content,"width='100%' padding-end='3pt' padding-start='3pt' padding-after='3pt' padding-before='3pt' border-width='0pt' border-color='black' border-style='solid'",headers[k]);
			report.endRow(content);
			
			report.startRow(content,null);
			for(int colindex=0;colindex<displayCols.length;colindex++){
				report.fillColumn(content,ColHeaderStyle,(String)colheaderNames.get(displayCols[colindex]));
			}
			report.endRow(content);
			
			transactionsExists=true;//atleast one transaction exists overall
			double totalagentcomm=0.0;
			
			double net=0.0;
			double grandtotal1=0;
			double totalnet=0;
			
			for(int i=0;i<tv.size();i++){
				String TicketCount="";
				String Ticketname="";
				String TicketPrice="";
				String discount=null;
				String discountcode="";
				double cardfee=0.0;
				double ebeefee=0.0;
				HashMap hmt=(HashMap)tv.elementAt(i);
				String status="";
				try{
					grandtotal1=Double.parseDouble((String)hmt.get("grandtotal"));
					typeTicketsTotalAmount+=grandtotal1;
					discount=(String)hmt.get("discount");
					if(discount==null) discount="0";
					typeDiscountTotal+=Double.parseDouble(discount);
					ebeefee=Double.parseDouble((String)hmt.get("ebeefee"));
					cardfee=Double.parseDouble((String)hmt.get("cardfee"));
					net=grandtotal1-ebeefee-cardfee;
					typeServiceFeeTotal+=ebeefee;
					typeCCFeeTotal+=cardfee;
					status=(String)hmt.get("payment_status");
					if("Completed".equals(status)||"CHARGED".equals(status)||"A".equals(status)||"Y".equals(status))
					status="Charged";
					else if("CANCELLED".equals(status))
					status="Canceled";
					
				}catch(Exception e){
					net=0.0;
				}
				HashMap TIDTicketHistory = (HashMap)tmap.get((String)hmt.get("transactionid"));
				if(TIDTicketHistory!=null){
					TicketCount=GenUtil.getHMvalue(TIDTicketHistory,"Count");
					Ticketname=GenUtil.getHMvalue(TIDTicketHistory,"DESC");
					type=GenUtil.getHMvalue(TIDTicketHistory,"TYPE");
					TicketPrice=GenUtil.getHMvalue(TIDTicketHistory,"Price");
					discountcode=GenUtil.getHMvalue(TIDTicketHistory,"discountcode");
					if(discountcode==null&&"null".equals(discountcode))
					discountcode="";
				}				
				if(k==0){
					totalnet=net-Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0"));	
				}else{
					net=0;						
					totalnet=(ebeefee+Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0")));	
				}
				typeTotalAmount+=net;
				typeNetTotal+=totalnet;
				colContent.put("Book Date",(String)hmt.get("trandate"));
				if("html".equals(rtype))
				colContent.put("Transaction ID","<a href='/portal/"+URLBase+"/transaction.jsp?key="+(String)hmt.get("transactionid")+"&filter="+filter+"&platform="+platform+"&GROUPID="+groupid+"&groupid="+groupid+"&cardtype="+type+"'>"+(String)hmt.get("transactionid")+"</a>");
				else
				colContent.put("Transaction ID",(String)hmt.get("transactionid"));
				colContent.put("Status",regreports.getDisplayValue(status, xmlEncode));
        			colContent.put("First Name",regreports.getDisplayValue((String)hmt.get("firstname"), xmlEncode));
        			colContent.put("Last Name",regreports.getDisplayValue((String)hmt.get("lastname"), xmlEncode));
				colContent.put("Ticket Name",regreports.getDisplayValue(Ticketname, xmlEncode));
				colContent.put("Ticket Price",CurrencyFormat.getCurrencyFormat("",TicketPrice,true));
				colContent.put("Tickets Count",TicketCount);
				colContent.put("Discount",CurrencyFormat.getCurrencyFormat("",GenUtil.getHMvalue(hmt,"discount","0"),true));
				colContent.put("Discount Code",regreports.getDisplayValue(discountcode, xmlEncode));
				colContent.put("Tickets Total",CurrencyFormat.getCurrencyFormat("",(String)hmt.get("totalamount"),true));
				colContent.put("Service Fee",CurrencyFormat.getCurrencyFormat("",ebeefee+"",true));
				colContent.put("CC Processing Fee",CurrencyFormat.getCurrencyFormat("",cardfee+"",true));
				colContent.put("Net",CurrencyFormat.getCurrencyFormat("",net+"",true));
				colContent.put("NTS Commission",CurrencyFormat.getCurrencyFormat("",GenUtil.getHMvalue(hmt,"agentcommission","0"),true));
        			colContent.put("Total Net",signs[k]+CurrencyFormat.getCurrencyFormat("",totalnet+"",true));
				report.startRow(content,null);
				for(int colindex=0;colindex<displayCols.length;colindex++){
					report.fillColumn(content,regreports.rowdisplay(i)+(String)colStyles.get(displayCols[colindex]),(String)colContent.get(displayCols[colindex]));
				}
				report.endRow(content);
				totalagentcomm=totalagentcomm+Double.parseDouble(GenUtil.getHMvalue(hmt,"agentcommission","0"));
			}
			String displaytotalCommisionval=signs[k]+(CurrencyFormat.getCurrencyFormat(""+currency+"",totalagentcomm+"",true));
			String displaynetsumval=signs[k]+(CurrencyFormat.getCurrencyFormat("$",typeNetTotal+"",true));
			colContent.put("Book Date","Total");
			colContent.put("Transaction ID","");
			colContent.put("Status","");
			colContent.put("First Name","");
			colContent.put("Last Name","");
			colContent.put("Ticket Name","");
			colContent.put("Ticket Price","");
			colContent.put("Tickets Count","");
			colContent.put("Discount",CurrencyFormat.getCurrencyFormat(""+currency+"",typeDiscountTotal+"",true));
			colContent.put("Discount Code","");
			colContent.put("Tickets Total",CurrencyFormat.getCurrencyFormat(""+currency+"",typeTicketsTotalAmount+"",true));
			colContent.put("Service Fee",CurrencyFormat.getCurrencyFormat("$",typeServiceFeeTotal+"",true));
			colContent.put("CC Processing Fee",CurrencyFormat.getCurrencyFormat(""+currency+"",typeCCFeeTotal+"",true));
			colContent.put("Net",CurrencyFormat.getCurrencyFormat(""+currency+"",typeTotalAmount+"",true));
			colContent.put("NTS Commission",displaytotalCommisionval);
			colContent.put("Total Net",displaynetsumval);			
			report.startRow(content,null);
			for(int colindex=0;colindex<displayCols.length;colindex++){
				report.fillColumn(content,boldStyle+(String)colStyles.get(displayCols[colindex]),boldPreAppend+(String)colContent.get(displayCols[colindex])+boldAppend);
			}
			report.endRow(content);				
		}
		grandDiscount+=typeDiscountTotal;
		grandTicketsTotalAmount+=typeTicketsTotalAmount;
		grandServiceFee+=typeServiceFeeTotal;
		grandCCFee+=typeCCFeeTotal;
		grandTotalAmount+=typeTotalAmount;
		grandNetPay+=typeSignFactor[k]*typeNetTotal;
	}
	String grandNetDisplay="";
	if(grandNetPay<0){
		grandNetPay=-(grandNetPay);
		grandNetDisplay="-"+CurrencyFormat.getCurrencyFormat("$",grandNetPay+"",true);
	}
	else
		grandNetDisplay=CurrencyFormat.getCurrencyFormat("$",grandNetPay+"",true);	
	if(transactionsExists){//Write Grand totals
		colContent.put("Book Date","Grand Total");
		colContent.put("Transaction ID","");
		colContent.put("Status","");
		colContent.put("First Name","");
		colContent.put("Last Name","");
		colContent.put("Ticket Name","");
		colContent.put("Ticket Price","");
		colContent.put("Tickets Count","");
		colContent.put("Discount",CurrencyFormat.getCurrencyFormat(""+currency+"",grandDiscount+"",true));
		colContent.put("Discount Code","");
		colContent.put("Tickets Total",CurrencyFormat.getCurrencyFormat(""+currency+"",grandTicketsTotalAmount+"",true));
		colContent.put("Service Fee",CurrencyFormat.getCurrencyFormat("$",grandServiceFee+"",true));
		colContent.put("CC Processing Fee",CurrencyFormat.getCurrencyFormat(""+currency+"",grandCCFee+"",true));
		colContent.put("Net",CurrencyFormat.getCurrencyFormat(""+currency+"",grandTotalAmount+"",true));
		colContent.put("NTS Commission","");
		colContent.put("Total Net",grandNetDisplay);
		report.startRow(content,null);
		for(int colindex=0;colindex<displayCols.length;colindex++){
			report.fillColumn(content,boldStyle+(String)colStyles.get(displayCols[colindex]),boldPreAppend+(String)colContent.get(displayCols[colindex])+boldAppend);
		}
		report.endRow(content);	
		
	}else{
		if(selectedvalue==1){
		report.startRow(content,null);
		report.fillColumn(content,null,"No Paid Registrations on this event");
		report.endRow(content);
		}else{
		report.startRow(content,null);
		report.fillColumn(content,null,"No Paid Registrations matching the Search Filter on this event");
		report.endRow(content);
		}
	}
	report.endTable(content);
	report.endContent(content);
	request.setAttribute("REPORTSCONTENT",content.toString());
	if("html".equals(rtype)){
		request.setAttribute("subtabtype","My Pages");
%>
	<%=content.toString()%>
	
<%	
	}else if("excel".equals(rtype)){
%>
	<jsp:forward page="excelreports.jsp"/>
<%	
	}else{
%>
	<jsp:forward page='/pdfreport1' /> 
<%
	}
%>







