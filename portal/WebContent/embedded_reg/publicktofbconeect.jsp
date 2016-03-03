<%@ page import="com.eventbee.general.*"%>
<script language="javascript" src="/home/js/webintegration.js">
         function dummy(){}
</script>

<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php" type="text/javascript">
	function fbdummy(){ }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function advajxdummy(){ }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function ajaxdummy(){ }
</script>
<script language="JavaScript" type="text/javascript" src="/home/js/fbconnect.js" >
	function dummyfbconnect() { }
</script>

<%

String eid=request.getParameter("eid");
String fbconnapi=(String)session.getAttribute("FBCONNECTAPIKEY");
		System.out.println("fbconnapi--"+fbconnapi);
		if(fbconnapi==null){
			fbconnapi=DbUtil.getVal("select value  from config where config_id=? and name='ebee.fbconnect.api'",new String[]{"1"});
    	System.out.println("fbconnapi--"+fbconnapi);
			session.setAttribute("FBCONNECTAPIKEY", fbconnapi);
		}

%>

<script>
 	
 	function createFBSectionForHeader(){
		FB_RequireFeatures(["XFBML"], function(){
		FB.Facebook.init("<%=fbconnapi%>", "/portal/xd_receiver.jsp");
		if(FB.Facebook.apiClient!=null && FB.Facebook.apiClient.get_session()!=null){
			ShowFBProfile();
		} 
		});
	}
	
	
</script>


<table>
<tr><td>
<td id="confirmationfeed">


<a href="#" onclick="Confirmationpagefbfeed('<%=eid%>');"><img src="/home/images/fbconnect.gif" border='0'/>
</td></tr>
</table>

<script>
 	createFBSectionForHeader();
</script>