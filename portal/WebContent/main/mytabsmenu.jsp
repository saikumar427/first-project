<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures,com.eventbee.listmanagement.*" %>

<%!
String getSelectedMenu(String rmik, String tab){
String ret="";
if(rmik !=null){
ret=rmik.equals(tab)?"id='ebeemenuhighlightlink'":ret;
}
return ret;
}


%>

<%

String listid=request.getParameter("listid");
if(listid==null)
listid=(String)session.getAttribute("listid");
String listname=request.getParameter("listname");

%>


<%

String tabtype=(String)request.getAttribute("stype");
									

String tabclass="desitabcont mytab2";
String ntype=(String)request.getParameter("ntype");
String linktohighlight=(String)request.getAttribute("linktohighlight");

Authenticate authData_auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String loggusername=(authData_auth !=null)?authData_auth.getLoginName():"";
boolean displaymypreviewlink=(authData_auth !=null)?true:false;
String type=request.getParameter("type");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"eventsunmenu.jsp",null,"type vlaue is------"+type,null);

com.eventbee.myaccount.MyAccount myacct=null;
if(authData_auth!=null){
 myacct=(com.eventbee.myaccount.MyAccount)authData_auth.UserInfo.get("MyAccount");
}

boolean displaypagetemplate=false;
if(myacct !=null){
	displaypagetemplate=myacct.displayPageTemplate();
}

String [] mymenutabs={};
String [] mymenutabnames={};
String [] mymenutablinks={};

String [] mysubmenus={};
String [] mysubmenulinks={};
boolean  showPreviewLink=false;
String PreviewText="";
String PreviewURL="";
String PreviewWindowTitle="";
String mtype=(String)request.getAttribute("mtype");
String stype=(String)request.getAttribute("stype");
String ltype=(String)request.getAttribute("ltype");
String showtabs=(String)request.getAttribute("showtabs");
String GROUPID=request.getParameter("GROUPID");
if("My Console".equalsIgnoreCase(mtype)){

mymenutabs=new String[]{"Events","Community","Photos","Network"};
	
	
	
	
	/*
	mymenutabs=new String[]{"Events","Community","Blog","Photos","Network"};
	
	mymenutabnames=new String[]{"My Events","My Communities","My Blog","My Photos","My Network"};
	mymenutablinks=new String[]{"/portal/mytasks/myevents.jsp",
				"/portal/mytasks/myhubs.jsp",
				"/eroller/rollerlogin.jsp?act=eweblogCreate",
				"/mytasks/myphotos.jsp",
				"/portal/mytasks/Network.jsp"
				};
				*/
	mymenutabnames=new String[]{"My Events","My Communities","My Photos","My Network"};			
	mymenutablinks=new String[]{"/portal/mytasks/myevents.jsp",
				"/portal/mytasks/myhubs.jsp",
				"/mytasks/myphotos.jsp",
				"/portal/mytasks/Network.jsp"
				};			
	showPreviewLink=true;
	if("Photos".equalsIgnoreCase(stype)){
		mysubmenus=new String[]{"Manage Photos","Upload Photos","Create Album","Manage Albums"};
		mysubmenulinks=new String[]{"/portal/mytasks/myphotos.jsp?type=Photos",
									"/portal/mytasks/uploadphotos.jsp?type=Photos&isnew=yes",
									"/portal/mytasks/createalbums.jsp?type=Photos&albumid=0&isnew=yes",
									"/portal/mytasks/memberAlbums.jsp?type=Photos"};
									
	}else if("Network".equalsIgnoreCase(stype)){
		mysubmenus=new String[]{"Friends","Messages","Guest Book","Search"};
		mysubmenulinks=new String[]{"/portal/mytasks/Network.jsp?type=Friends",
									"/portal/mytasks/allMessages.jsp?type=Messages",
									"/portal/mytasks/GBookManage.jsp?type=GuestBook",
									"/portal/mytasks/memberfilter.jsp?type=Network"};
									
	}

}



else if("My Settings".equalsIgnoreCase(mtype )  ){
 mymenutabs=new String[]{"Account","Alerts"};
 mymenutabnames=new String[]{"Account","Alerts"};
 mymenutablinks=new String[]{"/mytasks/mysettings.jsp?isnew=yes",   "/mytasks/alert.jsp" };

}

