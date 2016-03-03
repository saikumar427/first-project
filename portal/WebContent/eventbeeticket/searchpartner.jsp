<%@ include file="/../plaxo_js.jsp" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%java.util.Date date=new java.util.Date();%>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String platform = request.getParameter("platform");
if(platform==null) platform="";
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp/ticketing";	
    }

%>

<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>
var evtid=<%=groupid%>
var txtval='';
var searchtype="";
function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}
function changestatus(partnerid,eventid,status){

var urlstr='/portal/eventbeeticket/changentesstatus.jsp?eventid='+eventid+'&partnerid='+partnerid+'&status='+status;

advAJAX.get( {
	url : urlstr,
	onSuccess : function(obj) {
	var data=obj.responseText;
	
	document.getElementById('partnerstatus_'+partnerid).innerHTML=data;
	
	
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}
function partnersearch(evtid,stype,platform){
if('pid' == stype){
 txtval=document.psearchform.pid.value; 
 //alert(txtval);
 } 
if('pBeeid' == stype){
	 txtval=document.psearchform.pBeeid.value; 
	 //alert(txtval);
	 } 
 if('pname' == stype){
 txtval=document.psearchform.pname.value; 	
 }
 if('pemail' == stype){
 txtval=document.psearchform.pemail.value; 		
 }
 if('Approved' == stype){
  txtval=evtid; 		
 }
 if('Pending' == stype){
   txtval=evtid; 		
 }
 if('Suspended' == stype){
   txtval=evtid; 		
 }
 searchtype=stype;

document.getElementById('partnerdetails').innerHTML='Loading .... Please wait';

	advAJAX.get( {
		url : '/portal/eventbeeticket/partner_commision_details.jsp?groupid='+evtid+'&stype='+stype+'&sby='+txtval+'&platform='+platform,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);
		if(data.indexOf("No Records")>-1)
		{	
			if('pid' == stype){
			document.getElementById('partnerdetails').innerHTML='<font color="red">No Partner found with this ID.</font>';
		    }
			if('pBeeid' == stype){
				document.getElementById('partnerdetails').innerHTML='<font color="red">No Partner found with this Bee ID.</font>';
			    }
			if('pname' == stype){		
				document.getElementById('partnerdetails').innerHTML='<font color="red">No Partner found with this Name.</font>';
			}
			if('pemail' == stype){		
				document.getElementById('partnerdetails').innerHTML='<font color="red">No Partner found with this Email ID.</font>';
			}
			if('Approved' == stype){		
				document.getElementById('partnerdetails').innerHTML='<font color="red">No approved Partners for this event.</font>';
			}
			if('Pending' == stype){		
				document.getElementById('partnerdetails').innerHTML='<font color="red">No Pending Partners for this event.</font>';
			}
			if('Suspended' == stype){		
				document.getElementById('partnerdetails').innerHTML='<font color="red">No Suspended Partners for this event.</font>';
			}
		}
		else
			document.getElementById('partnerdetails').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}


</script>




<script type="text/javascript" >
var currentval='0';
var currentAmount='0';
var oneupval=1;
var currentcount=0;
var editpurpose=''
var newprice=0;
var comission;
function getAmount(amount){
	if(amount.indexOf(".",0)>-1){
		var l=amount.length-1;
		var k=amount.indexOf(".",0);
		if((l-k)==1){
		  	amount=amount+"0";
		}
	}else{
		amount=amount+".00";
	}
	
	return amount;
}	




function editprice(val,price,priceid,partnerid,purpose,ext){
if(purpose=='comission'){
if(price.indexOf(".",0)>-1){
		var l=price.length-1;
		var k=price.indexOf(".",0);
		if((l-k)==1){
		  	price=price+"0";
		}
	}else{
		price=price+".00";
	}
	
	}
	
editpurpose=purpose;
newprice=price;
document.getElementById("purpose").value=purpose;
document.getElementById("priceid").value=priceid;
document.getElementById("partnerid").value=partnerid;


if(currentval!='0'){	
/*
 if(purpose=='comission'){
     document.getElementById("partnerlimit").value=ext;
   	       
	document.getElementById('editamount'+currentval).innerHTML='$'+currentAmount;
	document.getElementById('editlink'+currentval).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick="editprice('+currentval+','+currentAmount+','+priceid+','+partnerid+','+purpose+','+ext+')">Edit</span>';
}

else
{
currentcount=price;
	
 document.getElementById("commission").value=ext;

document.getElementById('ticketcount'+currentval).innerHTML=currentcount;
document.getElementById('editcntlink'+currentval).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick="editprice('+currentval+','+currentAmount+','+priceid+','+partnerid+','+purpose+','+ext+')">Edit</span>';

               
}
*/

}
currentval=val;
 currentAmount=price;
  if(purpose=='comission'){
   
         document.getElementById("partnerlimit").value=ext;
        document.getElementById('editlink'+currentval).style.display='none'
	         
	document.getElementById('comissioncancellink'+val).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick=makeRequest("/portal/eventbeeticket/partner_commision_details.jsp?groupid="+evtid+"&stype="+searchtype+"&sby="+txtval,"partnerdetails")>Cancel</span>';
	document.getElementById('editamount'+val).innerHTML=""
	 +" <input type='text' name='edittext' id='edittext' size='5' value='"+price+"' />"
	 +" &nbsp;<input type='submit' name='go'  value='Update' >";

}
else
	{
	
	 document.getElementById("commission").value=ext;
                  document.getElementById('editcntlink'+currentval).style.display='none'
	          document.getElementById('countcancellink'+val).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick=makeRequest("/portal/eventbeeticket/partner_commision_details.jsp?groupid="+evtid+"&stype="+searchtype+"&sby="+txtval,"partnerdetails")>Cancel</span>';
		document.getElementById('ticketcount'+val).innerHTML=""
		+"<input type='text' name='editcount' id='editcount' size='5' value='"+price+"' />"
		+" &nbsp;<input type='submit' name='go'  value='Update' >"
	       
	}
}


/*function CancelEdit(val){
if(editpurpose=='comission')
	
	{
	document.getElementById('comissioncancellink'+currentval).innerHTML="";
		document.getElementById('editlink'+currentval).style.display="block";
		document.getElementById('editamount'+currentval).innerHTML=""
	
		var val1=val;
		
		var amt=getAmount(val1.toString());
		
		document.getElementById('editamount'+currentval).innerHTML="$"+amt;
	
	
	
	}
	else{
	document.getElementById('countcancellink'+currentval).innerHTML="";
	document.getElementById('editcntlink'+currentval).style.display="block";
	document.getElementById('ticketcount'+currentval).innerHTML=val;
	}

}
*/

function submitamount(){
   // currentval='0';
    oneupval+=oneupval;
    
	advAJAX.submit(document.getElementById("amountupdate"), {
	onSuccess : function(obj) {

	var data=obj.responseText;
	
    
	if(data.indexOf("Success")>-1){
	
	
		makeRequest("/portal/eventbeeticket/partner_commision_details.jsp?pt=<%=date.getTime()%>"+oneupval+"&groupid="+evtid+"&stype="+searchtype+"&sby="+txtval,"partnerdetails");

		}else{
		 
		   document.getElementById('errordisp'+currentval).innerHTML=data;
		
		}
		

	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

function sendinvitationtopartner(evtid){

advAJAX.get( {
	url : '/portal/eventbeeticket/sendmailtofriend.jsp?groupid='+evtid,
    onSuccess : function(obj) {
	document.getElementById('partnerdetails').innerHTML=obj.responseText;
	},
	onError : function(obj) { alert("Error: " + obj.status); }
});
}
</script>
<script>
function sendinvitation(groupid){
advAJAX.submit(document.getElementById("emailtopartner"), {
    onSuccess : function(obj) {    
	window.location.href="/mytasks/searchpartner.jsp?gid="+groupid; 
	//document.getElementById('partnerdetails').innerHTML='Invitation sent to your selected Friends';
    },
    onError : function(obj) { alert("Error: " + obj.status); }
});

}

function back(){
document.getElementById('partnerdetails').innerHTML='';
}
</script>

<%
if(request.getParameter("filter")==null){

%>

<form name="psearchform">

<table aligh="center">

<tr height="10"><td></td></tr>
<!--
<tr><td>
Partner ID</td><td><input type="text" name="pid"></td>
<td> <input type="button" name="pidsearch" id="pidsearch" value="Search" onclick="partnersearch('<%=groupid%>','pid','<%=platform%>');"></td>
</tr>-->
<tr><td>
Partner Bee ID</td><td><input type="text" name="pBeeid"></td>
<td> <input type="button" name="pBeeidsearch" id="pBeeidsearch" value="Search" onclick="partnersearch('<%=groupid%>','pBeeid','<%=platform%>');"></td>
</tr>

<tr><td>
Partner Name</td><td><input type="text" name="pname"></td>
<td> <input type="button" name="pnamesearch"  value="Search" onclick="partnersearch('<%=groupid%>','pname','<%=platform%>');"></td>
</tr>

<tr><td>
Partner Email ID</td><td><input type="text" name="pemail"></td>
<td> <input type="button" name="pemailsearch" value="Search" onclick="partnersearch('<%=groupid%>','pemail','<%=platform%>');"></td>
</tr>
<tr height="20"><td></td></tr>

<table>
<tr><td colspan="3">
If you don't find the Partner you are looking in search, please <a href="#" onclick="sendinvitationtopartner('<%=groupid%>');">click here to invite
them to become your Partner</a>
</td>
</tr></table>
</table>
</form>
<%
}
%>

<div id='partnerdetails'  align="center"></div>

<div id='errordisp'  align="center"></div>

<%
if("Approved".equals(request.getParameter("filter"))){
%>
<script>
partnersearch('<%=groupid%>','Approved','<%=platform%>');
</script>
<%
}
%>
<%
if("Pending".equals(request.getParameter("filter"))){
%>
<script>
partnersearch('<%=groupid%>','Pending','<%=platform%>');
</script>
<%
}
%>
<%
if("Suspended".equals(request.getParameter("filter"))){
%>
<script>
partnersearch('<%=groupid%>','Suspended','<%=platform%>');
</script>
<%
}
%>