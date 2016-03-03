<%@ page import="com.eventbee.general.DBManager,com.eventbee.general.StatusObj,com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.DbUtil"%>
<%
  
  String host="",citydomain="",domainname="",eventbeedomain="",googleapikey="",footerdistext="",servername="";
  try{
        host=(new java.net.URL(request.getRequestURL().toString())).getHost();
		}catch(Exception e)
	    {}
  host=host.toLowerCase();
  String[] uriarr=GenUtil.strToArrayStr(host,"."); 		
  domainname=uriarr[0];
  servername=uriarr[1];
  citydomain="www."+domainname+"withfriends.com";
  eventbeedomain=domainname+"."+servername+".com";
  String citycode=request.getParameter("city");
  if(citycode==null)citycode="";
  if("".equals(citycode))citycode="san-francisco-"+domainname;
  DBManager dbm=new DBManager();
  StatusObj  statobj=null;
  String cityid="",cityname="",metatags="";
  String citynameidquery="select cityid,cityname,header_city from venue_cities where citycode=? and domain=?";
  statobj=dbm.executeSelectQuery(citynameidquery,new String[]{citycode,citydomain});
  if(statobj.getStatus()){
  for(int i=0;i<statobj.getCount();i++){
  cityid=dbm.getValue(i,"cityid","");
  cityname=dbm.getValue(i,"cityname","");
  metatags=dbm.getValue(i,"header_city","");
  if(metatags==null || metatags.equals("null")) metatags="";
   metatags= metatags.replaceAll("www.halloweenwithfriends.com","halloween.eventbee.com");
   }
  }
  googleapikey=DbUtil.getVal("select googleapikey from domain_details where domain=?",new String[]{citydomain}); 
  if("nye".equals(domainname)) 
     footerdistext="New Years Eve";
  else
     footerdistext="Halloween";   
 %>
<html>
<head>
<%if("nye".equals(domainname)){%>
<title>2014 New Years Eve Party Guide & Tickets - <%=cityname%> - Eventbee</title> 
<meta name="description" content="2014 New Years Eve Party Guide & Tickets Powered By Eventbee ticketing">
<meta name="Keywords" content="<%=cityname%> new years eve parties, new years eve, new years eve parties, nye, nye parties, new years eve party tickets, nye tickets, 2014" />
<%}else{%>
<title><%=cityname%> Halloween Parties - Eventbee</title>
<meta name="Description" content="<%=cityname%> 2013 Halloween Party Guide & Tickets Powered By Eventbee ticketing">
<meta name="Keywords" content="<%=cityname%> halloween, halloween parties, halloween party tickets, halloween tickets 2013,halloween events, <%=cityname%> halloween events 2013"/>
<%}%>
<META Http-Equiv="Cache-Control" Content="no-cache">
<link rel="canonical" href="http://<%=eventbeedomain%>/city/<%=citycode%>"/>
<link href="http://<%=citydomain%>/css/<%=domainname%>.css"  rel="stylesheet"/>
<script type="text/javascript" src="http://<%=citydomain%>/js/jQuery.js"></script>
<script src="http://<%=citydomain%>/js/iframehelper.js" type="text/javascript"></script>
<script type="text/javascript" src="http://<%=citydomain%>/js/eventregistration.js"></script>
<style>
#container {
background:#383838;
border-top: 0px;
padding:0px;
margin: 0 auto;
margin-top: 20px;
margin-bottom: 20px;
width:1004px;
}
.search-city {
color: #FFFFFF;
padding: 0px;
position: relative;
width: 100%;
z-index: 2000;
margin:0px;
padding-top:15px;
padding-bottom:15px;
}

.search-city ul {
margin:0px;
padding:0px;
list-style-type: none;
}
.search-city ul li {
line-height: 18px;
}
.search-city ul li a {
border-radius: 10px 10px 10px 10px;
color: #FFFFFF;
display: block;
float: left;
font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;;
font-size: 13px;
font-weight: 1200;
line-height: 32px;
margin: 0px 5px 10px 0px;
padding-left: 20px;
text-decoration: none;
width:99px;
}
.search-city ul li a:hover, .search-city ul li a.activecity {
background: #e5e5e5;
color: #414141;
text-decoration: none;
}