else if("My Email Marketing".equalsIgnoreCase(mtype)){
if("show".equals(showtabs)){
mymenutabs=new String[]{"Members","Add Members","List Info"};
mymenutabnames=new String[]{"Members","Add Members","List Info"};
mymenutablinks=new String[]{ "/portal/mytasks/listmembers.jsp?listid="+listid,
 	   						 "/portal/mytasks/listaddmembers.jsp?listid="+listid,
 	   						 "/portal/mytasks/ListEditScreen.jsp?listid="+listid };
 	   						 
 	 	   				 
	
		 if("Add Members".equalsIgnoreCase(stype)){
		
		mysubmenus=new String[]{"Manual","File Upload"};
		mysubmenulinks=new String[]{"/portal/mytasks/listaddmembers.jsp?ntype=Manual&listid="+listid,
									"/portal/mytasks/listaddmembers.jsp?ntype=Upload&listid="+listid};
	}	    
		


}

}

else if("Network Ticket Selling".equalsIgnoreCase(mtype )  ){
 mymenutabs=new String[]{"My Network Ticket Selling","My Network Event Listing","My Earnings"};
 mymenutabnames=new String[]{"My Network Ticket Selling ","My Network Event Listing","My Earnings"};
 mymenutablinks=new String[]{"/mytasks/networkticketsellingpage.jsp","/mytasks/networkeventlistingpage.jsp","/mytasks/myearningspage.jsp"};

}


else if("Transaction Management".equalsIgnoreCase(mtype )  ){
 mymenutabs=new String[]{"Google Transactions","PayPal Transactions","Eventbee Transactions"};
 mymenutabnames=new String[]{"Google Transactions ","PayPal Transactions","Eventbee Transactions"};
 mymenutablinks=new String[]{"/mytasks/transactionmanagement.jsp?type=google&status=v&GROUPID="+GROUPID,"/mytasks/transactionmanagement.jsp?type=paypal&status=v&GROUPID="+GROUPID,"/mytasks/transactionmanagement.jsp?type=eventbee&status=v&GROUPID="+GROUPID};

}


%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script>

function showmembermenulist(listid,status) {
advAJAX.get( {
	
	url : "/portal/listmgmt/membersubmenu.jsp?"+"listid="+listid+"&status="+status,
	onSuccess : function(obj) {
	document.getElementById('ebeemenu').style.display='none';
	document.getElementById('gap').innerHTML='';
	document.getElementById('updatemembers').innerHTML=obj.responseText;
	
	},
	onError : function(obj) { alert("Error: " + obj.status); }
});
}

</script>
<%if("Members".equalsIgnoreCase(stype)){%>
<script>
showmembermenulist('<%=listid%>','<%=linktohighlight%>');
</script>
<%}%>



<table height='10'><tr><td></td></tr></table>

<%
if(mymenutabs.length>0){

if(tabtype==null||"null".equals(tabtype))
tabtype=mymenutabs[0];

%>
<table width='100%'  cellspacing="0" cellpadding="0"  >
<tr>
 <td   align='left'  >
<%
	for(int i=0;i<mymenutabs.length;i++){
	    if(tabtype.equals(mymenutabs[i]))
		tabclass="desitabcont mytab1";
		else
		tabclass="desitabcont mytab2";
	
%>
	
	<span class="<%=tabclass %>" ><a href="<%=mymenutablinks[i]%>"><%=mymenutabnames[i] %></a></span>
<%
	}//end for
%>
					
<%

if(showPreviewLink){
%>

<span style="float:right;padding-top:0px"  >
<font class='smallestfont'><a
href="javascript:popupwindow('<%=PreviewURL%>','<%=PreviewWindowTitle%>','850','500');">
<%=PreviewText%></a></font>

</span>
<%}
%>
</td></tr>
<tr class='tabhighlightcolor' id='ebeemenu'>
<td   height="20" align='left' id='linkstd'>
<%
	for(int i=0;i<mysubmenus.length;i++){
	
%>
	
	<span  <%=getSelectedMenu(mysubmenus[i],ltype) %>>	
	<a href='<%=mysubmenulinks[i]%>'><%=mysubmenus[i]%></a><%if(i<mysubmenus.length-1){%>&nbsp;|&nbsp;<%}%>
	</span>
<%
	}//end for
%>
</td>	
</tr>
<div id="gap" height='10'></div>
<tr><td id='updatemembers'></td></tr>
</table>
<%}%>





