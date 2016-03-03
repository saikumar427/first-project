<%@ page import="com.eventbee.pdfgen.ReportGenerator"%>
<%@ page import="com.customattributes.*,com.eventbee.general.*,com.eventbeepartner.partnernetwork.AttendeeListReports,com.eventbeepartner.partnernetwork.RegistrationReports" %>
<%@ page import="java.util.*,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ include file="filterspecialcharacters.jsp" %>
<%@ include file="allreports.jsp" %>

<%
    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"attendeelist_report.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
    String platform = request.getParameter("platform");    
    String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp";	
    }
    String filter = request.getParameter("filter");    
    String groupid=null;
    String authid=null;
    String role=null;
    String groupname=null;
    String currentdate=null;
    Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");
    if (authData!=null){
	 authid=authData.getUserID();
	 role=authData.getRoleName();
    }else{
       	 authid=(String)session.getAttribute("transactionid");
    }
     groupid=request.getParameter("groupid");
     RegistrationReports regreports=new RegistrationReports();
    HashMap tmap=getTicketInfo(groupid);
    HashMap attendeekeymap=new HashMap();
    String submitbtn=request.getParameter("submit");
    String selindex=request.getParameter("selindex"); 
    String selParam=request.getParameter("FilterTicketID");
   
    groupname=request.getParameter("groupname");    
    java.util.Date date=new java.util.Date();
    String evtname=request.getParameter("evtname"); 
    String sortby=request.getParameter("sortby");
    AttendeeListReports reports=new AttendeeListReports();   
    Vector tv=getAttendeeListInfo(groupid,selindex, selParam,sortby);
    session.setAttribute("attendeelist",tv);
    String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
    String custom_setid=CustomAttributesDB.getAttribSetID(groupid,"EVENT");
  
    
    List list=reports.getAttributes(custom_setid);
    boolean xmlEncode=false;
    HashMap pmap=new HashMap();
    HashMap evtmap=reports.getEventDetails(groupid);
    ArrayList ar=(ArrayList)evtmap.get("address");
    String s="";
    for(int i=0;i<ar.toArray().length;i++){
	if("".equals(s))
	s=s+ar.toArray()[i];
	else
	s=s+", "+ar.toArray()[i];       
    }
    String rtype=request.getParameter("rtype");
    if(rtype==null)rtype="html";
    rtype=rtype.trim();
    ReportGenerator report=ReportGenerator.getReportGenerator(rtype);
    StringBuffer content= new StringBuffer();
    report.startContent(content,"");
    if(!"html".equals(rtype)){  
        report.startTable(content,"text-align='center'","1");
	report.startRow(content,"font-weight='bold' font-size='12pt'  text-align='center'");
	report.fillColumn(content,"border-width='0pt' font-weight='bold'","Attendee List - " +reports.getDisplayValue((String)evtmap.get("eventname"), xmlEncode));
	report.endRow(content);
	report.startRow(content,"font-weight='bold' font-size='12pt'  text-align='center'");
	report.fillColumn(content,"border-width='0pt' font-weight='bold'","When - Starts: "+(String)evtmap.get("startdate")+"  Ends: "+(String)evtmap.get("enddate"));
	report.endRow(content);
	report.startRow(content,"border-width='0pt' font-weight='bold' font-size='12pt'  text-align='center'");
	report.fillColumn(content,"border-width='0pt' font-weight='bold'","Where - "+s);
	report.endRow(content);
        report.startRow(content,"font-weight='bold' font-size='15pt'  text-align='center'");
	report.fillColumn(content,"border-width='0pt' font-weight='bold' ","");
	report.endRow(content);  
	report.endTable(content); 
     }        
     String ColHeaderStyle="class='colheader'";
     String[] displayCols=request.getParameterValues("displayFields");
     int cols=displayCols.length;
     String Style="class='colheader'";
     report.startTable(content,null,cols+"");
     HashMap mainhm=CustomAttributesDB.getResponses(custom_setid);
     EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"registrationlist.jsp","mainhm issssssssssssssss:"+mainhm,"",null);
     HashMap colheaderNames=new HashMap();
     colheaderNames.put("First Name","First Name");
     colheaderNames.put("Last Name","Last Name");
     colheaderNames.put("Email","Email");
     colheaderNames.put("Ticket Name","Ticket Name");
     colheaderNames.put("Phone","Phone");
     colheaderNames.put("Transaction ID","Transaction ID");
     colheaderNames.put("Attendee Key","Attendee Key");
     colheaderNames.put("Payment","Payment");
     for(int k=0;k<list.size();k++){
	colheaderNames.put((String)list.get(k),(String)list.get(k));       	 		
     } 
         HashMap colStyles=new HashMap();
         colStyles.put("Transaction ID"," align='left' ");
	 colStyles.put("First Name"," align='left'");
	 colStyles.put("Last Name"," align='left' ");       
	 colStyles.put("Email"," align='left' ");
	 colStyles.put("Phone"," align='center' ");
	 colStyles.put("Ticket Name"," align='left' ");
	 colStyles.put("Attendee Key"," align='left' ");
	 colStyles.put("Payment"," align='left' ");
	 for(int k=0;k<list.size();k++){
		 colStyles.put((String)list.get(k)," align='left' ");	
	 }
	 String priattendeename="";
	 String priuser="";
	 int j=0;
	 if (tv!=null&&tv.size()>0){
		report.startRow(content,null);
		for(int colindex=0;colindex<displayCols.length;colindex++){
			report.fillColumn(content,ColHeaderStyle,(String)colheaderNames.get(displayCols[colindex]));
		}
		report.endRow(content);
		String path="";
		String transid="";
		String Ticketname="";
		String Ticketid="";
		HashMap colContent=new HashMap();        
		for(int i=0;i<tv.size();i++){
	        HashMap attendeedata=(HashMap)tv.elementAt(i);
	        HashMap TIDTicketHistory = (HashMap)tmap.get((String)attendeedata.get("transactionid"));
		if(TIDTicketHistory!=null){			
			Ticketname=GenUtil.getHMvalue(TIDTicketHistory,"DESC");
		}
		if("4".equals(selindex)){
		  String reqTicketName=request.getParameter("tickettype");
		  
		  /*if(!(reqTicketName.equals(Ticketname))){
		      continue;
		  }*/
		}
		
	        String attendeekey=(String)attendeedata.get("attendeekey");
	         if(!attendeekeymap.containsKey(attendeekey)){
	         attendeekeymap.put(attendeekey,"yes");
	        
	        String priattendee=(String)attendeedata.get("priattendee");	        
	        String payment=CurrencyFormat.getCurrencyFormat("$",(String)attendeedata.get("grandtotal"),true);
	        priattendeename=DbUtil.getVal("select firstname from eventattendee where transactionid=? and priattendee='Y'",new String[]{(String)attendeedata.get("transactionid")});
	        if("N".equals(priattendee)){	        
	        payment=priattendeename;	        
	        }
	        String type=(String)attendeedata.get("transactiontype");	        
	        String phone=(String)attendeedata.get("phone");	        
	        if("null".equals(phone))
	        phone="";
	        if("html".equals(rtype)){	        	
		colContent.put("Transaction ID","<a href='/portal/"+URLBase+"/transaction.jsp?from=attendeereports&key="+(String)attendeedata.get("transactionid")+"&filter="+filter+"&platform="+platform+"&GROUPID="+groupid+"&groupid="+groupid+"&cardtype="+type+"'>"+(String)attendeedata.get("transactionid")+"</a>");
		}else{
		colContent.put("Transaction ID",(String)attendeedata.get("transactionid"));
		}
		colContent.put("Attendee Key",(String)attendeedata.get("attendeekey"));		
	        colContent.put("First Name",GenUtil.AllXMLEncode((String)attendeedata.get("firstname")));
	        colContent.put("Last Name",GenUtil.AllXMLEncode((String)attendeedata.get("lastname")));
	        colContent.put("Ticket Name",regreports.getDisplayValue(Ticketname, xmlEncode));
				
		colContent.put("Email",GenUtil.AllXMLEncode((String)attendeedata.get("email")));
		colContent.put("Phone",GenUtil.AllXMLEncode(phone));	
		if("html".equals(rtype)){	        	
		colContent.put("Payment","<a href='/portal/"+URLBase+"/transaction.jsp?from=attendeereports&key="+(String)attendeedata.get("transactionid")+"&filter="+filter+"&platform="+platform+"&GROUPID="+groupid+"&groupid="+groupid+"&cardtype="+type+"'>"+payment+"</a>");
		}else{
		colContent.put("Payment",payment);
		}
		if(list!=null&&list.size()>0){
		HashMap attribhm=null;
		String tid=(String)attendeedata.get("transactionid");
		if (mainhm!=null && tid!=null)		
			attribhm=(HashMap)mainhm.get(tid);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"registrationlist.jsp","attribhm is:"+attribhm,"",null);
			if(attribhm!=null&&attribhm.size()>0){
				for(int p=0;p<list.size();p++){
					String val=(String)attribhm.get(list.get(p));
					if(val==null)val="";
					if(val.indexOf("##")>0)
						val=val.replaceAll("##",", ");
						val=filterSpecialCharacters(val);
						colContent.put((String)list.get(p),GenUtil.AllXMLEncode(val));
				}
			}
			

			else{
				for(int p=0;p<list.size();p++){
					colContent.put((String)list.get(p),"");
				}
			}
		
		
		}
                report.startRow(content,null);
                /*if("3".equals(selindex) && "html".equals(rtype)){
                	report.fillColumn(content,reports.rowdisplay(i),"<input type='checkbox'  name='tidsToDelete' value='"+attendeedata.get("transactionid")+"' />");
		}*/
		for(int colindex=0;colindex<displayCols.length;colindex++){
			  report.fillColumn(content,reports.rowdisplay(i)+(String)colStyles.get(displayCols[colindex]),(String)colContent.get(displayCols[colindex]));
			  }	
 
		report.endRow(content);	  
		}
}
}else{
	if("2".equals(selindex)){
	report.startRow(content,null);
	report.fillColumn(content,null,"No Attendees matching the Search Filter on this event");
	report.endRow(content);
	}else if("3".equals(selindex)){
	report.startRow(content,null);
	report.fillColumn(content,null,"No Attendees matching the Search Filter on this event");
	report.endRow(content);
	}else{
	report.startRow(content,null);
		report.fillColumn(content,null,"No Attendees for this event");
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
<%}
else if("excel".equals(rtype))
{
%>
<jsp:forward page="excelreports.jsp"/>
<%}
else{
%>
<jsp:forward page='/pdfreport1' /> 
<%}%>