.sell-ticket-button {
    -moz-box-orient: vertical;
    background-color: #EF5A08;
    border: 1px solid #FF6F00;
    border-radius: 10px 10px 10px 10px;
    box-shadow: 0 1px 0 rgba(255, 255, 255, 0.4) inset;
    color: #FFFFFF;
    cursor: pointer;
    display: inline-block;
    font-family:Lucida Grande,Lucida Sans Unicode,sans-serif;
    outline: medium none;
    padding: 5px 10px 6px;
    text-align: center;
    text-decoration: none;
    vertical-align: baseline;
}
</style>
</head>
<body>
<div>
<table width="100%" cellspacing="0" cellpadding="0" align="center" width="100%" valign="top">
	<tr><td width="100%" bgcolor="#ffffff">
	<div id="header" style="min-height:78px;">
	<table cellspacing="0"  cellpadding="0" align="center" width="1004px" bgcolor="#ffffff" style="padding-top:15px;">
    <tr id="anchortag" style="cursor:pointer;">
    <td width="215px"><a href="http://www.eventbee.com" style="cursor:pointer;"><img src="http://eventbee.com/home/images/logo_big.jpg"></a></td>
	<td align="right" valign="middle">
	<span style="font-size:20px;color:#000;font-family:calibri,arial;"><%=footerdistext%> Parties Powered By Eventbee</span>
	<br/><span style="padding-right:100px;"><a class="sell-ticket-button" href="http://www.eventbee.com/main/user/signup">Sell Your Tickets</a></span>
	<!--<a><span id='currentselection' style="color: #BBBBBB;font-family: Lucida Grande,Lucida SansUnicode,sans-serif;font-size: 30px;font-weight: normal;"><%=cityname%></span><span id="image"><img src="http://www.halloweenwithfriends.com/images/venues/city_down.png"  float="center"/></span></a>-->
     </td>
	 </tr>
	 </table>
	 </div>
	 </td></tr>
	<tr><td width="100%" align="center" style="background:#383838;"> 
	<div id="citylist">
	<table cellspacing="0" cellspacing="0" align="center" width="1004px" valign="middle">
    <tr><td width="100%">
	 <div class="search-city" id="citysearch" align="left">
    <ul>	
	<li id="san-francisco-<%=domainname%>"><a class="" href="http://<%=eventbeedomain%>/city/san-francisco-<%=domainname%>">San Francisco</a></li>
	<li id="las-vegas-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/las-vegas-<%=domainname%>">Las Vegas</a></li>
	<li id="los-angeles-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/los-angeles-<%=domainname%>">Los Angeles</a></li>
	<li id="chicago-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/chicago-<%=domainname%>">Chicago</a></li>
	<li id="new-york-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/new-york-<%=domainname%>">New York</a></li>
	<li id="boston-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/boston-<%=domainname%>">Boston</a></li>
	<li id="dallas-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/dallas-<%=domainname%>">Dallas</a></li>
	<li id="atlanta-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/atlanta-<%=domainname%>">Atlanta</a></li>
	<li id="washington-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/washington-<%=domainname%>">Washington</a></li>
	<li id="miami-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/miami-<%=domainname%>">Miami</a></li>
	<li id="other-cities-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/other-cities-<%=domainname%>">Other Cities</a></li>
	<li id="canada-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/canada-<%=domainname%>">Canada</a></li>
	<li id="australia-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/australia-<%=domainname%>">Australia</a></li>
	<li id="uk-cities-<%=domainname%>"><a href="http://<%=eventbeedomain%>/city/uk-cities-<%=domainname%>">UK Cities</a></li>
	<!--<li><a href="http://www.eventbee.com/c/halloween?city=kansas-halloween">Kansas</a></li>-->
	<!--<li><a href="http://www.eventbee.com/c/halloween?city=dallas-halloween">Dallas</a></li>-->
	<!--<li><a class="" href="http://www.eventbee.com/c/halloween?city=denver-halloween">Denver</a></li>-->
    <!--<li><a href="http://www.eventbee.com/c/halloween?city=uk-cities-halloween">UK Cities</a></li>-->
	<!--<li><a href="http://www.eventbee.com/c/halloween?city=australia-halloween">Australia</a></li>-->
  </ul>
	  </div>
	  </td></tr>
    </table>	
    </div>
	</td></tr>
	</table>
