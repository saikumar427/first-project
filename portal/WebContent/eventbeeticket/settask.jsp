<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.formatting.*,java.util.*"%>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>
<%@ page import="com.eventbeepartner.partnernetwork.NetworkTicketSelling" %>
<%
	 NetworkTicketSelling nts=new NetworkTicketSelling();  
	 java.util.Date date=new java.util.Date();
	 String groupid=request.getParameter("GROUPID");
	 String platform = request.getParameter("platform");
	 if(platform==null) platform="";
	 String URLBase="mytasks";
	 String url="/eventbeeticket/saveAgent";
	    if("ning".equals(platform)){
		URLBase="ningapp";
		url="/ningapp/saveAgent";
	 }
	 String participationtype="";
	 String nts_approvaltype="";
	 String web_editable="Yes";
	 String social_editable="Yes";
	 String web_friendshare="0";
	 int web_webshare=100;
	 int social_webshare=0;
	 String social_friendshare="";
	 HashMap hm=nts.getntsdetails(groupid);
	 if(hm!=null&&hm.size()>0){
	 participationtype =(String)hm.get("participationtype");
	 nts_approvaltype =(String)hm.get("nts_approvaltype");
	 web_friendshare=(String)hm.get("web_friendshare");
	 social_friendshare=(String)hm.get("social_friendshare");
	 web_editable=(String)hm.get("web_editable");
	 social_editable=(String)hm.get("social_editable");
	 try{
		int wshare=Integer.parseInt(web_friendshare);
		web_webshare=100-wshare;
	 }
	 catch(Exception e){
		web_webshare=0;
	 }
	 try{
		int sshare=Integer.parseInt(social_friendshare);
		social_webshare=100-sshare;
	 }
	 catch(Exception e){
		social_webshare=0;
	 }
	 }
	 
	 String evtname=request.getParameter("evtname");
	 if(evtname!=null)
	 evtname=java.net.URLEncoder.encode(evtname);
	 String foroperation="add";
	 String setid=request.getParameter("setid");
	 foroperation=request.getParameter("foroperation");
	 String submit=request.getParameter("Submit");
	 String webcheckboxchecked ="checked";
	 String socialboxchecked ="checked";
	 if("1".equals(participationtype) ){
		webcheckboxchecked="checked";
		socialboxchecked ="";
	 }else if("2".equals(participationtype) ){
		webcheckboxchecked="";
		socialboxchecked ="checked";
	 }
	 String Autoradiobutton ="checked";
	 String Manualradiobutton ="";
	 if("Auto".equals(nts_approvaltype) ){
		Autoradiobutton="checked";
		Manualradiobutton ="";
	 }else if("Manual".equals(nts_approvaltype) ){
		Autoradiobutton="";
		Manualradiobutton ="checked";
	 }
	 String groupidq=null;
	 String isenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=?",new String[]{groupid});
	 String commisstype=DbUtil.getVal("select commtype from group_agent_settings where groupid=?",new String[]{groupid});
	 if("%".equals(commisstype))
		groupidq="select purpose,groupid,salecommission*100 as salescomm,saleslimit,header,description,created_dt,terms_conditions,showagents,settingid,tagline,approvaltype,commtype,enableparticipant from group_agent_settings where groupid=? and purpose='event'";
	 else
		groupidq="select purpose,groupid,salecommission as salescomm,saleslimit,header,description,created_dt,terms_conditions,showagents,settingid,tagline,approvaltype,commtype,enableparticipant from group_agent_settings where groupid=? and purpose='event'";
	 String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
	 HashMap taskmap=new HashMap();
	 HashMap scopemap=(new EventConfigScope()).getEventConfigValues(groupid,"Registration");
	 if(setid==null||"".equals(setid)){
		setid="0";
		foroperation="add";
	 }
	 if(isenabled!=null&&("yes").equals(request.getParameter("isnew"))){
		taskmap.put("eveenable",isenabled);
		foroperation="edit";
		taskmap=F2FEventDB.getCommType(taskmap,groupidq,groupid);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"settask.jsp","null","taskmap is---->  :"+taskmap,null);
		session.setAttribute(setid+"_task_map",taskmap);
	 }
	 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"settask.jsp"," Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	 Vector errorVector=null;
	 if("yes".equals(request.getParameter("error"))){
		//taskmap.put("commtype",request.getParameter("commissiontype"));
		errorVector=(Vector)session.getAttribute("CREATE_TASK_DATA_ERROR_DATA");
	 }
	 else if("add".equals(foroperation)&&("yes").equals(request.getParameter("isnew"))){
		taskmap.put("eveenable","no");
		taskmap.put("showagents","No");
		taskmap.put("approvaltype","Not Required");
		session.setAttribute(setid+"_task_map",taskmap);
	 }
	 request.setAttribute("subtabtype","My Events"); 
	 taskmap=(HashMap)session.getAttribute(setid+"_task_map");
         String display="none";
	 if("Yes".equals(GenUtil.getHMvalue(taskmap,"enableparticipant","")))
		display="block";
