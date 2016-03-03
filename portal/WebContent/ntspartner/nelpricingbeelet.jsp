<%@ page import="com.eventbee.general.*"%>

<%
java.util.Date date=new java.util.Date();
String contenturl="/ntspartner/nelpricesview.jsp?tm="+date.getTime();
%>

<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>
var currentval='0';
var currentAmount='0';
var oneupval=1;

function editprice(val,price){
if(currentval!='0'){

	document.getElementById('editamount'+currentval).innerHTML='$'+currentAmount;
	document.getElementById('editlink'+currentval).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick="editprice('+currentval+','+currentAmount+')">Edit</span>';

}
currentval=val;
currentAmount=price;
document.getElementById('editlink'+val).innerHTML='<span style="cursor: pointer; text-decoration: underline" onclick=makeRequest("/networkeventlisting/price.jsp","networklisting")>Cancel</span>';
document.getElementById('editamount'+val).innerHTML=""
+" <input type='text' name='edittext' size='5' value='"+price+"' />"
+" &nbsp;<input type='submit' name='go'  value='Update' >"
+"<input type='hidden' name='duration' size='5' value='"+val+"' />";
}


function submitamount(){
    currentval='0';
    oneupval+=oneupval;
	advAJAX.submit(document.getElementById("amountupdate"), {
	onSuccess : function(obj) {

	var data=obj.responseText;
	if(data.indexOf("Success")>-1){
		makeRequest("/ntspartner/nelpricesview.jsp?pt=<%=date.getTime()%>"+oneupval,"networklisting");

		}	if(data.indexOf("Invalid")>-1){
		  
		   document.getElementById('errordisp').innerHTML='Invalid amount. Please enter valid amount.';
		
		}
	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}


</script>


 <div id="networklisting">
 
</div>


<script>
makeRequest("<%=contenturl%>","networklisting");
</script>

