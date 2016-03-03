<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/Tokenizer.js">
        function dummy1() { }
</script>
<script>
function checkInvitationForm()
	{
				
		if (!document.invitationForm.fromname.value) {
		    
			alert('Please enter your name.');
			return false;
		}
		
			
		if (!document.invitationForm.fromemail.value) {
			
			alert('Please enter your email address.');
			return false;
		}
		
			
		if (!document.invitationForm.toemails.value) {
		    alert('Please enter a valid email address in the To: field.');
			return false;
		}
				
			
		if (!document.invitationForm.subject.value) {
			alert('Please enter a subject for your message.');
			return false;
		}
		
			
		if (!document.invitationForm.personalmessage.value) {
			alert('Please enter your message.');
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.invitationForm.fromemail.value)){
			alert('Your email address is not valid.');
			return false;
		}
		

		  var toemail=document.invitationForm.toemails.value;
		
			var tokens = toemail.tokenize(",", " ", true);
				

		for(var i=0; i<tokens.length; i++){
		   //alert(tokens[i]);
		  
			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
			  
				alert(tokens[i] + ' is not a valid email address.');
				return false;
			}
		}
		//return true;
		
		document.invitationForm.sendmsg.value="Sending...";
		  
		advAJAX.submit(document.getElementById("invitationForm"), {
		    onSuccess : function(obj) {
		    var restxt=obj.responseText;
		   if(restxt.indexOf("Error")>-1){
		  		       
		  		     document.getElementById('captchamsg').style.display='block';
		  		     document.invitationForm.sendmsg.value="Send";
		     }
		     else{
		    document.getElementById('message').innerHTML=restxt;
		    document.getElementById("Invitation").style.display = 'none'
		    document.invitationForm.sendmsg.value="Send";
		    document.invitationForm.fromemail.value='';
		    document.invitationForm.toheader.value='';
		    document.invitationForm.captcha.value='';
		  
		    document.invitationForm.fromname.value='';
		     document.getElementById('captchamsg').style.display='none';
		   
		   }
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});
		
	}


function checkAttendeeForm()
	{
			
		if (!document.AttendeeForm.from_email.value) {

			alert('Please enter your email address.');
			return false;
		}
		if (!document.AttendeeForm.from_name.value) {
		    
			alert('Please enter your name.');
			return false;
		}
		if (!document.AttendeeForm.subject.value) {
			alert('Please enter a subject for your message.');
			return false;
		}
		if (!document.AttendeeForm.note.value) {
			alert('Please enter your note.');
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.AttendeeForm.from_email.value)){
			alert('Your email address is not valid.');
			return false;
		}
				
		document.AttendeeForm.sendmgr.value="Sending...";
		  
		advAJAX.submit(document.getElementById("AttendeeForm"), {
		    onSuccess : function(obj) {
		    var restxt=obj.responseText;
		  if(restxt.indexOf("Error")>-1){
		  		  		     
		   document.getElementById('captchamsgmgr').style.display='block';
		    document.AttendeeForm.sendmgr.value="Send";
		   
		     }
		     else{
			document.getElementById('contactmgr').style.display='none';
			document.getElementById('urmessage').innerHTML="Email sent to event manager";
			document.AttendeeForm.sendmgr.value="Send";
			document.AttendeeForm.from_email.value='';
			document.AttendeeForm.from_name.value='';
			  document.AttendeeForm.captchamgr.value='';
		  
			document.getElementById('captchamsgmgr').style.display='none';

		 }
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});
		
	}





function Show(div)
	{
	
	        var currentDate = new Date()

		var theDiv = document.getElementById(div);
		if (theDiv.style.display == 'none') {
			theDiv.style.display = 'block';
			document.getElementById("message").innerHTML='';
			if(div=='Invitation')
			document.getElementById("captchaid").src="/captcha?fid=invitationForm&pt="+currentDate.getTime();
			else if(div=='contactmgr')
			document.getElementById("captchaidmgr").src="/captcha?fid=AttendeeForm&pt="+currentDate.getTime();
			else
			{}
			
			
			
		} 
		else
		theDiv.style.display = 'none'
	}
	
function Cancel(div)
{
var theDiv = document.getElementById(div);
theDiv.style.display = 'none';
}
</script>




















	
	











 


<script type="text/javascript" language="JavaScript" src="/home/js/popup.js">
        function dummy() {}
</script>




















<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">

<head profile="http://gmpg.org/xfn/1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="en">
<meta name="robots" content="index, follow">
<meta name="Keywords" content="online registration, registration software, online ticketing, event ticketing, eventbee" />

<title>Eventbee - Twiistup 6 at The Universal Hilton</title>


<link rel="stylesheet" type="text/css" href="http://www.eventbee.com/home/index.css" />

<style type="text/css">body {
background: #000000;
background-image:url('/home/images/twiistup/body01.jpg');
text-align: center;
padding: 0;
font: 62.5% verdana, sans-serif;
color: black;
}


