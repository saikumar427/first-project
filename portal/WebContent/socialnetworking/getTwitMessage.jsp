<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="application/JSON; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ page import="com.eventbee.general.*,java.util.*,com.eventregister.RegistrationTiketingManager"%>
<%@ page  import="com.eventbee.util.ProcessXMLData,org.w3c.dom.Document,com.eventbee.util.CoreConnector"%>
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

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String refurl="";


StringBuffer buf = new StringBuffer(1025);
BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
String line;
String message = "";
while((line = br.readLine()) != null) {
	buf.append(line.trim() + "\n");
}
br.close();
br=null;
message = buf.toString();
System.out.println("message::"+message);


/* message="{\"auth_token\":\"ZeHrwgeYxeU7x547FmCJCkt2nZPwqMgmd0hbNM5L\",\"twitdata\":{\"id\":158652280,\"id_str\":\"158652280\",\"name\":\"ParthaSarathi G\",\"screen_name\":\"parthug\",\"location\":\"Teh internets\",\"description\":\"\",\"url\":null,\"entities\":{\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":0,\"friends_count\":0,\"listed_count\":0,\"created_at\":\"Wed Jun 23 07:11:07 +0000 2010\",\"favourites_count\":0,\"utc_offset\":null,\"time_zone\":null,\"geo_enabled\":false,\"verified\":false,\"statuses_count\":1,\"lang\":\"en\",\"status\":{\"created_at\":\"Fri Sep 28 09:27:51 +0000 2012\",\"id\":2.5161418716653e+17,\"id_str\":\"251614187166527489\",\"text\":\"RT @GroupTicketer: why buy at regular price, when you can buy at group discount?...stay tuned, we are gearing up for public launch!\",\"source\":\"web\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,"+
"\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"geo\":null,"
+"\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweeted_status\":{\"created_at\":\"Thu Sep 27 19:58:46 +0000 2012\",\"id\":2.5141057407906e+17,"+
"\"id_str\":\"251410574079057920\",\"text\":\"why buy at regular price, when you can buy at group discount?...stay tuned, we are gearing up for public launch!\","+
"\"source\":\"web\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":1,\"favorite_count\":0,\"entities\":{\"hashtags\":[],\"symbols\":[],\"urls\":[],\"user_mentions\":[]},\"favorited\":false,\"retweeted\":true,\"lang\":\"en\"},\"retweet_count\":1,\"favorite_count\":0,\"entities\":{\"hashtags\":[],\"symbols\":[],\"urls\":[],\"user_mentions\":"+
"[{\"screen_name\":\"GroupTicketer\",\"name\":\"Group Ticketer\",\"id\":826311415,\"id_str\":\"826311415\",\"indices\":[3,17]}]},\"favorited\":false,\"retweeted\":true,\"lang\":\"en\"},\"contributors_enabled\":false,\"is_translator\":false,\"is_translation_enabled\":false,\"profile_background_color\":\"FFFFFF\",\"profile_background_image_url\":"
+"\"http://abs.twimg.com/images/themes/theme1/bg.png\",\"profile_background_image_url_https\":\"https://abs.twimg.com/images/themes/theme1/bg.png\",\"profile_background_tile\":false,\"profile_image_url\":\"http://abs.twimg.com/sticky/default_profile_images/default_profile_3_normal.png\",\"profile_image_url_https\":\"https://abs.twimg.com/sticky/default_profile_images/default_profile_3_normal.png\",\"profile_link_color\":\"0084B4\",\"profile_sidebar_border_color\":\"C0DEED\",\"profile_sidebar_fill_color\":\"DDEEF6\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":true,\"following\":false,\"follow_request_sent\":false,\"notifications\":false}}";
 */
 String twitid="",name="",image="";

JSONObject json=new JSONObject(message);
String authtoken=json.has("auth_token")?(String)json.get("auth_token"):"";
String beeid=json.has("bee_id")?(String)json.get("bee_id"):"";
System.out.println("authtoken::"+authtoken);
System.out.println("beeid in getTwitMessage ::"+beeid);
try{
if(json.has("twitdata"))
	{twitid=(json.getJSONObject("twitdata").has("id"))?json.getJSONObject("twitdata").get("id")+"":"";
	name=(json.getJSONObject("twitdata").has("name"))?(String)json.getJSONObject("twitdata").get("name"):"";
	image=(json.getJSONObject("twitdata").has("profile_image_url_https"))?(String)json.getJSONObject("twitdata").get("profile_image_url_https"):"";
	}
}catch(Exception e){System.out.println("Json parse exception"+e.getMessage());}


System.out.println("twitid::"+twitid);
System.out.println("name::"+name);
System.out.println("image::"+image);
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
HashMap ntsdetails=new HashMap();
HashMap hm=new HashMap();
    if("".equals(beeid)){
    String eventid=DbUtil.getVal("select eventid from twitter_auth where auth_token=?",new String[]{authtoken});
    String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?::BIGINT",new String[]{eventid});
	String eventurl=DbUtil.getVal("select shorturl from event_custom_urls where eventid=?",new String[]{eventid});
	String domain=EbeeConstantsF.get("serveraddress","");

	String ntscode="",display_ntscode="";
	try{
		hm.put("fbuserid",twitid);
		hm.put("network","twitter");
		hm.put("ntsenable","Y");
		System.out.println("hm::"+hm);
		ntsdetails=regtktmgr.getPartnerNTSCode(hm);
		ntscode=(String)ntsdetails.get("nts_code");
		System.out.println("ntsdetails::"+ntsdetails);
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
	
		System.out.println("name: "+name);

		DbUtil.executeUpdateQuery("update ebee_nts_partner set profile_image_url=?,fname=?,lname='' where nts_code=?",new String[]{image,name,ntscode});
	
	%>
	 	<jsp:include page='insertpromotion.jsp' >
		<jsp:param name='eid' value='<%=eventid%>' />
		<jsp:param name='fbuid' value='<%=twitid%>' />
		<jsp:param name='nts_code' value='<%=ntscode%>' />
		</jsp:include> 
		<%
	 }
	catch(Exception e){
		System.out.println("exception in nts code: "+e.getMessage());
	}
	
	out.println(new JSONObject().put("message", "I just registered for "+eventname+", "+refurl+" via @eventbee").toString(2));
    }else{
    	refurl=getShortUrl(serveraddress+"/signup/"+beeid);
    	out.println(new JSONObject().put("message", "Get a free Kindle Fire with Eventbee ticketing. Save BIG with our $1 flat fee per ticket pricing. Visit "+refurl).toString(2));
    }
%>
