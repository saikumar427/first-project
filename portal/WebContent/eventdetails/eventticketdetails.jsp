<%@ page import="java.io.IOException,java.util.*, java.text.*, com.eventbee.event.*,com.eventbee.editevent.EditEventDB"%>
<%@ page import="com.eventbee.event.BeeletController,com.eventbee.event.ticketinfo.EventTicketDB, com.eventbee.authentication.*, com.eventbee.general.*, com.eventbee.general.formatting.*, com.eventbee.clubmember.ClubDB"%>

<%
    	HashMap hm=(HashMap)session.getAttribute("groupinfo");
        String fromcontext=(String)session.getAttribute("entryunitid");
	boolean ebeecontext=("13579".equals(fromcontext));
        Vector vm_pub=new Vector();
        Vector vm_mem=new Vector();
        Vector vm_evt=new Vector();
        Vector vm_opt=new Vector();
        Vector v=null; 
        int size=0;
        int k=0;
        String base="oddbase";
	String groupid=(String)hm.get("groupid");
	//BeeletController bc=(BeeletController)hm.get("beeletcontroller");
      //  List L=bc.getEnabledBeeletsList();
	//boolean isbeeletdisplay=L.contains(bc.TICKET);
	boolean isbeeletdisplay=true;
        EditEventDB evtDB=new EditEventDB();
        boolean eventpowerby=("Yes".equals(evtDB.getConfig(groupid,EventConstants.EVENT_POWEREDBY)));
	EventConfigScope evt_scope=new EventConfigScope();
   HashMap scopemap=evt_scope.getEventConfigValues(groupid,"Registration");
   String currformat=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$");
         if (isbeeletdisplay){
        	v=EventTicketDB.getAllActiveTicketInfo(groupid);
        if ((v!=null) && (v.size()>0)){
              for(int i=0;i<v.size();i++){
                    HashMap mp=(HashMap)v.elementAt(i);
               if ("Public".equals((String)mp.get("tickettype")))
                        vm_pub.addElement(mp);
	       else if("Member".equals((String)mp.get("tickettype")))
               	        vm_mem.addElement(mp);
 	       //else if("Eventbee".equals((String)mp.get("tickettype")) && ((ebeecontext)||(eventpowerby)))
	       else if((ebeecontext)||(eventpowerby))
                        vm_evt.addElement(mp);
               else	
	       		vm_opt.addElement(mp);
            }
             if (ebeecontext || eventpowerby)
                  size=vm_pub.size()+vm_mem.size()+vm_evt.size();
              else
                  size=vm_pub.size()+vm_mem.size();
             }
 %>
<%
%>
 
 <div class='memberbeelet-header'>Ticket Information</div>
 
 <table class="portaltable" align="center" width="100%" cellspacing='0' cellpadding='0'>
 <tr>
      <td width="100%">
 <%
            if(size==0){
 %>
			<table class="center"  width="100%">
			<tr>
				<td class="inform"  align="center">No Tickets</td>
			</tr>
			</table>
<%		}else{
%>
       <table align="center" width="100%">
       <tr>
	     	<td colspan="3" align="right">
					<a href="javascript:popupwindow('/portal/printdetails/ticketinfo.jsp?groupid=<%=groupid%>','Print','400','400')">
					<img src="<%=EbeeConstantsF.get("resources.image.webpath","http://localhost:8080/home/images/")%>printer.gif" border="0"/>
					</a>
					<a href="javascript:popupwindow('/portal/printdetails/ticketinfo.jsp?groupid=<%=groupid%>','Print','400','400')">
						Printable version
					</a>
		</td>
 	 </tr>
        <tr class="colheader">
			<td width="40%">Name</td>
			<td  width="50%">Description</td>
			<td width="10%">Price
				(<%=currformat%>)
		</td>
        </tr>
 <%              if(vm_pub.size()>0){
                        for(int pubtic=0;pubtic<vm_pub.size();pubtic++){
				HashMap ticket=(HashMap)vm_pub.elementAt(pubtic);
				if(k%2==0){
					base="oddbase";
				}else{
					base="evenbase";
				}
				k++;
%>
       <tr class='<%=base%>'>
		<td>
			<%=(String)ticket.get("ticketname")%><br/><%=(String)ticket.get("start_date")+" - "+(String)ticket.get("end_date")%>
		</td>
		<td>
			<%=(String)ticket.get("description")%>
		</td>
		<td>
			<%=CurrencyFormat.getCurrencyFormat(currformat,(String)ticket.get("price"),false)%>
		</td>
      </tr>
 <%   	}
   }
        if(vm_mem.size()>0){
     	for(int memtic=0;memtic<vm_mem.size();memtic++){
		  HashMap memticket=(HashMap)vm_mem.elementAt(memtic);
				if(k%2==0){
					base="oddbase";
				}else{
					base="evenbase";
				}
				k++;
%>
	<tr class='<%=base%>'>
		<td>
		<%=(String)memticket.get("ticketname")%><br/><%=(String)memticket.get("start_date")+" - "+(String)memticket.get("end_date")%>
		</td>
		<td>
			<%=(String)memticket.get("description")%>
		</td>
		<td>
			<%=CurrencyFormat.getCurrencyFormat(currformat,(String)memticket.get("price"),false)%>
		</td>
 	 </tr>
<%   		}
       }

       if(vm_evt.size()>0){
   	for(int evttic=0;evttic<vm_evt.size();evttic++){
		  HashMap evtticket=(HashMap)vm_evt.elementAt(evttic);
				if(k%2==0){
					base="oddbase";
				}else{
					base="evenbase";
				}
				k++;
%>
	<tr class='<%=base%>'>
		<td>
			<%=(String)evtticket.get("ticketname")%><br/><%=(String)evtticket.get("start_date")+" - "+(String)evtticket.get("end_date")%>
		</td>
		<td>
			<%=(String)evtticket.get("description")%>
		</td>
		<td>
			<%=CurrencyFormat.getCurrencyFormat(currformat,(String)evtticket.get("price"),false)%>
		</td>
      	</tr>
<%      }
	}

	if(vm_opt.size()>0){
   	for(int opttic=0;opttic<vm_opt.size();opttic++){
		  HashMap optticket=(HashMap)vm_opt.elementAt(opttic);
				if(k%2==0){
					base="oddbase";
				}else{
					base="evenbase";
				}
				k++;
%>
	<tr class='<%=base%>'>
		<td>
			<%=(String)optticket.get("ticketname")%> (Optional)<br/><%=(String)optticket.get("start_date")+" - "+(String)optticket.get("end_date")%>
		</td>
		<td>
			<%=(String)optticket.get("description")%>
		</td>
		<td>
			<%=CurrencyFormat.getCurrencyFormat(currformat,(String)optticket.get("price"),false)%>
		</td>
      	</tr>
<%  }
 }%>

   </table>
   <%}%>
      </td>
   </tr>
</table>
   <%
}
%>