%>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy1() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy1() { }
</script>
<script language="JavaScript" type="text/javascript">

function change(id1,id2){
	var i;
 	i= document.getElementById(id1).value;
	var j=(100-i);	
	if(isNaN(j)||j<0||j>100)
        document.getElementById('errordisp').innerHTML='Invalid %. Please enter valid %.';       
	else{
 		document.getElementById('errordisp').innerHTML='';       
 		 document.getElementById(id2).value=j;
	}	
}

function showParticipant(value){
   	if(value=='Yes'){
		document.getElementById('ParticipantEnable').style.display='block';
	}
	else{
		document.getElementById('ParticipantEnable').style.display='none';
	}
	
}

function gettktsellingblock(reload) {
        oneupval+=oneupval;
	/* for adding ticket data collection html to the page*/
	/* id refers to the placeholder*/
	/* id1 refers to the   i.e (displayOptionalTickets_"+i)*/
	/* position refers to the position of the ticket */
	/* tickettype refers to the type of the ticket i.e required/optional*/
	/* url refers to the jsp from which the html/data is to be retrevied*/
	advAJAX.get( {
		url : '/eventbeeticket/ticketselling.jsp?GROUPID=<%=groupid%>&reload='+reload,
		onSuccess : function(obj) {
		document.getElementById('ticksellinggcommission').innerHTML=obj.responseText;
				
		},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
var oneupval=1;
var currentval='0';
var currentAmount='1.0';
var currentcount=0;
var evtid='<%=groupid%>';
var p="";
function editprice(val,price,evtid,purpose){
	p=purpose;
       	if(currentval!='0'){       	      
       	        if(purpose=='comission'){
       	       		document.getElementById('editamount'+currentval).innerHTML='$'+currentAmount;
			document.getElementById('editlink'+currentval).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick="editprice('+currentval+','+currentAmount+','+evtid+','+purpose+')">Edit</span>';
                }                
               else{
			document.getElementById('ticketcount'+currentval).innerHTML=currentcount;
			document.getElementById('editcntlink'+currentval).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick="editprice('+currentval+','+currentAmount+','+evtid+','+purpose+')">Edit</span>';
               }                
	}
	currentval=val;
	currentAmount=price;
	oneupval+=oneupval;
	if(purpose=='comission'){          
		document.getElementById('editlink'+val).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick=makeRequest("/eventbeeticket/ticketselling.jsp?GROUPID=<%=groupid%>&pt=<%=date.getTime()%>"+oneupval,"ticksellinggcommission")>Cancel</span>';
		document.getElementById('editamount'+val).innerHTML=""
		+"<input type='text' name='edittext' id='edittext' size='5' value='"+price+"' />"
		+" &nbsp;<input type='button' name='go'  value='Update' onclick='updatePrice("+val+","+evtid+")'>";
	}	
	else{	 
		document.getElementById('editcntlink'+val).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick=makeRequest("/eventbeeticket/ticketselling.jsp?GROUPID=<%=groupid%>&pt=<%=date.getTime()%>"+oneupval,"ticksellinggcommission")>Cancel</span>';
		document.getElementById('ticketcount'+val).innerHTML=""
		+"<input type='text' name='edittext' id='edittext' size='5' value='"+price+"' />"
		+" &nbsp;<input type='button' name='go'  value='Update' onclick='updatePrice("+val+","+evtid+")'>";
	}
}

function updatePrice(val,evtid){
	currentval='0';
	var myprice=document.getElementById("edittext").value;
	advAJAX.get( {
		url : '/portal/eventbeeticket/updatecommission.jsp?GROUPID='+evtid+'&price='+myprice+'&val='+val+'&purpose='+p,
		onSuccess : function(obj) {
			var data=obj.responseText;	    		
			if(data.indexOf("Success")>-1){
				finalupdate("/eventbeeticket/ticketselling.jsp?from=update&GROUPID="+evtid);
			}else{
 				 document.getElementById('commerror1').innerHTML=data;
 			}
		},
	onError : function(obj) { alert("Error: " + obj.status);}
	});            
}


function finalupdate(url){
	advAJAX.get( {
		url : url,
	    	onSuccess : function(obj) {
	    		var data=obj.responseText;
	    		document.getElementById('ticksellinggcommission').innerHTML=data;
		},
		onError : function(obj) { alert("Error: " + obj.status);}
	});            
}
	
	
function  validate(){
   var web_webshare;
   web_webshare= document.getElementById("web_webshare").value;   
   if(web_webshare<0||web_webshare>100||isNaN(web_webshare)){   
    return false;
   }
   if(web_webshare.indexOf(".")!=-1){
   alert('Invalid %. Please enter valid %.');
   return false;
   }
   var social_webshare;
   social_webshare= document.getElementById("social_webshare").value;   
   if(social_webshare<0||social_webshare>100||isNaN(social_webshare)){   
       return false;
   }
   if(social_webshare.indexOf(".")!=-1){
   	alert('Invalid %. Please enter valid %.');
   	return false;
   }
   options=document.settask1.ptype;
   var value=0;
   var count=0;
   for(i=0;i<options.length;i++){
      	if(options[i].checked){
   		value=options[i].value;
   		count++;
   	}
   }
   if(value==0){
   	alert('Select Participation option');
  	 return false;
   }
   if(count>1){
   	value=3;   	
   }
   document.settask1.participationtype.value=value;
   return true;
   }

</script>


<table class="block" cellspacing="0" cellpadding='0' width='100%'>
<form  name="settask1" action="<%=url%>" method="post" onsubmit="return validate();">
<input type='hidden' name='evtname' value='<%=evtname%>'/>
<input type='hidden' name='platform' value='<%=platform%>'/>
<input type='hidden' name='salecommission' value='0' />
<input type='hidden' name='participationtype' value='0' />
<tr><td>
<table class="block" cellspacing="0" cellpadding='0' width='100%'>
<input type='hidden' name='foroperation' value='<%=foroperation%>'/>
<input type='hidden' name='setid' value='<%=setid%>'/>
<input type='hidden' name='GROUPID' value='<%=groupid%>'/>
<tr><td colspan="2" height="5"></td></tr>
<tr><td colspan="2">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<%=GenUtil.displayErrMsgs("<tr><td class='error'>",errorVector,"</td></tr>")%>
</table>
</td></tr>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<%if ("Enable".equals(request.getParameter("Submit")))%>
<input type="hidden" name="eveenable" value='Yes'/>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<tr>
<td colspan="3">
<div id="ticksellinggcommission"></div></td></tr>
<%if("yes".equals(request.getParameter("error"))){%>
<script>gettktsellingblock('error');</script>
<%}else{%>
<script>gettktsellingblock('new');</script>
<%
}
%>
<tr>
<td class="inputlabel" width="45%" height="30">
Network Ticket Selling Enable Options [<a href="javascript:popupwindow('<%=linkpath%>/ntsoptions.html','Tags','600','400')">?</a>]</td>
<td class="inputlabel" width="55%" height="30">
<input type='checkbox' name='ptype' value=1 <%=webcheckboxchecked%>>&nbsp;Web &nbsp;&nbsp; 
</td></tr>
<tr><td id='errordisp' class='error'></td><td class="inputlabel" width="55%" height="30">
Commission Settings: Partner <input type='text' id='web_webshare' name='web_webshare' value="<%=web_webshare%>" size='2' onkeyup="change('web_webshare','web_friendshare')"> %
Attendee <input type='text'  id='web_friendshare' name='web_friendshare' value='<%=web_friendshare%>' size='2' readonly > %
</td></tr>
<tr><td></td><td class="inputlabel" width="55%" height="30">
Allow Partner to Edit Commission Settings:
<input type='radio' name='web_editable' value='Yes' <%=("Yes".equals(web_editable))?"checked='checked'":""%> >&nbsp;Yes 
<input type='radio' name='web_editable' value='No' <%=("No".equals(web_editable))?"checked='checked'":""%> >&nbsp;No
</td></tr>
<tr><td></td><td class="inputlabel" width="55%" height="30">
<input type='checkbox' name='ptype' value=2 <%=socialboxchecked%>>&nbsp; Social
</td></tr>
<tr><td></td><td class="inputlabel" width="55%" height="30">
Commission Settings: Partner <input type='text' id='social_webshare' name='social_webshare' value='<%=social_webshare%>' size='2'  onkeyup="change('social_webshare','social_friendshare')"> %
Attendee <input type='text' id='social_friendshare' name='social_friendshare' value='<%=social_friendshare%>' size='2' readonly> %
</td></tr>
<tr><td></td><td class="inputlabel" width="55%" height="30">
Allow Partner to Edit Commission Settings:
<input type='radio' name='social_editable' value='Yes' <%=("Yes".equals(social_editable))?"checked='checked'":""%>>&nbsp;Yes 
<input type='radio' name='social_editable' value='No' <%=("No".equals(social_editable))?"checked='checked'":""%>>&nbsp;No
</td></tr>
<tr>
<td class="inputlabel" width="45%" height="30">
Network Ticket Selling Partner Approval [<a href="javascript:popupwindow('<%=linkpath%>/ntsapproval.html','Tags','600','400')">?</a>]
</td>
<td class="inputlabel" width="45%" height="30">
<input type='radio' name='nts_approvaltype' value='Auto' <%=Autoradiobutton%> >&nbsp;Auto &nbsp;&nbsp;
<input type='radio' name='nts_approvaltype' value='Manual' <%=Manualradiobutton%>>&nbsp;Manual
</td></tr>
<%--<tr>
<td class="inputlabel" width="45%" height="30">Network Ticket Selling Sales Limit [<a href="javascript:popupwindow('<%=linkpath%>/ntslimit.html','Tags','600','400')">?</a>] </td>
<td class="inputvalue" ><%=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$")%> <input type='text' name='saleslimit' size='5' value="<%=GenUtil.getHMvalue(taskmap,"saleslimit","5000",true)%>" /></td>
</tr>
 <tr>
<td class="inputlabel" valign="middle" >Enable Participant Event Page Creation [<a href="javascript:popupwindow('<%=linkpath%>/ntspage.html','Tags','600','400')">?</a>] </td>
<td valign='top'><input type="radio" name='enableparticipant' value="Yes" onClick="showParticipant('Yes');" <%=WriteSelectHTML.isRadioChecked("Yes",GenUtil.getHMvalue(taskmap,"enableparticipant","Yes"))%> />Yes
<input type='radio' name='enableparticipant'  value="No"   onClick="showParticipant('No');"<%=WriteSelectHTML.isRadioChecked("No",GenUtil.getHMvalue(taskmap,"enableparticipant","No")) %> />No</td>
</tr>--%>
</table></td></tr>
<tr><td>
<div id='ParticipantEnable' style='display:<%=display%>'>
<table  cellspacing="0" cellpadding='6'> 
<tr >
<td></td><td class="inputlabel" width="50%" >Tag Line*</td>
<td class="inputvalue" > <input type='text' name='tagline' size="80" value="<%=GenUtil.getHMvalue(taskmap,"tagline","",true)%>" /></br>
<font class='smallestfont'>(Displayed on Main Event Page to attract Participants)</font></td>
</tr>
<tr >
<td></td><td class="inputlabel" valign='top' >Description* <br/><font class='smallestfont'>(Few words on why anyone should become Participant)</font></td>
<td class="inputvalue">
<textarea name="description"  rows='15' cols='60' ><%=GenUtil.getHMvalue(taskmap,"description","",true)%></textarea></td>
</tr></table>
<table  cellspacing="0" cellpadding='0'> 
<tr>
<td class="inputlabel" valign='top' width="50%">Show Participants on Main Event Page</td>
<td class="inputvalue">
<input type="radio" name='showagents' value="Yes"  <%=WriteSelectHTML.isRadioChecked("Yes",GenUtil.getHMvalue(taskmap,"showagents","No"))%>  />Yes,  header: <input type='text' name='header' ='true' size="42" value="<%=GenUtil.getHMvalue(taskmap,"header","",true)%>"  /><br/>
<font class='smallestfont'>(e.g.: Top Fundraisers, Top Sellers)</font><br/>
<input type='radio' name='showagents'  value="No" <%=WriteSelectHTML.isRadioChecked("No",GenUtil.getHMvalue(taskmap,"showagents","No"))%> />No</td>
</tr>
<tr>
<td class="inputlabel"  valign='top' width="50%">Participation Terms and Conditions* </td>
<td class="inputvalue"><textarea name="terms_conditions"  rows='15' cols='60' ><%=GenUtil.getHMvalue(taskmap,"terms_conditions","",true)%></textarea></td>
</td>
</tr>
</table></div>
</td></tr>
<tr><td>
<table>
<input type='hidden' name='taskid' value='0'/>
<% if ("edit".equals(request.getParameter("foroperation"))){}else{%>
<!--<tr>
<td colspan="2" align="center" class="inputvalue">
<%--<input type="checkbox" name="service" value="yes"/> --%>By clicking Submit, I accept Eventbee Network Ticket Selling <a href="javascript:popupwindow('<%=linkpath%>/eventbeeticketterms.html','Tags','600','400')"> Terms and Conditions</a></td>
</tr>--><%}%>
</table></td></tr><tr><td>
<center><input type='submit' value="Submit" name="submit"/><input type='button' name='cancel' value='Cancel' onclick="javascript:window.history.back()" />
</form></table>

