<%@ page import="java.util.*,java.text.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%> 
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%!

HashMap getpartnerdetails(String participant){
HashMap hm=new HashMap();
DBManager dbmanager=new DBManager();
StatusObj sb=dbmanager.executeSelectQuery("select userid,getMemberName(userid||'') as username,getMemberPref(userid||'','pref:myurl','') as loginname,getMemberMainPhoto(userid||'') as photourl from group_partner where partnerid=? and status='Active'",new String[]{participant});
if(sb.getStatus()){
hm.put("loginname",dbmanager.getValue(0,"loginname",""));
hm.put("username",dbmanager.getValue(0,"username",""));
}
return hm;
}



%>
<%

HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
String groupid=(String)request.getAttribute("GROUPID");
String particpantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
HashMap user=(HashMap)request.getAttribute("userhm");
//String event_link=null;
String loginname=null;
if(user!=null)
loginname=(String)user.get("login_name");
if (particpantid!=null){
	try{
			particpantid=Integer.parseInt(particpantid)+"";
	}catch(Exception e){
			particpantid=null;
	}
}

Vector agentsinfo=null;
Vector topsellers=null;
Vector agentsettings=null;
String participantname=null;
String particpantstitle=null;
String particpantsmessage=null;
String participantsphoto=null;
String groupheader="";
HashMap agentDetails=null;
String goalamount="0";
String display=null;
String showgoalreachimage="no";
String goalreachgraph="";
String f2fTagline=null,f2fimage="";
String setid="0";
String saleslimit="0";
String event_link=null;
String enableparticipant=DbUtil.getVal("select 'yes' from group_agent_settings a,group_agent b where a.settingid=b.settingid and a.groupid=? and b.agentid=? and a.enableparticipant='Yes' and b.customised='Yes'",new String[]{groupid,particpantid});
String isf2fenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {groupid});

if("yes".equalsIgnoreCase(isf2fenabled)&&request.getParameter("participant")==null){
agentsinfo=EventsContent.getAllAgents(groupid);
}

if((particpantid!=null)&&!"yes".equals(enableparticipant)){
	agentsinfo=EventsContent.getAllAgents(groupid);
}	
request.setAttribute("GROUP_AGENTS_INFO",agentsinfo);


StringBuffer selectagents=null;


