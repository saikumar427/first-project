<%-- desiheader roler--%>

 <%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*" %>

<script type="text/javascript" language="JavaScript" src="/home/js/popup.js">
        function dummy() {}
</script>


<%!




String FOOTER = "<div style='margin-top:10px'  class='FOOTER'> "
+" <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center'> "
        +"<tr> " 
          +" <td height='1' bgcolor='666666' colspan='2'></td> "
        +" </tr> "
        +" <tr> " 
          +" <td colspan='2' height='16'>" 
            +" <div align='center'><font face='Verdana, Arial, Helvetica, sans-serif' size='-3'> "
		      +" </font> " 
		      +" <p>"
		      +" <a href=\"javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/aboutus.html','');\" STYLE='text-decoration: none'>"
		      +" <span class='footertab'>About Us</span></a><span class='footertab'> | </span>"
		      +" <a href=\"javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/privacystatement.html','');\" STYLE='text-decoration: none'>"
		      +"  <span class='footertab'>Privacy Statement</span></a><span class='footertab'> | </span> "
		      +" <a href=\"javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/termsofservice.html','');\" STYLE='text-decoration: none'> "
		      +" <span class='footertab'>Terms of Service</span></a><span class='footertab'> | </span>"
		      +" <a href=\"javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/trademarks.html','');\" STYLE='text-decoration: none'> "
		      +" <span class='footertab'>Trade Marks</span></a>"
		      +" <span class='footertab'> | </span> "
		      +" <a href=\"javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/contact.html','');\" STYLE='text-decoration: none'>"
		      +"<span class='footertab'>Contact</span></a>"
		      +"</p> "
           +" </div>"
          +" </td>"
        +" </tr>"
        +" <tr> " 
          +" <td colspan='2' height='18'>" 
           // +" <div align='center'><span class='footertab'>Copyright 2004. Desihub. All Rights Reserved </span></div> "
	   +" <div align='center'><span class='footertab'>Copyright 2004. "+EbeeConstantsF.get("application.name","Desihub")+". All Rights Reserved </span></div> "
          +"</td>"
        +" </tr>"
        +"<tr>" 
          +"<td height='19' valign='middle' align='center' width='100%'> " 
            +" <div align='right'></div>"
          +"</td>"
          +"<td height='19' valign='top' align='center' width='126'><a href='http://www.beeport.com' target='_blank'>"
	  	+"<img src='/home/images/poweredby_beeport.jpg' border='0' /></a>"
	  +" </td>"
        +" </tr> "
      +" </table> "
      +" </div> ";
      
      
%>





<%
List FOOTERList=new ArrayList();
FOOTERList.add("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/aboutus.html',''); STYLE='text-decoration: none'>About Us</a>");
FOOTERList.add("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/privacystatement.html',''); STYLE='text-decoration: none'>Privacy Statement</a>");
FOOTERList.add("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/termsofservice.html',''); STYLE='text-decoration: none'>Terms of Service</a>");
FOOTERList.add("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/trademarks.html',''); STYLE='text-decoration: none'>Trade Marks</a>");
FOOTERList.add("<a href=javascript:popupwindow('http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links/contact.html',''); STYLE='text-decoration: none'>Contact</a>");

String copyright="Copyright 2004. "+EbeeConstantsF.get("application.name","Desihub")+". All Rights Reserved";

String poweredby="<a href='http://www.beeport.com' target='_blank'><img src='/home/images/poweredby.jpg' border='0' /></a>";

String purpose=(String)request.getAttribute("purpose");
	request.setAttribute("FOOTER",FOOTER);//FOOTER
	request.setAttribute("FOOTERLIST",FOOTERList);//FOOTER
request.setAttribute("FOOTERPOWERDIMAGE",poweredby);//FOOTER
request.setAttribute("COPYRIGHT",copyright);//FOOTER
String IMGICON=EbeeConstantsF.get("application.name","desihub").toLowerCase()+"_icon.gif";



	List SIGNUPLINKS=new ArrayList();

	//SIGNUPLINKS.add(  "<a href='/portal/home.jsp?UNITID=13579'>Desihub</a>");
	SIGNUPLINKS.add(  "<a href='/portal/home.jsp'><img src='/home/images/logo_small.jpg' height=30 width=60  border='1'/></a>");

	String logurl="/portal/community.jsp";
	String loglabel="Login";
	 if(AuthUtil.getAuthData(pageContext)!=null){
	 loglabel="Logout";
	 logurl="/portal/community.jsp?logout=l";
	 //http://192.168.1.50:8080/portal/lifestyle/lifestyle.jsp?type=Snapshot&UNITID=13579

	 SIGNUPLINKS.add(  "<a href='/portal/lifestyle/lifestyle.jsp?type=Snapshot'>My Network</a>");
	 SIGNUPLINKS.add( "<a href='"+logurl+"'>"+loglabel+"</a>" );
	 }else{
	 	SIGNUPLINKS.add( "<a href='"+logurl+"'>"+loglabel+"</a>" );
		SIGNUPLINKS.add(	"<a href='/portal/signup/signup.jsp?isnew=yes&entryunitid=13579'>Signup</a>" );
	 }

	 // 'desihub', 'my snapshot' and 'logout' links.
	 
	 








List EVENTSIGNUPLINKS=new ArrayList();

