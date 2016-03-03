<%@ page import="com.eventbee.general.*"%>
<%@ include file='/globalprops.jsp' %>

<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%
String eid=request.getParameter("eid");
String domain=EbeeConstantsF.get("serveraddress","www.eventbee.com");
String ntsenable=request.getParameter("ntsenable");
String fbappid=request.getParameter("fbappid");
String urltype="short";
String eventurl=DbUtil.getVal("select shorturl from event_custom_urls where eventid=?",new String[]{eid});
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
String eventlogo="";
if(!"".equals(eid) && eid!=null){
	try{
		Integer.parseInt(eid);
		eventlogo=DbUtil.getVal("select value from config where config_id in (select config_id from eventinfo where eventid=?::BIGINT) and name='event.eventphotoURL'",new String[]{eid});
		if(eventlogo==null || "".equals(eventlogo))
			eventlogo=DbUtil.getVal("select value from config where config_id in (select config_id from eventinfo where eventid=?::BIGINT) and name='eventpage.logo.url'",new String[]{eid});
     }
	catch(Exception e){	
	System.out.println("Exception occured while parsing eid in fbpopupshare.jsp is:"+eid);
	}	
}
if(eventlogo==null || "".equals(eventlogo))
	eventlogo="http://"+domain+"/home/images/social_fb.png";	
if("".equals(fbappid) || fbappid==null)
	fbappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.fbconnect.appid'",null);
%>
 <!--<a href='javascript:closesharepopup();'><img src='/home/images/close.png' class='imgclose' style='margin-top:-36px;'></a>-->
<div style='color: black;font-size: 11px;font-style: inherit;padding: 0 0 10px;' align='center' id='fbregistrationtext'>
<%if("Y".equals(ntsenable)){%>
<p><%=getPropValue("fbpopshre.nts.enable",eid) %> </p>
<%}else{%>
<p><%=getPropValue("fbpopshre.nts.disable",eid) %></p>
<%}%>
</div><center><div id='share-on-facebook'><img src='/home/images/share-on-facebook.png' alt='' border='0'></div></center>

<script>
//window.fbAsyncInit = function() {
	//FB.init({appId: '201409456567228', status: true, cookie: true, xfbml: true});
//227788873904118 ---localhost
//48654146645-- production
/*FB.init({appId: '<%=fbappid%>', status: true, cookie: true, xfbml: true});
};
(function() {
	var e = document.createElement('script');
	e.type = 'text/javascript';
	e.src = document.location.protocol +
		'//connect.facebook.net/en_US/all.js';
	e.async = true;
	document.getElementById('fb-root').appendChild(e);
}());*/

 
	
 function streamPublish(name, description, hrefTitle, hrefLink, userPrompt){
 
 
 
 		var caption='';
		var linkname="";
		if(document.getElementById('eventname')){
			caption=document.getElementById('eventname').innerHTML;
			linkname=caption;
			}
		else{
			caption="this event";
		}
		if(document.title==""){
			linkname=linkname+" - Eventbee";
		}
		else{
			linkname=document.title;
		}
		//var linkurl=''+serveradd+'/event?eid='+eventid+'';
		var linkurl='<%=eventurl%>';
		if(display_ntscode!=""){
			if('<%=urltype%>'=='short')
				//linkurl+="?nts="+display_ntscode;
				linkurl+="/n/"+display_ntscode;
			else
				linkurl+="&nts="+display_ntscode;
			//linkurl=''+serveradd+'/event?eid='+eventid+'&nts='+display_ntscode;
		}
		var d="[{'text':'register','href':'htpp://www.eventbee.com'}]";
		var acobj=eval('('+d+')');
		var fbcaption=props.ss_i_reg+'"'+caption+'"'+props.ss_via;
			FB.ui(
                {
					method: 'stream.publish',
					link: linkurl,
					picture: '<%=eventlogo%>',
					name: linkname,
					caption: fbcaption,
					description: document.getElementById('fb-description').innerHTML
	},
				
                function(response) {
					if (!response || response.error) {
					} else {
											insertPromotion('<%=eid%>','facebook');
				}
                });
            }
           
</script>
