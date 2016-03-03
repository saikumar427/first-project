<%@ page import="com.eventbee.general.*"%>

<%
String country=(String)request.getAttribute("USER_COUNTRY");
	
String location="";
if((String)request.getAttribute("USER_LOCATION")!=null&& !"null".equals((String)request.getAttribute("USER_LOCATION")))
{
	location=(String)request.getAttribute("USER_LOCATION");
	
}
	
String contenturl="/portal/hub/hubcategorylist.jsp?x=y";
if(country!=null&&!"".equals(country)&&!"null".equals(country))
contenturl=contenturl+"&country="+country;
if(location!=null&&!"".equals(location)&&!"null".equals(location))
contenturl=contenturl+"&location="+location;
			

%>


<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>

	
	function hitsubmit() {
		document.fnew.go.value='Searching...';
	    advAJAX.submit(document.getElementById("fnew"), {
	    onSuccess : function(obj) {
	    var restxt=obj.responseText;
	    			    
		  document.getElementById("contenttab").innerHTML=restxt;
	    
	    },
	    onError : function(obj) { alert("Error: " + obj.status);}
	});
	}
</script>


<div id="contenttab"></div>


<script>
makeRequest("<%=contenturl%>","contenttab");
</script>