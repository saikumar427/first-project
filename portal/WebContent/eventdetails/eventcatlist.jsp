<%
	String evttype=request.getParameter("evttype");
	String category=request.getParameter("category");
	String location=request.getParameter("location");
	String country=request.getParameter("country");
	String keyword=request.getParameter("keyword");
	request.setAttribute("tabtype",evttype);
	request.setAttribute("subtabtype",evttype);
//	request.setAttribute("layout", "DEFAULT");

%>

<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy() {}
</script>

<script>
function getInvite(){

	
	advAJAX.get( {
		url : "/portal/eventdetails/InviteEventList.jsp",
		onSuccess : function(obj) {
			
		document.getElementById('InviteforEvents').innerHTML=obj.responseText;
		document.getElementById('invitelink').style.display='none';
	
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});


}


function CancelInvite()
{
	document.getElementById("InviteforEvents").innerHTML = '';
	document.getElementById("invitelink").style.display='block';

}
</script>

<script>

function emailsubmit(){

	
		if (!document.inviteevt.fromemail.value) {
			
			alert('Please enter email address in From.');
			document.inviteevt.fromemail.focus();
			return false;
		}
		
			
		if (!document.inviteevt.toemail.value) {
		    alert('Please enter a valid email address in the To: field.');
		    document.inviteevt.toemail.focus();
			return false;
		}
				
			
		if (!document.inviteevt.subject.value) {
			alert('Please enter a subject for your message.');
			return false;
		}
		
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.inviteevt.fromemail.value)){
			alert('Your email address is not valid.');
			return false;
		}
		

		  var toemail=document.inviteevt.toemail.value;
		
			var tokens = toemail.tokenize(",", " ", true);
				

		for(var i=0; i<tokens.length; i++){
		   //alert(tokens[i]);
		  
			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
			  
				alert(tokens[i] + ' is not a valid email address.');
				return false;
			}
		}
	
	advAJAX.submit(document.getElementById('inviteevt'),{
    onSuccess : function(obj) {
    document.getElementById('InviteforEvents').innerHTML=obj.responseText;
	document.getElementById("invitelink").style.display='block';
	},
    onError : function(obj) { alert("Error: " + obj.status);}    

});

}
</script>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;       
   
    item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("eventscommunity");
	item.setResource("/eventdetails/eventslist.jsp?evttype="+evttype+"&location="+location+"&keyword="+request.getParameter("keyword"));
	leftItems.add(item);
	
	
	
   
   	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("premiumevents");
	item.setResource("/eventdetails/premiumevents.jsp");
	leftItems.add(item);
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=AD1_"+evttype.toUpperCase()+"_MAIN&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet1D");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C1D&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet1E");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C1E&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	
	

	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("listevent");
	item.setResource("/eventdetails/listevent.jsp?evttype="+evttype);
	rightItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ManagerInvite");
	item.setResource("/eventdetails/Invitemanager.jsp?evttype="+evttype);
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=AD_"+evttype.toUpperCase()+"_MAIN&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("gcontentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=G_AD_"+evttype.toUpperCase()+"_MAIN&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("tags");
	item.setResource("/eventdetails/eventtags.jsp");
	rightItems.add(item);
	
	
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet2D");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C2D&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet2E");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C2E&forgroup=13579&customborder=portalback");
	rightItems.add(item);


	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