</div>	
<!--<div style="font-size:14px;color:#000;font-family:Lucida Grande,Lucida Sans Unicode,sans-serif;padding:10px;background-color:#ebba37;text-align:center;">Halloween Parties Powered By Eventbee</div>-->
<div align="center"  id="container">
<table align="center"  valign="top" width="100%" cellpadding="10px" cellspacing="0px"><tr><td valign="top" height="100%">
<iframe id='_EbeeIFrame1' name='_EbeeIFrame1' src='http://<%=citydomain%>/venueframe.jsp?cityid=<%=cityid%>&serveraddress=http://<%=citydomain%>/city&domain=<%=domainname%>withfriends&googleapikey=<%=googleapikey%>&resizeIFrame=true'  width="100%" height="100%" frameborder="0"  scrolling="no" style="margin:0px;padding:0px;"></iframe></td></tr></table>
</div>
<div>
<table width="1004" cellspacing="0" cellpadding="0" align="center" valign="top" style="background:#383838;"> <tbody><tr>
<td valign="top">
<table width="100%" cellspacing="0" cellpadding="0" align="center" valign="top"><tbody><tr>
<td valign="top">
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/san-francisco-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >San Francisco <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/las-vegas-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2;font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Las Vegas <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/los-angeles-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2;font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Los Angeles <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/chicago-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2;font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Chicago <%=footerdistext%> Parties</a></span>

</td></tr></tbody></table></td>
<td valign="top">
<table width="100%" cellspacing="0" cellpadding="0" align="left" valign="top"><tbody><tr><td valign="top">
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/new-york-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2;font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">New York <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/boston-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >Boston <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/dallas-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >Dallas <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/atlanta-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >Atlanta <%=footerdistext%> Parties</a></span>

<!--<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://halloween.eventbee.com/city/kansas-halloween"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Kansas Halloween Parties</a></span><br>-->

<!--<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://halloween.eventbee.com/city/denver-halloween"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Denver Halloween Parties</a></span><br>-->
</td></tr></tbody></table></td>
<td valign="top">
<table width="100%" cellspacing="0" cellpadding="0" align="left" valign="top"><tbody><tr><td valign="top">
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/washington-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >Washington <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/miami-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Miami <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/other-cities-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Other Cities <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/canada-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Canada <%=footerdistext%> Parties</a></span>
</td></tr></tbody></table></td>
<td valign="top">
<table width="100%" cellspacing="0" cellpadding="0" align="left" valign="top"><tbody><tr><td valign="top">
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/australia-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">Australia <%=footerdistext%> Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://<%=eventbeedomain%>/city/uk-cities-<%=domainname%>"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;">UK Cities <%=footerdistext%> Parties</a></span>
<!--<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://halloween.eventbee.com/city/uk-cities-halloween"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >UK Cities Halloween Parties</a></span><br>
<span style="height:20;">&nbsp;&nbsp;&nbsp;<a href="http://halloween.eventbee.com/city/australia-halloween"style="color:#FFFFFF;text-decoration:none;line-height:2; font-family: Lucida Grande,Lucida Sans Unicode,sans-serif;font-size: 12px;" >Australia Halloween Parties</a></span><br>-->
</td></tr></tbody></table></td>
</tr><tr><td height="5"></td></tr></table></div>
<div id="footer">
   <table cellpadding="5" align="center">
   <tbody><tr><td valign="middle" align="left"><a href="http://www.eventbee.com"><img border="0" src="http://www.eventbee.com/home/images/poweredby.jpg"></a></td>
   <td valign="middle" align="left"><span class="small">Powered by Eventbee - Your Online Registration, Membership Management and Event <br>Promotion solution. For more information, send an email to support at eventbee.com</span></td></tr>
   </tbody>
   </table>
</div>
</body>
</html>
<script>
    var citycode='<%=citycode%>';
	$(document).ready(function(){ 
	    for (i=0;i<jQuery("#citysearch li").length;i++){	   
	     var id=jQuery("#citysearch li")[i].getAttribute('id');
	     if(id==citycode)
		 jQuery("#citysearch #"+id+" a").addClass("activecity");
	}
	  
	});
</script>
