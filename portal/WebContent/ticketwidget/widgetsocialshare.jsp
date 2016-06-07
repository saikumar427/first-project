<%@page import="org.json.JSONObject"%>
<%@ page import="com.eventbee.general.*"%>
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%@ include file="cors.jsp" %>
<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
String name="",email="",eventname="",eventwhere="",eventwhen="";;
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery("select email,fname||' '||lname as name from buyer_base_info where transactionid=?",new String[]{tid});
if(sb.getStatus() && sb.getCount()>0){
	name=db.getValue(0,"name","");
	email=db.getValue(0,"email","");
}
String domain=EbeeConstantsF.get("serveraddress","");
String urltype="short";
String eventurl=DbUtil.getVal("select shorturl from event_custom_urls where eventid=?",new String[]{eid});
String eventlogo="";
if(!"".equals(eid) && eid!=null){
try{
	Integer.parseInt(eid);
	eventlogo=DbUtil.getVal("select value from config where config_id in (select config_id from eventinfo where eventid=?::BIGINT) and name='event.eventphotoURL'",new String[]{eid});
    if(eventlogo==null || "".equals(eventlogo))
	eventlogo=DbUtil.getVal("select value from config where config_id in (select config_id from eventinfo where eventid=?::BIGINT) and name='eventpage.logo.url'",new String[]{eid});
  	eventname = DbUtil.getVal("select eventname from eventinfo where eventid=?::BIGINT",new String[]{eid});
  	
  
  	DBManager dbevt=new DBManager();
  	StatusObj sbevt=dbevt.executeSelectQuery("select to_char(start_date+cast(cast(to_timestamp(COALESCE(starttime,'00'),'HH24:MI:SS') as text) as time ),'DD Mon YYYY, HH12:MI AM') ||' to '|| to_char(end_date+cast(cast(to_timestamp(COALESCE(endtime,'00'),'HH24:MI:SS') as text) as time ),'DD Mon YYYY, HH12:MI AM')  as when,eventname, CASE WHEN venue!='' THEN venue ||',' ELSE '' END ||  CASE WHEN address1!='' THEN address1 ||' ' ELSE '' END || CASE WHEN address2 !='' THEN address2 ||', ' ELSE '' END || CASE WHEN city!='' THEN city ||'.' ELSE '.' END as where  from eventinfo where eventid=to_number(?,'999999999')",new String[]{eid});
  	if(sbevt.getStatus()){
  		eventname=dbevt.getValue(0,"eventname","");
  		eventwhere=dbevt.getValue(0,"where","");
  		eventwhen=dbevt.getValue(0,"when","");
  	}
  	
  	
	}catch(Exception e){
		System.out.println("Exception occured while parsing eid in socialshare.jsp is:"+eid);
	}
}
if(eventlogo==null || "".equals(eventlogo))
	eventlogo="http://www.citypartytix.com/home/images/ebee_fb_logo3.png";	
if(eventurl==null){
	eventurl=serveraddress+"event?eid="+eid;
	urltype="normal";
}
else{
	if(domain.substring(0,4).equals("www.")){
	domain=domain.substring(4);
	eventurl="http://"+eventurl+"."+domain;
	}else
	eventurl=serveraddress+"/v/"+eventurl+"";
}
StringBuffer sbf= new StringBuffer();
//sbf.append("<b>Share your purchase:</b>");
//sbf.append("<div style=\"height:8px\"></div><table  cellpadding=\"0\" cellspacing=\"0\"><tr><td><div class=\"sharing-section\">");
//sbf.append("<a class=\"social-share\" id=\"fbconfshare\" ng-click=\"fbconfshare()\"><span style=\"background-image: url(/main/images/fbsmall.jpg);background-repeat: no-repeat;padding-left: 19px;\">Share</span> </a>");
//sbf.append("<a class=\"social-share\" id=\"conftweet\" ng-click=\"conftweet()\"><span style=\"background-image: url(/main/images/tweet.png);background-repeat: no-repeat;padding-left: 19px;width:15px;height:15px;\">Tweet</span></a>");
//sbf.append("<a class=\"social-share\" ng-click=\"emailContent()\" id=\"submitBtn\" > <span style=\"background-image: url(/main/images/home/email.png);background-repeat: no-repeat;padding-left: 19px;\">Email</span></a></div></td></tr>");
//sbf.append(" <tr><td colspan=\"3\" style=\"height:15px\"></td></tr>");
//sbf.append("<tr><td colspan=\"3\">Your referral link <input type=\"text\" id=\"evereflink\" name=\"evereflink\" readonly=\"readonly\" value=\""+eventurl+"\" size=\"50\"></td></tr>");
//sbf.append(" <tr><td colspan=\"3\" style=\"height:10px\"></td></tr></table>");

sbf.append("<div class=\"col-md-12 \"><b>Share your purchase :</b></div><br>");
sbf.append("<div class=\"col-md-12 text-center \" style=\"margin-top: 20px;\">");
sbf.append("<span class=\"social-facebook\" id=\"fbconfshare\" ng-click=\"fbconfshare()\" ><i class=\"fa fa-facebook\" ></i> Share </span>");
sbf.append("<span class=\"social-tweet\" style=\"margin:0px 15px;\" id=\"conftweet\" ng-click=\"conftweet()\"><i class=\"fa fa-twitter\"></i> Tweet </span>");
sbf.append("<span class=\"social-email\" ng-click=\"emailContent()\" id=\"submitBtn\"><i class=\"fa fa-envelope\"></i> Email </span>");
sbf.append("</div><br><br><br><br>");
sbf.append("<div class=\"col-md-12\">Your referral link <input type=\"text\" id=\"evereflink\" readonly=\"readonly\" value=\""+eventurl+"\" size=\"50\"  onclick=\"this.setSelectionRange(0, this.value.length)\"></div>");




String description = "";
if(eventwhen!=null)
	description += "When: "+eventwhen+".";
if(eventwhere!=null)
	description += "&nbsp;Where: "+eventwhere+"";
	

JSONObject jsonObj = new JSONObject();
jsonObj.put("sharehtml",sbf.toString());
jsonObj.put("eventurl",eventurl);
jsonObj.put("eventlogo",eventlogo);
jsonObj.put("caption","");
jsonObj.put("urltype",urltype);
jsonObj.put("email",email);
jsonObj.put("name",name);
jsonObj.put("linkname",eventname==null ?"" :eventname+" - Eventbee");
jsonObj.put("caption",eventname==null ?"" :eventname);
jsonObj.put("msg","I just registered for "+eventname+", " +eventurl+" via @eventbee");
jsonObj.put("description",description);		
out.println(jsonObj.toString());
%>


