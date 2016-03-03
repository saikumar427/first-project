<%@ page import="com.eventbee.general.*"%>
<%@ include file='/globalprops.jsp' %>
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<html>
<head>
<script>
function checkEmailForm()
	{
		if (!document.emailForm.fromname.value) {
			alert(props.ss_name);
			return false;
		}
		if (!document.emailForm.fromemail.value) {
			alert(props.ss_from_email);
			return false;
		}
		if (!document.emailForm.toemails.value) {
		    alert(props.ss_to_invalid_email);
			return false;
		}
		if (!document.emailForm.subject.value) {
			alert(props.ss_subject);
			return false;
		}
		if (!document.emailForm.personalmessage.value) {
			alert(props.ss_msg);
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.emailForm.fromemail.value)){
			alert(props.ss_from_invalid_email);
			return false;
		}
		  var toemail=document.emailForm.toemails.value;
			var tokens = toemail.tokenize(",", " ", true);
		for(var i=0; i<tokens.length; i++){
			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
				alert(tokens[i] + props.ss_email_error);
				return false;
			}
		}
		document.emailForm.sendmsg.value=props.email_sending_msg;
		advAJAX.submit(document.getElementById("emailForm"), {
		    onSuccess : function(obj) {
		    var restxt=obj.responseText;
		   if(restxt.indexOf("Error")>-1){
		  		     document.getElementById('emailcaptchamsg').style.display='block';
					 document.getElementById("emailcaptchaid").src="/home/images/ajax-loader.gif";
					 document.getElementById("emailcaptchaid").src="/captcha?fid=emailForm&pt="+new Date().getTime();
		  		     document.emailForm.sendmsg.value=""+props.ss_send;
		     }
		     else{
				ebeepopup.setContent("<center>"+restxt+"<br><input type='button' value='"+props.ss_ok+"' onclick='ebeepopup.hide()'>");
				ebeepopup.show();
		   }
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});
		
	}