/*Vector vect=new Vector();
agentsettings=EventsContent.getAgentSettings(vect,groupid);
HashMap hash=new HashMap(); 
for(int i=0;i<agentsettings.size();i++)
hash=(HashMap)agentsettings.elementAt(i);
String showagents=GenUtil.getHMvalue(hash,"showagents","");
saleslimit=GenUtil.getHMvalue(hash,"saleslimit","");
setid=GenUtil.getHMvalue(hash,"settingid",null);
if((particpantid==null)||((particpantid!=null)&&!"yes".equals(enableparticipant))){
	if ("Yes".equalsIgnoreCase(showagents)){
		if(agentsinfo!=null&&agentsinfo.size()>0){
			topsellers=new Vector();
			for(int i=0;i<agentsinfo.size();i++){
			HashMap hm1=(HashMap)agentsinfo.get(i);
			String str="<a href='"+ShortUrlPattern.get(GenUtil.getHMvalue(hm1,"loginname",""))+"/event?eventid="+groupid+"&participant="+GenUtil.getHMvalue(hm1,"agentid","")+"'>"+(String)hm1.get("username")+"</a>";
			groupheader=GenUtil.getHMvalue(hash,"header","");
			topsellers.add(str);
			}
		}

	}
}
*/
/*
String agentinfoq="select title,message,goalamount,showsales from group_agent where agentid=? and settingid=?";
String settingid=DbUtil.getVal("select settingid from group_agent_settings where groupid=?",new String[]{groupid});
HashMap partnerdetails=getpartnerdetails(particpantid);
if(agentsinfo!=null&&agentsinfo.size()>0){
	selectagents=new StringBuffer();
	selectagents.append("<form name='agents' >");
	selectagents.append("<input type='hidden' name='eventid' value='"+groupid+"' />");
	selectagents.append("<select name='participant' onChange='getAgentsPage(\""+loginname+"\")' >");
	selectagents.append("<option value='' >---Select Participant---</option>");
	for(int i=0;i<agentsinfo.size();i++){
	HashMap agentmap=(HashMap)agentsinfo.elementAt(i);
	selectagents.append("<option value='"+(String)agentmap.get("agentid")+"' >"+(String)agentmap.get("username")+"</option>");
	}
	selectagents.append("</select>");
	selectagents.append("</form>");
}
if(particpantid!=null){
	//agentDetails=EventsContent.getAgentInfo(particpantid);
	agentDetails=new HashMap();
	agentDetails=F2FEventDB.getAgentInformation(agentDetails,agentinfoq,particpantid,settingid);
  display="yes";
	if(agentDetails!=null&&agentDetails.size()>0){
		participantname="<a href='"+ShortUrlPattern.get((String)partnerdetails.get("loginname"))+"/network'>"+(String)partnerdetails.get("username")+"</a>";
		particpantstitle=(String)agentDetails.get("title");
		particpantsmessage=(String)agentDetails.get("message");
		if(agentDetails.get("photourl")!=null)
	      	participantsphoto="<img src='"+EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/"+(String)agentDetails.get("photourl")+"' />";
		goalamount=(String)agentDetails.get("goalamount");
		showgoalreachimage=(String)agentDetails.get("showsales");
		if("yes".equalsIgnoreCase(showgoalreachimage)){
			try{
			double totalgoalamount=Double.parseDouble(goalamount);
			String totalticketamount=DbUtil.getVal("select sum(to_number(totalamount,'9999.99')) as sales from transaction where agentid=? and refid=?",new String [] {particpantid,groupid});
			if(totalticketamount==null)totalticketamount="0";
			double soldamount=Double.parseDouble(totalticketamount);
			if(totalgoalamount>0){
				int width=-1;
				String colorclass="";
				if(soldamount>0){
					width=(int)(soldamount*180/totalgoalamount);
					colorclass="shadetable";
				}
				Currency dollars = Currency.getInstance("USD");
				NumberFormat usFormat = NumberFormat.getCurrencyInstance(Locale.US);
				String totgoalamount=usFormat.format(totalgoalamount);
				String solamount=usFormat.format(soldamount);
			goalreachgraph="<table width='100%'  cellspacing='0' cellpadding='0' ><tr><td height='5'>"
					+"<table width='180' height='30' cellspacing='0' cellpadding='0' class='toptable' >"
					+"<tr  ><td width='"+width+"' height='15' class='"+colorclass+"'></td><td width='"+(180-width)+"' height='5'></td></tr>"
					+"</table></td></tr>"
					+"<tr ><td height='8px'> "
					+" <table width='180' cellspacing='0' cellpadding='0' class='toptable1'  >"
					+" <tr  ><td width='45'  ><span  style='float:right'   class='upline' height='8px'></span></td>"
					+" <td width='45' ><span  style='float:right'   class='upline'></span></td>"
					+" <td   width='45' ><span  style='float:right'   class='upline'></span></td>"
					+" <td width='45' ></td></tr> </table></td></tr>"
					+" <tr><td><table width='180' cellspacing='0' cellpadding='0' class='toptable2' ><tr  >"
					+" <td width='45' > <span  style='float:left' ><font size='1'>0%</font></span>  <span  style='float:right; align:center' ><font size='1'>25%</font></span></td>"
					+" <td width='45' ><span  style='float:right'  ><font size='1'>50%</font></span></td>"
					+" <td   width='45' ><span  style='float:right'  ><font size='1'>75%</font></span></td>"
					+" <td width='45' ><span  style='float:right' ><font size='1'>100%</font></span></td>"
					+"  </tr>  </table>  "
					+"<tr><td> <table><tr><td>Goal: "+totgoalamount+"</td></tr><tr><td>Sold: "+solamount+"</td></tr></table>  </td></tr>"
					+"</td></tr></table>";
					
			}
		}catch(Exception e){
			System.out.println("exception : "+e.getMessage());
		}
		}
		
	}
}
request.setAttribute("GOALREACHGRAPH",goalreachgraph);
request.setAttribute("PARTICPANTNAME",participantname);
request.setAttribute("PARTICPANTTITLE",particpantstitle);
request.setAttribute("PARTICPANTMESSAGE",particpantsmessage);
request.setAttribute("PARTICPANTPHOTO",participantsphoto);
request.setAttribute("SALESLIMIT",saleslimit);
*/
/*
String isenableyes=DbUtil.getVal("select enableparticipant from group_agent_settings where groupid=?",new String[]{groupid});
if(("Yes".equals(isenableyes)&&particpantid==null)||((particpantid!=null)&&!"yes".equals(enableparticipant)))
	request.setAttribute("FRIENDSTOEVENT",selectagents);
*/
if("yes".equalsIgnoreCase(isf2fenabled)&&particpantid==null){
				f2fTagline="<a href='/portal/mytasks/loginevent.jsp?setid="+setid+"&GROUPID="+groupid+"&foroperation=create'>"+"tagline"+"</a>";
				f2fimage="<a href='/portal/mytasks/loginevent.jsp?setid="+setid+"&GROUPID="+groupid+"&foroperation=create'><image src='/home/images/f2fenabled.gif'/></a>";
}
if((particpantid!=null)&&!"yes".equals(enableparticipant))
	f2fTagline="<a href='/portal/mytasks/loginevent.jsp?setid="+setid+"&GROUPID="+groupid+"&foroperation=create'>"+"tagline"+"</a>";	