#container {
margin: 0 auto;
text-align: left;
width: 845px;
color: black;
padding: 0px;
background: #FFFFFF;
}

#container a {
text-decoration: none;
color: Blue;
}

#navi {
align: right;
text-align: left;
width: 262px;
margin: 0px;
padding: 5px;
background: #FFFFFF;
}


#navi ul li {
margin: .2em 0 .4em .5em;
list-style: circle;
}

#navi a {
text-decoration: none;
color: Blue;
}

#navi .attendeelist ul {
margin: .2em 0 .4em .5em;
list-style: disc;
align: left;
}


#content {
align: left;
margin: 0px;
width: 535px;
border: 0;
padding: 5px;
background: #FFFFFF;
}


#content .f2fbox {
text-align: left;
padding-bottom: 10px;
border: 1px solid #AAAAAA;
}


#box {
align: left;
margin: 0px;
border: 0;
padding: 5px;
background: #cfc; 
border: 1px solid #cfc;
}

#ntsbox {
background: #cfc;
align: left;
margin: 0px;
border: 0;
padding: 5px;
font: normal 9px verdana;
color: Black;
}

#ntsbox a {
font-family: Verdana;
font-size: 9px;
color: Blue;
}

.large {
font: bold 22px verdana, sans-serif;
color: #333333;
}

.medium {
font: bold 20px verdana, sans-serif;
color: #333333;
}

.small {
font:  bold 15px verdana, sans-serif;
color: Black;
}

.txt {
font-family: Verdana;
font-size: 11px;
color: Blue;
}

.str {
line-height: 11px;
}

P, UL, LI, DIV, OL, TABLE, TD, TH {
font-family: verdana; 
font-size: 12px; 
line-height: 140%;
}

.maintable {  
background: #FFFFF; 
border:px; 
border:0px #AAAAAA solid; 
font-family: verdana; 
font-size: 12px; 
color: Black; 
}

td {border: #FFFFFF}


.portalback {
background1: #FFFFFF;
}

.taskheader {
background-color: #cfc;
border: 1px solid green;
padding: 5px;
color: Black;
}

.smallestfont {
font-family: Verdana, Arial, Helvetica, sans-serif; 
font-size: 10px;
font-weight: lighter; 
color: #666666;
}
header{
  width: 845px;
  text-align: center;
  valign: top;
  padding: 0;
}

ul.speakers li {margin-bottom: 8px;}

ul.NoBullet {
  list-style-type: none;}</style>

</head>

<body>
<div align="center">



<style>
#header{
background: #000000;
align: center;
  width: 845px;
  float: center;
  text-align: center;
  valign: middle;
 }
ul.nav {  width:536px; height:60px; position:absolute; top:0; right:0 }
ul.nav li a { display:block; position:absolute; top:0; text-indent:-9999px; outline:none; border:none; height:60px }
ul.nav li a:hover { border:none }

li.navHome a, li.navGetIn a, li.navWhosIn a, li.navBlog a, li.navShowoffs a, li.navSponsor a { background:url(/home/images/twiistup/nav03.gif) }



li.navHome a 							{ background-position:0 0; width:67px; left:75px }
li.navHome a:hover						{ background-position:0 -60px }

li.navGetIn a 							{ background-position:-67px 0; width:81px; left:135px }
li.navGetIn a:hover						{ background-position:-67px -60px }


li.navBlog a 							{ background-position:-260px 0; width:68px; left:220px }
li.navBlog a:hover						{ background-position:-260px -60px }

li.navShowoffs a 						{ background-position:-328px 0; width:107px; left:285px }
li.navShowoffs a:hover					{ background-position:-328px -60px }

li.navSponsor a 						{ background-position:-435px 0; width:86px; left:395px }
li.navSponsor a:hover					{ background-position:-435px -60px }

div.header1 { width:845px; height:60px; align: center; background:url(/home/images/twiistup/header01.jpg); background-repeat:no-repeat }
div.header1 div { margin:0 auto; padding:0 0 0 10px; width:950px; /* 960px - 10px padding = 950px */ }
h1 a { display:block; background:url(/home/images/twiistup/h1.gif) top left no-repeat; width:149px; height:41px; text-indent:-9999px; position:absolute; top:25px; left:90px }

</style>


<div id="header">

		<div class="header1">
			<div>
				<h1><a href="http://www.twiistup.com/" >Twiistup Los Angeles Tech Events | Twiistup 6 | July 30 + 31 | Universal City</a></h1>


				<ul class="nav">
					<li class="navHome">
						<a href="http://twiistup.com/" title="Home">Home</a>
					</li>
					<li class="navGetIn">
						<a href="http://www.eventbee.com/view/twiistup6" title="Get in">Get in</a>
					</li>

					<li class="navBlog">
						<a href="http://twiistup.com/blog/" title="Blog">Blog</a>
					</li>
					<li class="navShowoffs">
						<a href="http://twiistup.com/showoffs/" title="Showoffs">Showoffs</a>
					</li>
					<li class="navSponsor">
						<a href="http://twiistup.com/sponsor/" title="Sponsor">Sponsor</a>

					</li>

				</ul><!-- .nav -->
			</div>
		</div><!-- .header -->

