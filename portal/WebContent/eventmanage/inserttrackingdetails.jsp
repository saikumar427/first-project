<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.editprofiles.ProfileValidator"%>

<%
	String eventid=request.getParameter("groupid");
	String userid="";
	Authenticate au=AuthUtil.getAuthData(pageContext);
	if(au !=null) userid=au.getUserID();
	ProfileValidator pv=new ProfileValidator();
	String name=request.getParameter("name");
	if(pv.checkNameValidity(name,true)){
	}else{
	out.print("spacesInUrl");
	return;
	}
	String namecheck=name.toLowerCase();
	String alreadyexists=DbUtil.getVal("select 'yes' from trackurls where lower(trackingcode)=? and eventid=?",new String[]{namecheck,eventid});
	if(!"yes".equals(alreadyexists)){
	String trackingid=DbUtil.getVal("select nextval('trackingid')",new String[]{});
	String secretcode=EncodeNum.encodeNum(trackingid);
	DbUtil.executeUpdateQuery("insert into trackURLs(eventid,trackingcode,count,password,trackingid,secretcode,created_date) values (?,?,'0',?,?,?,now())",new String[]{eventid,name,name,trackingid,secretcode});
	}else
	out.print("Name Exists");
%>

	