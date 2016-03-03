<%@ page import="java.util.*,com.eventbee.general.*" %>
<style type="text/css">
.dhtmlwindow{
background-color: #E1E1E1;
position: absolute;
border: 2px solid #EEF0F2;
visibility: hidden; 
}

.drag-handle{ /*CSS for Drag Handle*/
padding: 5px;
text-indent: 3px;
font-family:"lucida grande",tahoma,verdana,arial,sans-serif;font-size:11px;font-weight:bold; 
font-weight:bold;
background-color:#ffdfb0;
color: #0052A4;
cursor: move;
overflow: hidden;
width: auto;
}

.drag-handle .drag-controls{ /*CSS for controls (min, close etc) within Drag Handle*/
position: absolute;
right: 1px;
top: 2px;
cursor: hand;
cursor: pointer;
}


.drag-contentarea{ /*CSS for Content Display Area div*/
border-top: 1px solid #0052A4;
background-color:#ccff99;
color: black;
height: 150px;
padding: 2px;
overflow: auto;
}

.drag-statusarea{ /*CSS for Status Bar div (includes resizearea)*/
border-top: 1px solid gray;
background-color: #FFFFFF;
height: 13px; /*height of resize image*/
}


.drag-resizearea{ /*CSS for Resize Area itself*/
float: right;
width: 13px; /*width of resize image*/
height: 13px; /*height of resize image*/
cursor: nw-resize;
font-size: 0;
 
}
</style>

<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/dhtml_popup.js">
        function dummy() { }
</script>
<script>
function change()
{
 var i;
	i= document.getElementById("upassword").value;
	var j=(100-i)-document.getElementById("uname").value;
	//alert(j);
//document.loginform.Friendspercentage.value=100-document.getElementById("upassword").value-document.getElementById("uname").value;
 document.loginform.friends.value=j;
 if(isNaN(j)||j<0)
	 document.getElementById('errordisp').innerHTML='Invalid amount. Please enter valid amount.';
//alert(document.loginform.Friendspercentage.value);
	
}
 </script>
<script>
function changeother()
{
 var i;
	i= document.getElementById("Mypercentage").value;
	var j=(100-i)-document.getElementById("uname").value;
//document.loginform.Friendspercentage.value=100-document.getElementById("upassword").value-document.getElementById("uname").value;
 document.loginform.others.value=j;
 if(isNaN(j)||j<0)
	 document.getElementById('errordisp').innerHTML='Invalid amount. Please enter valid amount.'
	
}
 </script>

<script>
function webintegration(groupid,partnerid)
{   
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "./SeturCommsion.jsp?groupid="+groupid+"&partnerid="+partnerid, "Commission Settings", "width=300px, height=450px, left=50px, top=35px,resize=0,scrolling=1") 
		
}
function submitamount(){
	var groupid=<%=request.getParameter("groupid")%>;
	var partnerid=<%=request.getParameter("partnerid")%>;
	advAJAX.submit(document.getElementById("update"), {
	onSuccess : function(obj) {

	var data=obj.responseText;
	if(data.indexOf("Success")>=-1){
		makeRequest("/portal/ningapp/SeturCommsion.jsp?groupid="+groupid+"&partnerid="+partnerid,"update");

		}	 if(data.indexOf("Invalid")>=-1){
			makeRequest("/portal/ningapp/SeturCommsion.jsp?error=yes&groupid="+groupid+"&partnerid="+partnerid,"update");

		
		}
	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

</script>
	<html>


	
Click <a href="#" onclick="webintegration('<%=request.getParameter("groupid")%>','<%=request.getParameter("partnerid")%>')">Commsion Settings </a> to set your Network Commision 