<br>


</div>
</div>

<div id="container">
<br/>
<div class="large" align="center">
<table cellpadding="10" width="100%"><tr><td width="100%" align="left">
 <span class="large">Twiistup 6 at The Universal Hilton</span><br/>
    <!-- AddThis Bookmark Button BEGIN -->
    <div>
    <script type="text/javascript">
    addthis_url    = location.href;
    addthis_title  = document.title;
    addthis_pub    = 'eventbee';
    </script><script type="text/javascript"
    src="http://s7.addthis.com/js/addthis_widget.php?v=12"></script>
</td>
<td align="right" width="27%">

  </td>
</tr></table>
</div>
<br/>

<table width="100%" valign="top">
<tr>

<!-- start: left column -->

<td id="content" valign="top">

<!-- start: registration block -->

      <div id="box">

      <table width="100%">
         <tr><td width="100%">
    	 <div class="medium">Registration <a href='/event/register?eventid=59337&isnew=yes'><img src='/home/images/eventbeecc.gif'  border='0'/></a></div>
    	 </td></tr>
                  <tr>
         <td width="100%"><b>Twiistup 6 Full Event Pass with Evening Mixer  - </b>
          <b>$297.00</b>

                  <br/><span class="smallestfont">Available Jun 21 - Jul 29</span>
         <br/>Event pass for the full two-day event including the open bar evening mixer.  If you want to meet the speakers and experience everything Twiistup has to offer, you'll want to come for the full program. 
         </td>
         </tr><tr><td height="5"/></tr>
                  <tr>
         <td width="100%"><b>Twiistup 6 Evening Mixer Only - </b>
          <b>$79.00</b>
                  <br/><span class="smallestfont">Available Jun 07 - Jul 29</span>

         <br/>Ticket for the classic Twiistup open-bar EVENING MIXER ONLY.  The evening event takes place Thursday July 30th from 7:00-Midnight. 
         </td>
         </tr><tr><td height="5"/></tr>
         

                  <tr><td align="left">
                  <form name='register' action='/event/register?eid=59337' method='post' /><input type='hidden' name='GROUPID' value='59337' /><input type='hidden' name='eventid' value='59337' /><input type='hidden' name='participant' value='null'/><input type='hidden' name='friendid' value='null'/><input type='hidden' name='code' value='null'/><input type='hidden' name='newreq' value='yes'/><input type='submit' name='submit' value='Register Here - Select Ticket Type On Next Page'/></form>
                  </td></tr>
      </table>
   </div>
   <br/>

   


   

<!-- end: registration block -->

<!-- start: description block -->

<div id="box" align="left">
   <table width="100%">
      <tr><td>
      
      </td></tr>
      <tr><td>
      <p><meta content="text/html; charset=utf-8" http-equiv="Content-Type"/><meta content="Word.Document" name="ProgId"/><meta content="Microsoft Word 11" name="Generator"/><meta content="Microsoft Word 11" name="Originator"/><link href="file:///C:%5CUsers%5Ckumar%5CAppData%5CLocal%5CTemp%5Cmsohtml1%5C01%5Cclip_filelist.xml" rel="File-List"/><!--[if gte mso 9]><xml>
 
  Normal
  0
  
  
  false
  false
  false
  
   
   
   
   
   
  
  MicrosoftInternetExplorer4
 
</xml><![endif]--><!--[if gte mso 9]><xml>
 
 
</xml><![endif]--><!--[if !mso]><object
 classid="clsid:38481807-CA0E-42D2-BF39-B33AF135CC4D" id=ieooui></object>
<style>
st1\:*{behavior:url(#ieooui) }
</style>
<![endif]--><style type="text/css">
&lt;!--
 /* Font Definitions */
 @font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-1593833729 1073750107 16 0 415 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
h3
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	mso-pagination:widow-orphan;
	mso-outline-level:3;
	font-size:13.5pt;
	font-family:"Times New Roman";
	font-weight:bold;}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;
	text-underline:single;}
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:1998151019;
	mso-list-template-ids:-84214304;}
