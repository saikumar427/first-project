<%@ page import="com.eventbee.general.formatting.EventbeeStrings,java.util.*,com.eventbee.event.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>


<%!


%>

<link rel="stylesheet" type="text/css" href='/home/css/eventlocation.css' />
 
<style>
 
 
 </style>
 
 
 <script language="javascript" src="/home/js/advajax.js" >
dummy23456=888111;

</script>

 
 <script language="javascript" src="/home/js/eventlocations.js">
         function dummy(){}
</script>

<script>

	
	function hitsubmit() {
		//document.evtcat.go.value='searching...';
		document.getElementById('searchmsg').style.color='red';	
		document.getElementById("searchmsg").innerHTML='Searching....';
		 advAJAX.submit(document.getElementById("evtcat"), {
	    onSuccess : function(obj) {
	    var restxt=obj.responseText;
	      				    
		  document.getElementById("message").innerHTML=restxt;
	    //document.evtcat.go.value='search';
	    document.getElementById("searchmsg").innerHTML='';	
	    
	    },
	    onError : function(obj) { alert("Error: " + obj.status);}
	});
	
	}
</script>
 
 <%
 
String count=""; 
String LOCATION=request.getParameter("location");
String disptype="";

String eventtype=request.getParameter("evttype");
if("event".equals(eventtype))
disptype="Events in ";
if("class".equals(eventtype))
disptype="Classes in ";

String COUNTRY=request.getParameter("cid");
if (LOCATION==null)
COUNTRY="USA";

//if(request.getParameter("frompagebuilder") !=null)
//out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) );
%>
<%
String ebeecategory[]=EventbeeStrings.getCategoryNames();%>
<table width="100%" border="0" cellpadding="0" cellspacing="0"  class="innerbeelet" height="0">
				<form name="evtcat" id="evtcat" method="POST"  onSubmit='hitsubmit(); return false;'>
				<table border='0' cellpadding='5' cellspacing='0' width='100%' class='beelet-header' >
				<tr >
			
	    		<td id="locate" class="categorybold" align="left"  ></td>
	    		
		      <td width='1%'></td>
		      <td align='right'><input type="text" name="keyword" value="" size="12"/>  <input value="Search" name="go" type="submit" /></td>
	    		<div id="locbox"  STYLE='height: 290px; width: 160px; font-size: 12px; overflow:auto;' ></div>
				
				</td>
				</tr>
				<tr><td><div id="searchmsg" ></div>	</td></tr>
				</table>
				<!--<tr><td><div id='searchmsg' style='background-color:white'></div></td></tr>-->

				<tr><td>
				<div id='message'></div></td></tr>
				</form>


</table>
<script>
getPage('<%=LOCATION%>','USA','<%=eventtype%>');
</script>

<script>
buildTree('<%=LOCATION%>','<%=COUNTRY%>','<%=eventtype%>');
</script>

<%
//if(request.getParameter("frompagebuilder") !=null)
		//out.println(PageUtil.endContent());
		
		
%>
