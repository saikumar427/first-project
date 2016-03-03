<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.socialnetworking.Twitter"%>
<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%
	System.out.println("in oauth token.jsp");
	StatusObj sb=DbUtil.getKeyValues("select name,value from config where config_id='0' and name in('ebee.twitterconnect.appid','ebee.twitterconnect.secretkey')",null);
	HashMap hm=(HashMap)sb.getData();
	if(hm!=null && hm.size()>0){
	String consumerKey="8HdmQcl2Jlbm3e5XcreTBw";
	consumerKey=(String)hm.get("ebee.twitterconnect.appid");
	String cosumerSecret="jNYlcVxlszseQTfHuCGOn4jFEe8JYftPXeXKdsigfbI";
	cosumerSecret=(String)hm.get("ebee.twitterconnect.secretkey");
	String eventid=request.getParameter("eid");
	Twitter twitter = new Twitter(consumerKey,cosumerSecret);
	JSONObject t = twitter.startTwitterAuthentication();
	DbUtil.executeUpdateQuery("delete from twitter_auth where created_at<(current_timestamp-interval '2 days')",null);
	DbUtil.executeUpdateQuery("insert into twitter_auth(auth_token,eventid,created_at) values(?,?,now())",new String[]{(String)t.get("oauth_token"),eventid});
	//out.println(t.toString());
	response.sendRedirect("https://api.twitter.com/oauth/authorize?oauth_token="+(String)t.get("oauth_token"));
	}
	else{
	%>
	<script>
		alert("Something went wrong. Please try back later");
		window.close();
	</script>
	<%
	}
%>