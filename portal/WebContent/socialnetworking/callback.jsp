<%@page import="com.eventbee.socialnetworking.Twitter"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.eventbee.general.*,java.util.*,com.eventregister.RegistrationTiketingManager"%>
<%@ page  import="com.eventbee.util.ProcessXMLData,org.w3c.dom.Document,com.eventbee.util.CoreConnector"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
 String getShortUrl(String longUrl){
		String shortUrl="";
		if(longUrl==null)
		longUrl="http://www.eventbee.com";
		  String data="";
		  System.out.println("in shortutl:::"+longUrl);
		try{         CoreConnector cc1=null;
		             Map resMap=null;
				     HashMap urldet=new HashMap();
					 urldet.put("login","eventbeesupport");
					 //o_32gdgehgh2
					 urldet.put("apiKey","R_842d7dffa8aa721ae9d6cc4eb93b3445");
					 //R_4b1dd578bcd0337cd0277d209038d007
					 urldet.put("longUrl",longUrl);
					 urldet.put("format","json");
					 System.out.println("urldet:::"+urldet);			 
					 cc1=new CoreConnector("http://api.bitly.com/v3/shorten");
					 cc1.setArguments(urldet);
			       	 cc1.setTimeout(50000);
				     data=cc1.MGet();
				     System.out.println("data: "+data);
			        JSONObject js=new JSONObject(data);
			        System.out.println(js.get("status_code"));
					if("200".equals(js.get("status_code").toString())){
					System.out.println("in if");
						JSONObject urlobj=(JSONObject)js.get("data");
						shortUrl=(String)urlobj.get("url");
						//urlData.data.url
						//JSONObject urlobj=
					}else shortUrl=longUrl;
					 }
					 catch(Exception e)
					 {
					 System.out.println("error"+e.getMessage());
					 }
		System.out.println("shortUrl: "+shortUrl);
		return shortUrl;
		}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style>
