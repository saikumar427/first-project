<%@page import="com.eventbee.socialnetworking.Twitter"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
//oauth_token=cSdJrTa7yaOhIb1qxsv2gU67KyrgujWFhDPd9tN5g&oauth_verifier=P3Rf5n9F1ddKRxPi7Q5WjAlgV1fIVPAUTG4EO5EaIs
StatusObj sb=DbUtil.getKeyValues("select name,value from config where config_id='0' and name in('ebee.twitterconnect.appid','ebee.twitterconnect.secretkey')",null);
	HashMap twdetails=(HashMap)sb.getData();
	String consumerKey="8HdmQcl2Jlbm3e5XcreTBw";
	consumerKey=(String)twdetails.get("ebee.twitterconnect.appid");
	String cosumerSecret="jNYlcVxlszseQTfHuCGOn4jFEe8JYftPXeXKdsigfbI";
	cosumerSecret=(String)twdetails.get("ebee.twitterconnect.secretkey");
String text=request.getParameter("text");
System.out.println("text: "+text);
Twitter twitter = new Twitter(consumerKey,cosumerSecret);
String accessToken=request.getParameter("authtoken");
String token2=request.getParameter("token2");
System.out.println("accessToken: "+accessToken);
System.out.println("token2: "+token2);
String eid=request.getParameter("eid");
String ntscode=request.getParameter("ntscode");
String name="",userid="";
	JSONObject tt= twitter.updateStatus(accessToken, token2,text);
	System.out.println("text: "+text+tt);
	if(!tt.has("response_status") && !tt.has("errors") && tt.has("user")){
		JSONObject user=(JSONObject)tt.get("user");
		name=(String)user.get("name");
		System.out.println("name: "+name);
		userid=((Integer)user.get("id")).toString();
		String profile_img_src=(String)user.get("profile_image_url_https");
		DbUtil.executeUpdateQuery("update ebee_nts_partner set profile_image_url=?,fname=?,lname='' where nts_code=?",new String[]{profile_img_src,name,ntscode});
		%>
		<jsp:include page='insertpromotion.jsp' >
		<jsp:param name='eid' value='<%=eid%>' />
		<jsp:param name='fbuid' value='<%=userid%>' />
		<jsp:param name='nts_code' value='<%=ntscode%>' />
		</jsp:include>
		<%
	}
//out.println(tt.toString());
%>
<script>
window.close();
</script>
</body>
</html>