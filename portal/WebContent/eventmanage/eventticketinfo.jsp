<%@ page import="java.io.IOException,java.util.*, java.text.*, com.eventbee.event.*,com.eventbee.editevent.EditEventDB"%>
<%@ page import="com.eventbee.event.ticketinfo.EventTicketDB, com.eventbee.authentication.*, com.eventbee.general.*, com.eventbee.general.formatting.*, com.eventbee.clubmember.ClubDB"%>

<%  
    String evtname=request.getParameter("evtname");
       String eventid="",unitId="";
    String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
    HashMap newhm=(HashMap)session.getAttribute("groupinfo");
    if (newhm!=null){
           eventid=(String)newhm.get("groupid");
   }
   Authenticate authData=AuthUtil.getAuthData(pageContext);
   if(authData!=null){
	     unitId=authData.getUnitID();
   }
   	ClubDB cdb=new ClubDB();
	boolean clubAllowed=cdb.isValidClubExists(unitId);
	EditEventDB evtDB=new EditEventDB();
	String poweredby=evtDB.getConfig(eventid,EventConstants.POWERED_BY);
	String listatebee=evtDB.getConfig(eventid,EventConstants.SHOW_INSEARCH);
	if("yes".equals(poweredby)){
%>

<div class='memberbeelet-header'>Event Registration</div>

<table  class='portaltable' width="100%" cellspacing="0" cellpadding="0">
<form action="<%=appname%>/mytasks/addtickets.jsp" method="post">
<input type="hidden" name="msg" value="Manage"/>
<input type="hidden" name="evtname" value="<%=evtname%>"/>

<tr>
   <td colspan="4" width="100%">
        <table  width="100%" cellspacing="0" cellpadding="0">
	<tr>
				 <td  width="50%" class="colheader">Tickets</td>
				 <td  width="50%" align='right' class="colheader">
				 <%=PageUtil.writeEventHiddenCore(newhm) %>
	<input type="submit"  name="submit" value="Manage"/></td>
	</tr>
	</table>
     </td>
</tr>
<%
      int colorcount=0,pcount=0,mcount=0,optcount=0,ecount=0;
      int soldqty=0;
      String base="oddbase";
      Vector vpublic=new Vector();
      Vector vmember=new Vector();
      Vector voptional=new Vector();
      Vector veventbee=new Vector();
      EventTicketDB db=new EventTicketDB();
      String query="select * from price where evt_id=?";
      Vector v=db.getTicketInfo(eventid,query);
      if (v!=null){
       for(int i=0;i < v.size();i++){
	  HashMap hm=(HashMap)v.elementAt(i);
          if(hm!=null){
		if("Public".equals((String)hm.get("ticket_type"))){
			vpublic.add(hm);
		}else if("Member".equals((String)hm.get("ticket_type"))){
			vmember.add(hm);
		}else if("Optional".equals((String)hm.get("ticket_type"))){
			voptional.add(hm);
		}else if("Eventbee".equals((String)hm.get("ticket_type"))){
                        veventbee.add(hm);
                }
	   }
	}

     }
 %>
<input type="hidden" name="eventid" value="<%=eventid%>"/>
<input type="hidden" name="F" value="Y"/>
<%
  if (vpublic.size() > 0){
%>
 <tr>
    <td colspan="2" width="100%">
       <table  width="100%" cellspacing="0" cellpadding="5">
	  <tr>
	       <td colspan="2">Required Tickets</td>
	  </tr>
         </table>
     </td>
 </tr>
<%}
int tcount=0;
%>
 <tr>
     <td width="5%"></td>
     <td width="95%">
            <table width="100%" align='center' cellspacing="0" cellpadding="0">
<%
		if (vpublic.size() > 0){
			for (int i=0;i < vpublic.size();i++){
			HashMap hm=(HashMap)vpublic.elementAt(i);
			if(hm!=null){
				if(pcount==0){
%>
		  <tr class="colheader">
		     <td width="40%" class="colheader">Name</td>
		     <td width="20%" class="colheader">Price</td>
		     <td width="20%" class="colheader">Capacity</td>
		     <td width='20%' class="colheader">Sold</td>
			<td class="colheader">Status</td>
		 </tr>
<%	       }
	       pcount++;
		if(pcount%2==0){
			base="evenbase";
		}else{
			base="oddbase";
		}
	String ticketlink=request.getContextPath()+"/editeventprice/editTicketInfo.jsp?F=Y&eventid="+eventid+"&priceid="+(String)hm.get("price_id");
%>
       <tr class="<%=base%>">
    	  <td valign="top" width="20" class="<%=base%>"><%=(String)hm.get("ticket_name")%></td>
    	  <td class="<%=base%>"><%=CurrencyFormat.getCurrencyFormat("$",(String)hm.get("ticket_price"),true)%></td>
    	  <td class="<%=base%>"><%=(String)hm.get("max_ticket")%></td>
	  <td class="<%=base%>">
	<%
	String sold=(String)hm.get("sold");
	if(sold!=null){
		soldqty+=Integer.parseInt(sold);
		out.println((String)hm.get("sold"));
	}else{
		out.println("0");
	}%>
	  </td><td>
<%
if("d".equalsIgnoreCase((String)hm.get("status")))
out.println("Deleted");
else
out.println("Active");
%>
</td></tr>
	  <%}
      }
   }%>

   </table>
   </td></tr>
   <input type="hidden" name="evtname" value="<%=evtname%>"/>
   <input type="hidden" name="eventid" value="<%=eventid%>"/>
   <input type="hidden" name="F" value="Y"/>
   <%
   if(clubAllowed){
	    if(vmember.size()>0){
	    %>
       <tr>
     	  <td colspan="2" width="100%">
	     <table width="100%" align='center' cellspacing="0" cellpadding="5">
	       <tr>
	          <td colspan="3">Member Tickets</td></tr>
		 </table></td>
	       </tr>
	       <tr>
	    	  <td width="5%"></td>
	    	  <td width="95%">
		     <table width="100%">
		     <%
 		 	 for (int i=0;i < vmember.size();i++){
				HashMap hm=(HashMap)vmember.elementAt(i);
			        if(hm!=null){
					if(mcount==0){
				%>
					     <tr class="colheader">
					     <td width="40%" class="colheader">Name</td>
					     <td class="colheader">Price</td>
					     <td class="colheader">Capacity</td>
					     <td class="colheader">Sold</td>
<td class="colheader">Status</td>
					 </tr>
				<%       }
				mcount++;
				if(mcount%2==0){
					base="evenbase";
				}else{
					base="oddbase";
				}
	String ticketlink=appname+"/editeventprice/editTicketInfo?F=Y&amp;eventid="+eventid+"&amp;priceid="+(String)hm.get("price_id");
        %>
	  <tr class="<%=base%>">
    	  <td valign="top" class="<%=base%>" >
	<%=(String)hm.get("ticket_name")%></td>
    	  <td class="<%=base%>"><%=CurrencyFormat.getCurrencyFormat("$",(String)hm.get("ticket_price"),true)%></td>
    	  <td class="<%=base%>"><%=(String)hm.get("max_ticket")%></td>
	  <%
	String sold=(String)hm.get("sold");
	if(sold!=null){
		soldqty+=Integer.parseInt(sold);
		%>
		<td><%=(String)hm.get("sold")%></td>
	<%}else{%>
		<td>0</td>
	<%}%>
<td>
<%
if("d".equalsIgnoreCase((String)hm.get("status")))
out.println("Deleted");
else
out.println("Active");
%>
 </td>
	   </tr>
	<%	}
	   }%>
    </table></td></tr>
       <%}
   }

  if("yes".equalsIgnoreCase(listatebee)){
	    if(veventbee.size()>0){
	    %>
       <tr>
            <td colspan="2" width="100%">
	    	     <table width="100%" cellpadding="5">
	       <tr>
	            <td colspan="3" class='evenbase'>Eventbee Tickets</td></tr></table></td>
	       </tr>
	       <tr>
	    	  <td width="5%"></td>
	    	  <td width="95%">
		  		   <table width="100%" align='center' cellspacing="0" cellpadding="0">
	<%
 		 	 for (int i=0;i < veventbee.size();i++){
				HashMap hm=(HashMap)veventbee.elementAt(i);
			        if(hm!=null){
					if(ecount==0){
					   %>
					  <tr class="colheader">
					     <td width="40%" class="colheader">Name</td>
					     <td class="colheader">Price</td>
					     <td class="colheader">Capacity</td>
					     <td class="colheader">Sold</td>
<td class="colheader">Status</td>
					 </tr>
	<%			       }
				ecount++;
				if(ecount%2==0){
					base="evenbase";
				}else{
					base="oddbase";
				}
	String ticketlink=appname+"/editeventprice/editTicketInfo?F=Y&amp;eventid="+eventid+"&amp;priceid="+(String)hm.get("price_id");
      %>
       <tr>
    	  <td valign="top" class="<%=base%>"><%=(String)hm.get("ticket_name")%></td>
    	  <td class="<%=base%>"><%=CurrencyFormat.getCurrencyFormat("$",(String)hm.get("ticket_price"),true)%></td>
    	  <td class="<%=base%>"><%=(String)hm.get("max_ticket")%></td>
	  <%
	String sold=(String)hm.get("sold");
	if(sold!=null){
		soldqty+=Integer.parseInt(sold);
		%>
		<td><%=(String)hm.get("sold")%></td>
	<%}else{%>
		<td>0</td>
	<%}%>
<td>
<%
if("d".equalsIgnoreCase((String)hm.get("status")))
out.println("Deleted");
else
out.println("Active");
%>
 </td>
	   </tr>
	<%	}
	   }%>
    </table></td></tr>
  <%     }
   }%>
    <input type="hidden" name="evtname" value="<%=evtname%>"/>
   <input type="hidden" name="eventid" value="<%=eventid%>"/>
   <input type="hidden" name="F" value="Y"/>
<%
int evt_level=evtDB.getEventLevel(Integer.parseInt(eventid));
	 if(evt_level > 1){
  	 	if(voptional.size() > 0){
		%>
	<tr>
	         <td colspan="2" width="100%">
		       <table width="100%" cellspacing="0" cellpadding="5">
			  <tr>
			      <td colspan="2" class='evenbase'>Optional Tickets</td>
			  </tr>
		         </table>
		</td>
      </tr>
      <tr>
	  <td ></td>
	   <td >
	    <table width="100%" align='center' cellspacing="0" cellpadding="0">
	    <%
 		   tcount=0;
	   for (int i=0;i < voptional.size();i++){
          HashMap hm=(HashMap)voptional.elementAt(i);
          if(hm!=null){
String ticketlink=appname+"/editeventprice/editTicketInfo?F=Y&amp;eventid="+eventid+"&amp;priceid="+(String)hm.get("price_id");
		if(optcount==0){
		%>
		    <tr class="colheader">
		     <td width="40%" class="colheader">Name</td>
		     <td width="20%" class="colheader">Price</td>
		     <td width="20%" class="colheader">Capacity</td>
		     <td width="20%" class="colheader">Sold</td>
		     <td class="colheader">Status</td>
		 </tr>
		<%}
		optcount++;
		if(optcount%2==0){
			base="evenbase";
		}else{
			base="oddbase";
		}%>
	        <tr class="<%=base%>">
    	  <td valign="top" width="20" class="<%=base%>"><%=(String)hm.get("ticket_name")%></td>
    	  <td class="<%=base%>"><%=CurrencyFormat.getCurrencyFormat("$",(String)hm.get("ticket_price"),true)%>
	  </td>
    	  <td><%=(String)hm.get("max_ticket")%></td>
	  <%
	String sold=(String)hm.get("sold");
	if(sold!=null){
		soldqty+=Integer.parseInt(sold);
		%>
		<td><%=(String)hm.get("sold")%></td>
	<%
	}else{%>
		<td>0</td>
<%	}%>
<td>
<%
if("d".equalsIgnoreCase((String)hm.get("status")))
out.println("Deleted");
else
out.println("Active");
%>
 </td>
	   </tr>
	  <%}
	}%>
	</table></td></tr>
     <%}
         int ticketcount=pcount+mcount;
         if(ticketcount==0){%>
	   <input type="hidden" name="optallowed" value="false"/>
	   <%
	    }else{%>
	     <input type="hidden" name="optallowed" value="true"/>
	   <%  }
	}%>
        </table>

<%
	HashMap hmdesc=evtDB.getTicketDesc(eventid);
	if(hmdesc!=null){
		String editlink=appname+"/editeventprice/editPayType?eventid="+ eventid;
		String svgimglink=appname+"/editeventprice/svgimg_H_B_"+eventid+".gif";
%>

	     </form>
	     <table width="100%" cellspacing="0" cellpadding="0">
	    <form name=form" action="<%=appname%>/mytasks/editPoweredBy.jsp" method="post">
	    <input type="hidden" name="evtname" value="<%=evtname%>"/>
	    <input type="hidden" name="isfirst" value="yes"/>
	    	<tr class="colheader">
		    <td  colspan="4" width="100%">
			    <table width="100%" cellspacing="0" cellpadding="0">
				<tr>
				        <td width="50%" class="colheader">Preferences</td>
					<td align="right" width="50%" class="colheader">
					<%=PageUtil.writeEventHiddenCore(newhm) %>
				    	<input type="submit" name="submit" value="Manage">
					</td>
				</tr>
			     </table>
		    </td></tr>
      <%
      if(!clubAllowed){
      %>
   <tr><td width="100%">
	    </td></tr>
 <%}%>

	 	   <tr>
 		       <td>
			  <%--  <table width="100%">
				<tr>
					<td class="subheader" valign="top">Payment Method</td>
		 		       	<td colspan="3" align="right">
					</td>
				</tr>
				<tr>
		 		<td colspan="4">
			 		    <table width="100%">
					<%
			     if("true".equals(evtDB.getConfig(eventid,EventConstants.PAYMENT_CARD))){
			     %>
				<tr>
		 		<td colspan="2">
 				</td>
				</tr>
				<tr>
				   <td width="5%"></td>
				   <td>Processing fee paid by <%=evtDB.getConfig(eventid,EventConstants.TRANS_FEE_PAYEE)%></td>
			      </tr>
     <%}
     if("true".equals(evtDB.getConfig(eventid,EventConstants.PAYMENT_OTHERS))){%>
				<tr>
		 		       <td colspan="2">
 					   Other
					</td>
				</tr>
				<tr>
				   <td width="5%"></td>
				   <td><%=GenUtil.textToHtml(evtDB.getConfig(eventid,EventConstants.PAYMENT_OTHERS_DESC),true)%></td>
			      </tr>
        <%}
    editlink=appname+"/editeventprice/editBookingType?eventid="+ eventid;
    %>
    </table></td></tr></table></td></tr>

   <tr><td width="100%">
	    <table width='100%'>
		<tr>
		   <td class="subheader" valign="top">Profile Collection</td>
		      <td colspan="2" align="right">

		</td>
		</tr>
	<%
	String booking=(String)hmdesc.get("bookingtype");
	if(booking.equals("no")){
		booking="Single Ticket, collect Attendee profile";
	}else if(booking.equals("bulk")){
		booking="Collect only Primary Attendee profile";
	}else	if(booking.equals("profile")){
		booking="Collect all Attendees profile";
	}%>
	<tr><td colspan="2" ><%=booking%>
	</td></tr>
    </table></td></tr>
   <%
    editlink=appname+"/editeventprice/editDescription?eventid="+ eventid+"&desctype=refund";
    %>
   <tr><td width="100%"> --%>
	    <table width="100%">
		
		<tr>
		     <td colspan="3">
			[Manage Attendee Information Attributes, Payment Method, Customized Name
			for Registration, Refund Policy and Network Ticket selling preferences.]

		   </td>
		</tr>

            </table></td></tr> 

   <%  } %>
    </form>
    </table>
      
   <%  
      }%>