#tparent{
		max-width:640px;
		padding-left: 16px;
}
#tdiv {
    background: none repeat scroll 0 0 rgba(200, 200, 200, 0.3);
    border-radius: 4px 4px 4px 4px;
    margin: 15px -4px 0;
    padding: 4px;

}
.tweettext {
    -moz-box-sizing: border-box;
    background: none repeat scroll 0 0 #FFFFFF;
    border-radius: 4px 4px 4px 4px;
    display: block;
    font-size: 108%;
    height: 65px;
    padding: 4px;
    resize: vertical;
    width: 100%;
	border: 1px solid #CCCCCC;
	}
	.countdown {
    background: none repeat scroll 0 0 #FFFFFF;
    border: 0 none;
    color: #999999;
    font-size: 108%;
    margin-right: 8px;
    padding: 4px 0;
    text-align: right;
    width: 2em;
}
textarea{
   transition: border 0.2s linear 0s, box-shadow 0.2s linear 0s;
}
 textarea:focus{
    border-color: #55BEF1;
    box-shadow: 0 0 8px rgba(82, 168, 236, 0.75);
    outline: 0 none;
}
.button.selected {
    background-color: #3399DD;
    background-image: url("https://abs.twimg.com/a/1372759208/tfw/css/../img/buttons/bg-btn-blue.gif");
    background-position: 0 0;
    border-color: #3399DD #3399DD #2288CC;
    color: #FFFFFF !important;
    text-shadow: -1px -1px 0 #3399DD;
}
.button {
    background: url("https://abs.twimg.com/a/1372759208/tfw/css/../img/buttons/bg-btn.gif") repeat-x scroll 0 0 #DDDDDD;
    border-color: #BBBBBB #BBBBBB #999999;
    border-radius: 4px 4px 4px 4px;
    border-style: solid;
    border-width: 1px;
    box-shadow: 0 1px 0 #F8F8F8;
    color: #333333;
    cursor: pointer;
    display: inline-block;
    font: bold 12px/15px Helvetica Neue,Arial,"Lucida Grande",Sans-serif;
    margin: 0;
    overflow: visible;
    padding: 5px 9px;
    text-shadow: 0 1px #F0F0F0;
    vertical-align: top;
}
h2.action-information {
font-family: sans-serif;
font-weight: bold;
font-size: 125%;
line-height: 55%;
color: #666;
text-shadow: #fff 0 1px 0;
margin: 0 0 15px;
}
body {
    background: linear-gradient(#E9F5FF, #FFFFFF 100px) repeat-x scroll 0 0 #FFFFFF;
    direction: ltr;
    margin: 0;
    padding: 0;
    text-align: left;
}
.button.selected:hover,.button.selected:focus{
	background-position:0 -210px!important;border-color:#28c;-moz-box-shadow:0 0 8px rgba(82,168,236,.75);-webkit-box-shadow:0 0 8px rgba(82,168,236,.75);box-shadow:0 0 8px rgba(82,168,236,.75)}
</style>
</head>
<body>
<%
//oauth_token=cSdJrTa7yaOhIb1qxsv2gU67KyrgujWFhDPd9tN5g&oauth_verifier=P3Rf5n9F1ddKRxPi7Q5WjAlgV1fIVPAUTG4EO5EaIs
String denied=request.getParameter("denied");
if(denied==null){
StatusObj sb=DbUtil.getKeyValues("select name,value from config where config_id='0' and name in('ebee.twitterconnect.appid','ebee.twitterconnect.secretkey')",null);
	HashMap twdetails=(HashMap)sb.getData();
	String consumerKey="8HdmQcl2Jlbm3e5XcreTBw";
	consumerKey=(String)twdetails.get("ebee.twitterconnect.appid");
	String cosumerSecret="jNYlcVxlszseQTfHuCGOn4jFEe8JYftPXeXKdsigfbI";
	cosumerSecret=(String)twdetails.get("ebee.twitterconnect.secretkey");
Twitter twitter = new Twitter(consumerKey,cosumerSecret);
String authtoken=request.getParameter("oauth_token");
String authverifyer=request.getParameter("oauth_verifier");
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String refurl="";
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
JSONObject t = twitter.getTwitterAccessTokenFromAuthorizationCode(authverifyer, authtoken);
HashMap ntsdetails=new HashMap();
HashMap hm=new HashMap();
if("success".equals(t.get("response_status"))){
	String eventid=DbUtil.getVal("select eventid from twitter_auth where auth_token=?",new String[]{authtoken});
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?::BIGINT",new String[]{eventid});
	String eventurl=DbUtil.getVal("select shorturl from event_custom_urls where eventid=?",new String[]{eventid});
	String domain=EbeeConstantsF.get("serveraddress","");
	String accesstoken=(String)t.get("access_token");
	String accesstoken_secret=(String)t.get("access_token_secret");
	String twt_userid=(String)t.get("user_id");
	String screen_name=(String)t.get("screen_name");
	String ntscode="",display_ntscode="";
	try{
		hm.put("fbuserid",twt_userid);
		hm.put("network","twitter");
		hm.put("ntsenable","Y");
		ntsdetails=regtktmgr.getPartnerNTSCode(hm);
		ntscode=(String)ntsdetails.get("nts_code");
		
		display_ntscode=(String)ntsdetails.get("display_ntscode");
		if(eventurl==null){
			eventurl=serveraddress+"/event?eid="+eventid+"&nts="+ntscode;
		}else{
			if(domain.substring(0,4).equals("www.")){
				domain=domain.substring(4);
				eventurl="http://"+eventurl+"."+domain;
			}else
				eventurl=serveraddress+"/v/"+eventurl+"";
			eventurl+="/n/"+ntscode;
		}
		refurl=getShortUrl(eventurl);
	}
	catch(Exception e){
		System.out.println("exception in nts code: "+e.getMessage());
	}

%>

<form name="myform" action="/socialnetworking/submittweet.jsp" method="post">
<input type="hidden" name="authtoken"  value="<%=accesstoken%>">
<input type="hidden" name="token2"  value="<%=accesstoken_secret%>">
<input type="hidden" name="ntscode"  value="<%=ntscode%>">
<input type="hidden" name="eid"  value="<%=eventid%>">
<div id="tparent">
<div class="countdown" style="width: 100%;background: transparent;">Logged in as <b><font color="#3399DD"><%=screen_name%></font></b></div>
<br>
<h2 class="action-information">Share your purchase with your followers</h2>
<div id="tdiv">
<textarea name="text" class="tweettext" onKeyDown="limitText(this.form.text,this.form.countdown,140);" 
onKeyUp="limitText(this.form.limitedtextarea,this.form.countdown,140);">I just registered for <%=eventname%>, <%=refurl%> via @eventbee
</textarea>
</div>
<div style="height: 12px;"></div>
<div style="text-align: right;">
<input readonly type="text" id="countdown" class="countdown" name="countdown" size="3" value="100">

<input type="submit" name="tweet" class="button selected submit"  value="Tweet">
</div>
</div>
</form><script language="javascript" type="text/javascript">
function limitText(limitField, limitCount, limitNum) {
    if (limitField.value.length > limitNum) {
        limitField.value = limitField.value.substring(0, limitNum);
    } else {
        limitCount.value = limitNum - limitField.value.length;
    }
}
limitText(document.myform.text,document.myform.countdown,140);
window.resizeTo('700','300');
</script>
<%}
}else{%>
<script>
window.close();
</script>
<%}%>
</body>
</html>