if (particpantid!=null)
	event_link="<a href="+ShortUrlPattern.get(loginname)+"/event?eventid="+request.getParameter("eventid")+" >"+"Visit Main Event Page"+"</a>";
/*request.setAttribute("F2FIMAGE",f2fimage);
request.setAttribute("EVENTTOPSELLERS",topsellers);
request.setAttribute("HEADERMSG",groupheader);
request.setAttribute("F2FTAGLINE",f2fTagline);
request.setAttribute("AGENTSETTINGS",agentsettings);
*/
 String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");

if (particpantid!=null)
event_link="<a href="+ShortUrlPattern.get(loginname)+"/event?eventid="+groupid+" >"+"Visit Main Event Page"+"</a>";

if("yes".equals(enableparticipant)){
	request.setAttribute("DISPLAY",display);
	request.setAttribute("EVENTLINK",event_link);
}
String commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{groupid});	

commission="$"+commission;


if("yes".equalsIgnoreCase(isf2fenabled)&&commission!=null)
	request.setAttribute("NETWORKTICKETENABLE","yes");
request.setAttribute("COMMISSION",commission);


String networkticketmsg="";

String platform=(String)session.getAttribute("platform");

networkticketmsg+="<table width='100%' id='ntsbox' ><tr><td colspan='2'> Publish this event on your Facebook Profile, Website or Blog, and get paid up to "+commission+" per each ticket"
				+" sale. Powered by Eventbee Network Ticket Selling.</td></tr>";
				if("ning".equals(platform)){
			networkticketmsg=networkticketmsg+" <tr><td width='50%'>» Add Eventbee Partner Network Application</td></tr></table>";
			}
			else	{
			networkticketmsg=networkticketmsg +" <tr><td width='50%'>» <a href='"+serveraddress+"/participate.jsp?eid="+groupid+"' >"+EbeeConstantsF.get("eventpage.networkselling.participation.link","Participate")+"</a> </td>";
			networkticketmsg=networkticketmsg+" <td width='50%'>»  <a href='http://www.eventbee.com/portal/helplinks/partnernetwork.jsp' target='_blank'>Learn More</a></td></tr></table>";
			}	
				
		
request.setAttribute("NETWORKSELLINGBLOCK",networkticketmsg);

%>