@list l0:level1
	{mso-level-number-format:bullet;
	mso-level-text:&#61623;;
	mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--&gt;
</style><!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:"Table Normal";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0in 5.4pt 0in 5.4pt;
	mso-para-margin:0in;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-ansi-language:#0400;
	mso-fareast-language:#0400;
	mso-bidi-language:#0400;}
</style>
<![endif]-->

<p>Join us for
the biggest Twiistup ever. Twiistup has expanded with a two-day stage program
that brings together innovators in technology and media. The classic open-bar
evening mixer will continue, but attendees are encouraged to attend the full
conference to experience this unique program.</p>

<h3>The Full Event program starts
at 9:30 AM Thursday July 30th.</h3>

<h3>Confirmed speakers for the
day program include:</h3>

<ul type="disc"><li><b>Jason Calacanis</b> Serial
     entrepreneur, founder of Mahalo and co-founder of TechCrunch 50 and
     Weblogs.&nbsp;<a href="http://en.wikipedia.org/wiki/Jason_Calacanis">Wikipedia Link</a></li><li><b>James Montgomery</b>&nbsp;CEO of
     Montgomery &amp; Co. and CEO of Digital
      Coast Ventures,
     Founder of Palomar Ventures.&nbsp;<a href="http://monty.com/pages/team/team.aspx?teamid=3&amp;sector=None&amp;name=James%20Montgomery">Bio Link</a></li><li><b>Michael Jones </b>COO of MySpace,
     founder of Userplane and Tsavo <a href="http://en.wikipedia.org/wiki/Michael_Jones_%28Internet_entrepreneur%29">Wikipedia Link</a></li><li><b>Brooke Burke</b>&nbsp;(former)
     Television Host of Wild On E!, Rockstar INXS, and online entrepreneur,
     co-CEO of www.ModernMom.com&nbsp;<a href="http://en.wikipedia.org/wiki/Brooke_Burke">Wikipedia Link</a></li><li><b>Chamillionaire</b>&nbsp;Grammy
     Award-winning and chart topping musician and entrepreneur.&nbsp;<a href="http://en.wikipedia.org/wiki/Chamillionaire">Wikipedia Link</a></li><li><b>Cyan Banister</b>&nbsp;Early stage
     investor in Facebook, Slide, Tagged and founder of TopFans.com and Zivity.</li><li><b>Brad Feld</b>&nbsp;Co-founder
     of Foundry Group and Mobius Venture Capital, founder of Techstars.org
     startup incubator.&nbsp;<a href="http://www.techstars.org/mentors/bfeld/">Bio Link</a></li><li><b>Quincy</b><b> Jones III (QD3)</b>&nbsp;Music and
     film producer/entrepreneur.&nbsp;<a href="http://en.wikipedia.org/wiki/Quincy_Jones_III">Wikipedia Link</a></li><li><b>Dave McClure</b>&nbsp;Seed stage
     investor for the Founders Fund.&nbsp;<a href="http://500hats.typepad.com/500blogs/about-dave-mcclure.html">Bio Link</a></li><li><b>Ian Rogers</b>&nbsp;Former
     business partner of the Beastie Boys and former GM of Yahoo Music, now CEO
     of Topspin Media.&nbsp;<a href="http://www.crunchbase.com/person/ian-rogers">Bio Link</a></li><li><b>Andy Sack </b>General Partner
     at Founders Co-op, Founder of Kefta, Abuzz and Firefly Network <a href="http://www.crunchbase.com/person/andy-sack">Bio Link</a></li><li><b>Ben Huh</b>&nbsp;CEO of
     viral phenomenon&nbsp;<a href="http://www.IcanHasCheezburger.com">www.IcanHasCheezburger.com</a>.</li><li><b>Justin Kan</b>&nbsp;Founder of
     Justin.TV the largest online community for people to broadcast, watch and
     interact around live video.&nbsp;<a href="http://en.wikipedia.org/wiki/Justin.tv">Wikipedia Link</a></li><li><b>Chris Brogan</b>&nbsp;President
     of New Marketing Labs</li><li><b>Mark Suster</b>&nbsp;GRP
     Partners, venture capital. Former VP Product Mgmt Salesforce.com &amp;

     2-time CEO and entrepreneur.&nbsp;<a href="http://www.grpvc.com/team.php?screen=PARTNERS&amp;team=29">Bio Link</a></li><li><b>Brian Solis</b>&nbsp;Author of
     Now is Gone and Putting the Public Back in Public Relations, Publisher of
     PR 2.0 and bub.blicio.us, Founder of Future Works PR, and strategic
     advisor to Fortune 500 businesses and startups.&nbsp;<a href="http://en.wikipedia.org/wiki/Brian_Solis">Wikipedia Link</a></li><li><b>David O. Sacks</b>&nbsp;Former COO
     of PayPal, founder and CEO of Geni.com and Yammer, movie producer Thank
     You For Smoking.&nbsp;<a href="http://en.wikipedia.org/wiki/David_O._Sacks">Wikipedia Link</a></li><li><b>Dmitry Shapiro</b>&nbsp;Founder and
     CEO of Veoh Networks, founder of Akonix Systems and Weekend University.&nbsp;<a href="http://www.veoh.com/corporate/team">Bio Link</a></li><li><b>Lisa Rosenblatt</b>&nbsp;Co-founder
     of iMall (sold for $565 million) and co-CEO of <a href="http://www.ModernMom.com">www.ModernMom.com</a>.</li><li><b>Taryn Southern </b>First person (of
     only 3 total) to sell a scripted online web show to mainstream TV (MTV) <a href="http://en.wikipedia.org/wiki/Taryn_Southern">Wikipedia Link</a></li><li><b>Micah Baldwin</b>&nbsp;Founder of
     Current Wisdom (sold 2007), VP of Business Development and Chief
     Evangelist for Lijit Networks.&nbsp;<a href="http://learntoduck.com/about">Bio Link</a></li><li><b>Plus Moderators, Marsha
     Collier&nbsp;</b>KTRB Radio<b>, Jason Nazar&nbsp;</b>CEO of DocStoc<b>, Sean
     Percival&nbsp;</b>of Lalawag and Tsavo<b>&nbsp;and Adam Weinroth&nbsp;</b>of
     Demand Media</li></ul>

<div><b>&nbsp;</b></div>

<p><b>Twiistup
Event Schedule</b></p>

<p><b>THURSDAY
July 30</b><b><sup>th</sup></b></p>

<p><b>9:30 AM
-&nbsp;Welcome/Intro</b></p>

<p><b>9:45&nbsp;-10:45
Showoffs&nbsp;(BakeSpace, BantamLive, Diddit, Educator, EQAL, ExpenseBay)</b>&nbsp;pitches and
Q&amp;A on stage (with Showoff Judges)</p>

<p><b>10:45 &ndash;
11:30&nbsp;Incubators and new trends in early stage investing&nbsp;</b>(Dave McClure, Andy
Sack and Brad Feld)</p>

<p>11:30 &ndash; 11:45
Break</p>

<p><b>11:45 &ndash; 12:45
Showoffs&nbsp;(JamLegend, Mobophiles, PeopleBrowsr, Streamy, Uservoice, Final
Pick TBD)</b>&nbsp;pitches and Q&amp;A on stage (with Showoff Judges)</p>

<p><b>12:45 &ndash;
1:15&nbsp;Getting your Startup Noticed</b>&nbsp;(Brian Solis)</p>

<p>1:15 &ndash; 2:30
LUNCH</p>

<p><b>2:35 &ndash;
3:15&nbsp;Future Trends in Online Video</b>&nbsp;(Dmitry Shapiro, Justin Kan and Taryn
Southern)</p>

<p><b>3:15&ndash;
4:00&nbsp;Crossing the Mainstream/Online Divide</b>&nbsp;(Brooke Burke w/
Lisa Rosenblatt) (moderated by Adam Weinroth of Demand Media)</p>

<p><b>4:00 &ndash;
5:00&nbsp;Music and Technology</b>&nbsp;(Chamillionaire, Ian Rogers, and QD3)</p>

<p>DINNER
BREAK&nbsp;</p>

<p><b>7:00 &ndash;
MIDNIGHT&nbsp;The</b> <b>Twiistup Evening Open Bar party 80s Tech Prom</b></p>

<p><b>FRIDAY
July 31</b><b><sup>st</sup></b></p>

<div><b>9:30&nbsp;Introductions</b></div>

<p><b>9:45 &ndash;
10:30&nbsp;Leveraging the Social Web</b>&nbsp;(Chris Brogan, Ben Huh and Micah
Baldwin) (moderated by Sean Percival)</p>

<p><b>10:30 &ndash;
11:15&nbsp;The (LA) Startup ecosystem - money, talent, benefits and challenges
outside of Silicon Valley</b>&nbsp;(Mark Suster,
David O. Sacks, Michael Jones and James Montgomery)</p>

<p><b>11:15 &ndash;
11:45&nbsp;Investing and marketing based on the 7 Deadly Sins</b>&nbsp;(Cyan Banister -
early investor in Facebook, Paypal, Slide etc)</p>

<p>11:45 - 12:30
Short Brunch</p>

<p><b>12:30 &ndash;
2:00&nbsp;Jason Calacanis and guest &ndash; This Week in Startups Live</b></p>

<b>2:00&nbsp;Conference
Ends</b>Join us for the biggest Twiistup ever. Twiistup has expanded with a two-day stage program that brings together innovators in technology and media. The classic open-bar evening mixer will continue, but attendees are encouraged to attend the full conference to experience this unique program.</p><h3>The Full Event program starts at 9:30 AM Thursday July 30th.</h3><h3>Confirmed speakers for the day program include:</h3><ul class="speakers"><li><strong>Jason Calacanis</strong> Serial entrepreneur, founder of Mahalo and co-founder of TechCrunch 50 and Weblogs. <a href="http://en.wikipedia.org/wiki/Jason_Calacanis">Wikipedia Link</a> </li><li><strong>James Montgomery</strong> CEO of Montgomery &amp; Co. and CEO of Digital Coast Ventures, Founder of Palomar Ventures. <a href="http://monty.com/pages/team/team.aspx?teamid=3?or=None&amp;name=James%20Montgomery">Bio Link</a> </li><li><strong>Brooke Burke</strong> (former) Television Host of Wild On E!, Rockstar INXS, and online entrepreneur, co-CEO of www.ModernMom.com <a href="http://en.wikipedia.org/wiki/Brooke_Burke">Wikipedia Link</a> </li><li><strong>Chamillionaire</strong> Grammy Award-winning and chart topping musician and entrepreneur. <a href="http://en.wikipedia.org/wiki/Chamillionaire">Wikipedia Link</a> </li><li><strong>Cyan Banister</strong> Early stage investor in Facebook, Slide, Tagged and founder of TopFans.com and Zivity. </li><li><strong>Brad Feld</strong> Co-founder of Foundry Group and Mobius Venture Capital, founder of Techstars.org startup incubator. <a href="http://www.techstars.org/mentors/bfeld/">Bio Link</a> </li><li><strong>Quincy Jones III (QD3)</strong> Music and film producer/entrepreneur. <a href="http://en.wikipedia.org/wiki/Quincy_Jones_III">Wikipedia Link</a> </li><li><strong>Dave McClure</strong> Seed stage investor for the Founders Fund. <a href="http://500hats.typepad.com/500blogs/about-dave-mcclure.html">Bio Link</a> </li><li><strong>Ian Rogers</strong> Former business partner of the Beastie Boys and former GM of Yahoo Music, now CEO of Topspin Media. <a href="http://www.crunchbase.com/person/ian-rogers">Bio Link</a> </li><li><strong>Ben Huh</strong> CEO of viral phenomenon <a href="http://www.IcanHasCheezburger.com">www.IcanHasCheezburger.com</a>. </li><li><strong>Justin Kan</strong> Founder of Justin.TV the largest online community for people to broadcast, watch and interact around live video. <a href="http://en.wikipedia.org/wiki/Justin.tv">Wikipedia Link</a> </li><li><strong>Chris Brogan</strong> President of New Marketing Labs </li><li><strong>Mark Suster</strong> GRP Partners, venture capital. Former VP Product Mgmt Salesforce.com &amp; 2-time CEO and entrepreneur. <a href="http://www.grpvc.com/team.php?screen=PARTNERS&amp;team=29">Bio Link</a> </li><li><strong>Brian Solis</strong> Author of Now is Gone and Putting the Public Back in Public Relations, Publisher of PR 2.0 and bub.blicio.us, Founder of Future Works PR, and strategic advisor to Fortune 500 businesses and startups. <a href="http://en.wikipedia.org/wiki/Brian_Solis">Wikipedia Link</a> </li><li><strong>David O. Sacks</strong> Former COO of PayPal, founder and CEO of Geni.com and Yammer, movie producer Thank You For Smoking. <a href="http://en.wikipedia.org/wiki/David_O._Sacks">Wikipedia Link</a> </li><li><strong>Dmitry Shapiro</strong> Founder and CEO of Veoh Networks, founder of Akonix Systems and Weekend University. <a href="http://www.veoh.com/corporate/team">Bio Link</a> </li><li><strong>Lisa Rosenblatt</strong> Co-founder of iMall (sold for $565 million) and co-CEO of www.ModernMom.com. </li><li><strong>Micah Baldwin</strong> Founder of Current Wisdom (sold 2007), VP of Business Development and Chief Evangelist for Lijit Networks. <a href="http://learntoduck.com/about">Bio Link</a></li><li class="MsoNormal" style="margin: 0in 0in 6pt; line-height: 12pt; color: black;"><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; font-size: 9pt;">Plus Moderators, Marsha Collier </span></b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; font-size: 9pt;">KTRB Radio<b>, Jason Nazar </b>CEO of DocStoc<b>, Sean Percival </b>of Lalawag and Tsavo<b> and Adam Weinroth </b>of Demand Media</span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; font-size: 9pt;"><p></p></span></li></ul><p class="MsoNormal" style="margin: 0in 0in 10pt;"><b style=""><span style="line-height: 115%; font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; font-size: 13.5pt;">Twiistup Event Schedule<p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">THURSDAY July 30<sup>th</sup><p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">9:30 AM -<span class="apple-converted-space">&nbsp;</span>Welcome/Intro<p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">9:45<span class="apple-converted-space">&nbsp;</span>-10:45 Showoffs<span class="apple-converted-space">&nbsp;</span>(BakeSpace, BantamLive, Diddit, Educator, EQAL, ExpenseBay)</span></b><span class="apple-converted-space"><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;</span></span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">pitches and Q&amp;A on stage (with Showoff Judges)<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">10:45 &ndash; 11:30<span class="apple-converted-space">&nbsp;</span>Incubators and new trends in early stage investing<span class="apple-converted-space">&nbsp;</span></span></b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">(Dave McClure and Brad Feld)<p></p></span></p><p></p><p></p><p></p><p></p><p><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">11:30 &ndash; 11:45 Break<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">11:45 &ndash; 12:45 Showoffs<span class="apple-converted-space">&nbsp;</span>(JamLegend, Mobophiles, PeopleBrowsr, Streamy, Uservoice, Final Pick TBD)</span></b><span class="apple-converted-space"><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;</span></span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">pitches and Q&amp;A on stage (with Showoff Judges)<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">12:45 &ndash; 1:15&nbsp;Getting your Startup Noticed</span></b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;(Brian Solis)<p></p></span></p><p></p><p></p><p></p><p></p><p><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">1:15 &ndash; 2:30 LUNCH<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">2:35 &ndash; 3:15&nbsp;Future Trends in Online Video</span></b><span class="apple-converted-space"><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;</span></span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">(Dmitry Shapiro and Justin Kan)<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">3:15&ndash; 4:00&nbsp;Crossing the Mainstream/Online Divide</span></b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;"> (Brooke Burke w/ Lisa Rosenblatt) (moderated by Adam Weinroth of Demand Media)<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">4:00 &ndash; 5:00<span class="apple-converted-space">&nbsp;</span>Music and Technology</span></b><span class="apple-converted-space"><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;</span></span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">(Chamillionaire, Ian Rogers, and QD3)<p></p></span></p><p></p><p></p><p></p><p></p><p><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">DINNER BREAK&nbsp;<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">7:00 &ndash; MIDNIGHT<span class="apple-converted-space">&nbsp;</span>The Twiistup Evening Open Bar party<p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">FRIDAY July 31<sup>st</sup><p></p></span></b></p><p></p><p></p><p></p><p></p><p><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">Breakfast encouraged no lunch break today<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">9:30<span class="apple-converted-space">&nbsp;</span>Introductions<p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">9:45 &ndash; 10:30<span class="apple-converted-space">&nbsp;</span>Leveraging the Social Web</span></b><span class="apple-converted-space"><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;</span></span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">(Chris Brogan, Ben Huh and Micah Baldwin) (moderated by Sean Percival)<p></p></span></p><p></p><p></p><p></p><p></p><p><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;"><p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">10:30 &ndash; 11:15<span class="apple-converted-space">&nbsp;</span>The (LA) Startup ecosystem - money, talent, benefits and challenges outside of Silicon Valley</span></b><span class="apple-converted-space"><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;</span></span><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">(Mark Suster, David O. Sacks and James Montgomery)<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">11:15 &ndash; 11:45<span class="apple-converted-space">&nbsp;</span>Investing and marketing based on the 7 Deadly Sins</span></b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">&nbsp;(Cyan Banister - early investor in Facebook, Paypal, Slide etc)<p></p></span></p><p></p><p></p><p></p><p></p><p><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">11:45 - 12:30 Short Brunch<p></p></span></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">12:30 &ndash; 2:00<span class="apple-converted-space">&nbsp;</span>Jason Calacanis and guest &ndash; This Week in Startups Live<p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">2:00<span class="apple-converted-space">&nbsp;</span>Conference Ends<p></p></span></b></p><p></p><p></p><p></p><p></p><p><b><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; color: black; font-size: 10pt;">Even with only two weeks to opening day more great speakers keep joining the line up so expect us to pack even more into the final schedule.<p></p></span></b></p><p></p><p></p><p></p><p></p><p class="MsoNormal" style="margin: 0in 0in 10pt; line-height: normal;"><b style=""><span style="font-family: &quot;Verdana&quot;,&quot;sans-serif&quot;; font-size: 13.5pt;"><p>&nbsp;</p></span></b></p><p>&nbsp;</p><p></p><p>&nbsp;</p><p></p><p></p>

      </td></tr></table>
</div>
</td>

<!-- end: description block -->

<!-- start: right column -->

<td id="navi" valign="top">

<!-- start: when and where -->

   <div id="box" align="left">
      <table width="100%">

      <tr>
      <td width="100%" valign="top">
      <div class="medium">When</div>
                        Thu, Jul 30, 2009, 09:30 AM <span class="smallestfont">Start</span><br/>
	 	        Fri, Jul 31, 2009, 02:00 PM <span class="smallestfont">End</span>
               <br/><img src="http://www.eventbee.com/home/images/addcal.png" border="0"/> <a  href=javascript:Show('calendarlinks')>Add to my calendar</a> <div id='calendarlinks' style='display: none; margin: 10 5 10 5;'>  <a href=javascript:popupwindow('http://images.eventbee.com/images/vcal/vcal_event_59337.ics','VCal','400','400') ><img src='/home/images/ical.png' alt='iCal'  border='0' />&nbsp;iCal</a> <br>  <a href='http://www.google.com/calendar/event?action=TEMPLATE&text=Twiistup+6+at+The+Universal+Hilton&dates=20090730T093000/20090731T140000&sprop=website:http://www.eventbee.com&details=&location=Universal+City&trp=true' target='_blank'><img src='/home/images/google.png' alt='Google'  border='0' />&nbsp;Google</a> <br>  <a href='http://calendar.yahoo.com/?v=60&DUR=2830&TITLE=Twiistup+6+at+The+Universal+Hilton&ST=20090730T093000&ET=20090731T140000&in_loc=Universal+City&DESC=' target='_blank'><img src='/home/images/yahoo.png' alt='Yahoo'  border='0' />&nbsp;Yahoo!</a> </div>

      
      </td></tr>
      <tr>
      <td width="100%" valign="top">
      <div class="medium">Where</div>
          Universal Hilton<br/>
	  555 Universal Hollywood Drive<br/>
	  Universal City, CA, USA<br/>

	          
      </td></tr></table>
   </div>
   <br/>

<!-- end: when and where -->

<!-- start: network ticket selling -->


<!-- end: network ticket selling -->

<!-- start: event links -->

<div id="box" align="left" >

   <table width="100%"><tr><td>
           <!--          <li><a href='http://twiistup_events.eventbee.com/network' >Listed by Twiistup Events</a></li>
                     <li><a href='http://twiistup_events.eventbee.com/events' >View other events by Twiistup Events</a></li>
            -->
               <li><a  href=javascript:Show('contactmgr')>Hosted by Twiistup Events</a> <div id='contactmgr' style='display: none; margin: 10 5 10 5;'>  <form name='AttendeeForm'  id='AttendeeForm' action='/portal/emailprocess/emailtoevtmgr.jsp?UNITID=13579&id=59337&purpose=CONTACT_EVENT_MANAGER'  method='post' > Your Email ID* :<br>  <input type='text' name='from_email' value=''  style='width: 200px;'><br><br> Your Name* :  <br> <input type='text' name='from_name' value=''  style='width: 200px;'><br><br>  Subject :<br>  <input type='text' name='subject' value='Re: Twiistup 6 at The Universal Hilton' style='width: 200px;'><br><br>  Message :<br>  <textarea name='note' style='width: 210px; height: 75px;'></textarea><br><br>  <p align='center'>  <div id='captchamsgmgr' style='display: none; color:red' >Enter Correct Code</div> Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captchamgr'  value=''   valign='top'/>  <img  id='captchaidmgr'  alt='Captcha'  /></div><br><br><input type='hidden' name='formnamemgr' value='AttendeeForm'/> <input type='button' name='sendmgr' value='Send'  onClick=' return checkAttendeeForm()' />  <input type='button' value='Cancel' onclick=javascript:Cancel('contactmgr'); /> </p> </form> </div> <div id='urmessage'></div></li>

                     <li><a  href=javascript:Show('Invitation')>Email this to a friend</a> <div id='Invitation' style='display: none; margin: 10 5 10 5;'>  <form name='invitationForm'  id='invitationForm' action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id=59337&purpose=INVITE_FRIEND_TO_EVENT'  method='post' ><input type='hidden' name='url' value='http://twiistup_events.eventbee.com/event?eventid=59337' /> To* :<br>  <textarea id='toheader' name='toemails' style='width: 210px; height: 70px;'></textarea><br>(separate emails with commas)  <br><br>  Your Email ID* :<br>  <input type='text' name='fromemail' value=''  style='width: 200px;'><br><br> Your Name* :  <br> <input type='text' name='fromname' value=''  style='width: 200px;'><br><br>  Subject :<br>  <input type='text' name='subject' value='Fw: Twiistup 6 at The Universal Hilton' style='width: 200px;'><br><br>  Message :<br>  <textarea name='personalmessage' style='width: 210px; height: 75px;'>Hi,

I thought you might be interested in - Twiistup 6 at The Universal Hilton
Here is the listing URL: http://twiistup_events.eventbee.com/event?eventid=59337

Thanks</textarea><br><br>  <p align='center'>  <div id='captchamsg' style='display: none; color:red' >Enter Correct Code</div> Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captcha'  value=''   valign='top'/>  <img  id='captchaid'  alt='Captcha'  /></div><br><br><input type='hidden' name='formname' value='invitationForm'/> <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' />  <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); /> </p> </form> </div> <div id='message'></div></li>

                      <li><a href=javascript:Show('eventurl') >Event URL</a><div id='eventurl' style='display: none; align='right' width='200 'margin: 10 5 10 5;><textarea  cols='27' rows='2' onClick='this.select()'>http://twiistup6.eventbee.com</textarea></div></li>
                  
       </td></tr>
   </table>
</div>

<!-- end: event links -->


<!--start: attendee list-->



<!--end: attendee list-->

<!-- Start: noticeboard -->


<!--end: notice board-->

<!--start: recommended events-->

 
<!--end: recommended events-->

</td>

<!-- end:right column -->

</tr>

</table>
</div>

<div align="center">
   <div  id='footer' ><table width='840' align='center' cellpadding='5'><tr><td align='right' valign='middle' width='25%'><a href='http://www.eventbee.com'><img src='/home/images/poweredby.jpg' border='0'/></a></td><td align='left' valign='middle'><p><span class='smallestfont'>Powered by Eventbee - Your Online Registration, Event Promotion and Membership Management solution.<br/>For more information, please call (408) 310 6768, or send email to support at eventbee.com</span></p></td></tr></table></div>
</div>

</body>
</html>
		