//EVENTSIGNUPLINKS.add(  "<a href='/portal/home.jsp?UNITID=13579'>Desihub</a>");
EVENTSIGNUPLINKS.add(  "<a href='/portal/home.jsp'><img src='/home/images/"+IMGICON+"' /></a>");
         logurl="/portal/community.jsp";
	 loglabel="Login";
	 if(AuthUtil.getAuthData(pageContext)!=null){
		loglabel="Logout";
		logurl="/portal/community.jsp?logout=l";
		EVENTSIGNUPLINKS.add(  "<a href='/portal/myevents/myevents.jsp?type=events'>My Events</a>");
		EVENTSIGNUPLINKS.add( "<a href='"+logurl+"'>"+loglabel+"</a>" );
	 }else{

		EVENTSIGNUPLINKS.add( "<a href='"+logurl+"'>"+loglabel+"</a>" );
		EVENTSIGNUPLINKS.add(	"<a href='/portal/signup/signup.jsp?isnew=yes&entryunitid=13579'>Signup</a>" );
	 }
	 
	 

List PHOTOSIGNUPLINKS=new ArrayList();

//PHOTOSIGNUPLINKS.add(  "<a href='/portal/home.jsp?UNITID=13579'>Desihub</a>");
PHOTOSIGNUPLINKS.add(  "<a href='/portal/home.jsp'><img src='/home/images/"+IMGICON+"' /></a>");
         logurl="/portal/community.jsp";
	 loglabel="Login";
	 if(AuthUtil.getAuthData(pageContext)!=null){
		loglabel="Logout";
		logurl="/portal/community.jsp?logout=l";
		PHOTOSIGNUPLINKS.add(  "<a href='/portal/auth/listauth.jsp?purpose=addmyphotos'>My Photos</a>");
		PHOTOSIGNUPLINKS.add( "<a href='"+logurl+"'>"+loglabel+"</a>" );
	 }else{

		PHOTOSIGNUPLINKS.add( "<a href='"+logurl+"'>"+loglabel+"</a>" );
		PHOTOSIGNUPLINKS.add(	"<a href='/portal/signup/signup.jsp?isnew=yes&entryunitid=13579'>Signup</a>" );
	 }

	 if("event".equals(purpose))
		request.setAttribute("SIGNUPLINKS",EVENTSIGNUPLINKS);//loginlinks
	else if("Photos".equals(purpose))
		request.setAttribute("SIGNUPLINKS",PHOTOSIGNUPLINKS);//loginlinks
	else
		request.setAttribute("SIGNUPLINKS",SIGNUPLINKS);//loginlinks







List NAVLINKS=new ArrayList();

	NAVLINKS.add("<a href='/portal/lifestyle/lifestyleview.jsp' >Lifestyle</a>" );
	NAVLINKS.add("<a href='/portal/hub/clubsview.jsp' >"+EbeeConstantsF.get("club.label1","Communities")+"</a>");
	//NAVLINKS.add("<a href='/portal/classifieds/classifiedview.jsp?purpose=classified' >Classifieds </a>" );
	NAVLINKS.add("<a href='/portal/eventdetails/events.jsp?evttype=event' >Events </a>");
	//NAVLINKS.add("<a href='/portal/services/services.jsp' > Services </a>");
	//NAVLINKS.add("<a href='/portal/comments/logview.jsp' >Reviews </a>");
	
	NAVLINKS.add("<a href='/portal/photogallery/photosview.jsp' >Photos </a>");
	//NAVLINKS.add("<a href='/portal/news/news.jsp?UNITID=13579' >News </a>");
	
	
request.setAttribute("NAVLINKS",NAVLINKS);//headerLinks

%>



<%




List lifestylenav=new ArrayList();
if("Photos".equals(purpose)){
	
	lifestylenav.add("<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/network'>Network</a> " );   
	lifestylenav.add("<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/blog'>Community</a>"); 
	lifestylenav.add("<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/photos'>Photos</a>");
	//lifestylenav.add("<a href='/portal/auth/listauth.jsp?purpose=uploadphoto&UNITID=13579'>Manage Photos</a>" );
}else{


lifestylenav.add("<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/network'>Network</a>"); 
lifestylenav.add( "<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/blog'>Community</a>");

lifestylenav.add( "<a href='"+ShortUrlPattern.get((String)request.getAttribute("username"))+"/photos'>Photos</a>" );
  
//lifestylenav.add( "<a href='/portal/lifestyle/lifestyle.jsp?UNITID=13579'>Manage Snapshot</a>"); 

}

request.setAttribute("LIFESTYLENAVLINKS",lifestylenav);

%>



<%--
<%=request.getAttribute("SIGNUPLINKS")%>

<br/>
<%=request.getAttribute("NAVLINKS")%>
<br/>
<%=request.getAttribute("LIFESTYLENAVLINKS")%>
--%>

<%

String GOOGLE_TRAFIC_MONITOR="";
GOOGLE_TRAFIC_MONITOR="<script src='http://www.google-analytics.com/urchin.js' type='text/javascript'></script>"
		       +"<script type='text/javascript'>"
		       +"_uacct = '"+EbeeConstantsF.get("google.traffic.monitor.accno","")+"';"
		       +"urchinTracker();"
		       +"</script>";

request.setAttribute("GOOGLE_TRAFIC_MONITOR",GOOGLE_TRAFIC_MONITOR);
%>