</script>
<style>
.social-share {
background: rgb(255,255,255); /* Old browsers */
background: -moz-linear-gradient(top,  rgba(255,255,255,1) 0%, rgba(237,237,237,1) 28%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,255,255,1)), color-stop(28%,rgba(237,237,237,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(237,237,237,1) 28%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(237,237,237,1) 28%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(237,237,237,1) 28%); /* IE10+ */
background: linear-gradient(to bottom,  rgba(255,255,255,1) 0%,rgba(237,237,237,1) 28%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#ededed',GradientType=0); /* IE6-9 */
cursor:pointer;
border:1px solid rgba(229,229,229,1);
border-radius:3px;
color: #666;
padding: 13px 15px 15px;
margin : 10px 10px 10px 0px;
}

.sharing-section
{
margin-top: 10px;
margin-bottom: 10px;
}

.sharing-section a span{
text-decoration:none;
color: #666;
cursor:pointer;
}
.fbsharebtn{
border: medium none;
background: none repeat scroll 0 0 transparent;
width: 65px;
cursor:pointer;
}
</style>
</head>
<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
String name="",email="";
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery("select email,fname||' '||lname as name from buyer_base_info where transactionid=?",new String[]{tid});
if(sb.getStatus() && sb.getCount()>0){
	name=db.getValue(0,"name","");
	email=db.getValue(0,"email","");
}
String domain=EbeeConstantsF.get("serveraddress","www.eventbee.com");
String urltype="short";
String eventurl=DbUtil.getVal("select shorturl from event_custom_urls where eventid=?",new String[]{eid});
String eventlogo="";
if(!"".equals(eid) && eid!=null){
try{
	Integer.parseInt(eid);
	eventlogo=DbUtil.getVal("select value from config where config_id in (select config_id from eventinfo where eventid=?::BIGINT) and name='event.eventphotoURL'",new String[]{eid});
    if(eventlogo==null || "".equals(eventlogo))
	eventlogo=DbUtil.getVal("select value from config where config_id in (select config_id from eventinfo where eventid=?::BIGINT) and name='eventpage.logo.url'",new String[]{eid});
	}catch(Exception e){
		System.out.println("Exception occured while parsing eid in socialshare.jsp is:"+eid);
	}
}
if(eventlogo==null || "".equals(eventlogo))
	eventlogo="http://"+domain+"/home/images/social_fb.png";	
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
%>
<body>
<b><%=getPropValue("ss.share.purchase",eid)%>:</b>
<div style="height:8px"></div>
<table  cellpadding="0" cellspacing="0">
	<tr><td>
	<div class="sharing-section">
		
			<a class="social-share col-xs-3 col-md-3" id="fbconfshare">
			 <span style="background-image: url(/main/images/fbsmall.jpg);background-repeat: no-repeat;padding-left: 19px;"><%=getPropValue("ss.share",eid)%></span> </a>
		
	
			<a class="social-share col-xs-3 col-md-3" id="conftweet"> 
			<span style="background-image: url(/main/images/tweet.png);background-repeat: no-repeat;padding-left: 19px;width:15px;height:15px;"><%=getPropValue("ss.tweet",eid)%></span> 
			</span></a>
		
		
		<a class="social-share col-xs-3 col-md-3" onclick="emailContent()" id="submitBtn" > 
		<span style="background-image: url(/main/images/home/email.png);background-repeat: no-repeat;padding-left: 19px;"><%=getPropValue("ss.email",eid)%></span></a>
	
	<div id='emailcontent' style="display:none">	
	 <div id='EmailInvitation'>
		<div  style=' margin: 10 5 10 5;'>
	 <form name='emailForm'  id='emailForm' action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id=<%=eid%>&purpose=INVITE_FRIEND_TO_EVENT'  method='post' >
	<input type='hidden' name='url' value='<%=eventurl%>' />
	 <%=getPropValue("ss.to",eid)%>* :<br>
	 <textarea id='toheader' name='toemails' placeholder="<%=getPropValue("ss.comma.seperate",eid)%>" style='width: 350px; height: 40px;'></textarea>
	 <br>
	 <%=getPropValue("ss.ur.email",eid)%>* :<br> 
	 <input type='text' name='fromemail' value='<%=email%>'  style='width: 200px;'><br>
	<%=getPropValue("ss.ur.name",eid)%>* :  <br>
	 <input type='text' name='fromname' value='<%=name%>'  style='width: 200px;'><br>
	 <%=getPropValue("ss.sub",eid)%> :<br> 
	 <input type='text' id="mailsubject" name='subject' value='' style='width: 200px;'><br>
	<%=getPropValue("ss.msg",eid)%> :<br> 
	 <textarea id="permsg" name='personalmessage' style='width: 350px; height: 50px;'></textarea><br>
	 <p align='center'>
	 <div id='emailcaptchamsg' style='display: none; color:red' ><%=getPropValue("ss.enter.crct",eid)%></div> 
	<%=getPropValue("ss.enter.below",eid)%> :<div width="100%" valign="top" style="padding:5px;">
<table><tbody><tr><td valign="middle">
<input type="text" valign="top" value="" size="8" name="captcha"></td><td>
	  <img src="/home/images/ajax-loader.gif" alt="Captcha" id="emailcaptchaid">
</td></tr></tbody></table></div><br>
	<input type='hidden' name='formname' value='emailForm'/>
	 <div class="submitbtn-style" style="width:70px;float:left"><input type="button" name="sendmsg" value="<%=getPropValue("ss.send",eid)%>" class="fbsharebtn" onclick=" return checkEmailForm()"> </div>
	 <div class="submitbtn-style" style="width:70px;float:left"><input type="button" onclick="javascript:ebeepopup.hide();" class="fbsharebtn" value="<%=getPropValue("ss.cancel",eid)%>"></div>
	 </p>
	 </form> </div>
	 <div id='message'></div>
	 </div>
	 </div>
	 </div>
		</td>
	</tr>
	 <tr><td colspan="3" style="height:15px"></td></tr>
	<tr><td colspan="3"><%=getPropValue("ss.refer.lnk",eid)%> <input type="text" id="evereflink" name="evereflink" readonly="readonly" value="" size="50"></td></tr>
	<tr><td colspan="3" style="height:10px"></td></tr>
</table>
<script>
var eveid='<%=eid%>';
var urltype='<%=urltype%>';

 	var publishurl="<%=eventurl%>";
	var caption='';
	var linkname="";
	if(document.getElementById('eventname')){
		caption=jQuery('#eventname').text();
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
		document.getElementById("evereflink").value=publishurl;
		document.getElementById("permsg").innerHTML=props.ss_i_reg+caption+", "+publishurl + props.ss_via_at;
	function getEventUrl(dntscode){
		var linkurl='<%=eventurl%>';
		if(dntscode!=""){
			if('<%=urltype%>'=='short')
			linkurl+="/n/"+dntscode;
		else
			linkurl+="&nts="+dntscode;
		}
		return linkurl;
	}

function fbfeed(){
	//fbpublish(linkname,'<%=eventlogo%>',caption);
	var feedurl=getEventUrl(display_ntscode);
	FB.ui(
  {
   method: 'feed',
    name: linkname,
    link: feedurl,
    picture: '<%=eventlogo%>',
    caption:props.ss_i_reg+'"'+caption+'"'+props.ss_via,
    description: document.getElementById('fb-description').innerHTML
  },
  function(response) {
    if (response && response.post_id) {
     // alert('Post was published.');
	 insertPromotion(eventid,'facebook');
    } else {
      //alert('Post was not published.');
    }
  }
)
}
	var emailHTML="";
function emailContent(){
	if(emailHTML=="")
	emailHTML=document.getElementById("EmailInvitation").innerHTML;
	ebeepopup.setContent(emailHTML);
	document.getElementById("EmailInvitation").innerHTML="";
	document.getElementById("mailsubject").value=linkname;
	ebeepopup.onPopupClose(function(){
		ebeepopup.setContent("");
	});
	//ebeepopup.setDraggable(true);
	ebeepopup.show();
	document.getElementById("emailcaptchaid").src="/captcha?fid=emailForm&pt="+new Date().getTime();
}
function activatePlaceholders() 
{
	var detect = navigator.userAgent.toLowerCase();
	if (detect.indexOf("") > 0) 
	return false;
	var inputs = document.getElementsByTagName("input");
	for (var i=0;i<inputs.length;i++) 
	{
	  if (inputs[i].getAttribute("type") == "text") 
	  {
		if (inputs[i].getAttribute("placeholder") && inputs[i].getAttribute("placeholder").length > 0) 
		{
			if(inputs[i].value.length==0)
			inputs[i].value = inputs[i].getAttribute("placeholder");
			inputs[i].onfocus = function() 
			{
				//alert(this.value.length+" -- "+this.getAttribute("placeholder"));
				 if (this.value == this.getAttribute("placeholder")) 
				 {
					  this.value = "";
					  this.style.color ="black";
				 }
				 return false;
			}
			inputs[i].onblur = function() 
			{
				 if (this.value.length < 1) 
				 {
					  this.value = this.getAttribute("placeholder");
					  this.style.color ="darkgray";
				 }
			}
		}
	  }
	}
}
function activateTextArea(){
     var textarea=document.getElementById("message");
     textarea.onfocus = function () {
        if (this.value == "<Click here> and type your Message - Required") {
            this.value = "";
            this.style.color ="black";
        }
       return false;
     };
     textarea.onblur = function () {
        if (this.value == "") {
            this.value = "<Click here> and type your Message - Required";
            this.style.color ="darkgray";
        }
    };
}
</script>
</body>
</html>
