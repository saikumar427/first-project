<%@ page import="com.eventbee.general.*"%>
<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>


<script>

function searchevets(url,id) {
        //document.fnew.button.value='Searching...'
		advAJAX.get( {
		url : url,
		onSuccess : function(obj) {
		document.getElementById(id).innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}

			function searchFormSubmit(contenturl){
				var keyword=document.fnew.keyword.value;
				var location=document.fnew.location.value;
				var ctg=document.fnew.ctg.value;
				var regdd=document.fnew.dd.value;
				var regmm=document.fnew.mm.value; 
				searchevets(contenturl+"&location="+location+"&keyword="+keyword+"&ctg="+ctg+"&dd="+regdd+"&mm="+regmm,"contenttab")
		}
		</script>

<%
String searchtype="adv";
String eventtype=request.getParameter("evttype");
String keyword=request.getParameter("keyword");
String tag=request.getParameter("tag");


String contenturl="/portal/eventdetails/eventlistings.jsp?x=y&evttype="+eventtype+"&location="+request.getParameter("location")+"&ctg="+request.getParameter("category");
if(!"null".equals(searchtype)||"".equals(searchtype))
contenturl+="&searchtype="+searchtype;
if(!"null".equals(keyword)||"".equals(keyword))
contenturl+="&keyword="+keyword;
if(!"null".equals(tag)||"".equals(tag))
contenturl+="&tag="+tag;

String loadmsg="";
if("event".equals(eventtype)) loadmsg="Events";
else loadmsg="Classes";
%>



<div id="contenttab"></div>

<script>

makeMsgRequest("<%=contenturl%>","contenttab","Loading <%=loadmsg%>...",true);
</script>
