<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*" %>

<%!

String eventsQuery="select eventid,eventname,to_char(start_date,'MM/DD')as startdate,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where mgr_id=? and status='ACTIVE' and listtype='PBL' and start_date>=now() order by start_date ";

 String pasteventsQuery="select  e.eventid,e.eventname,to_char(e.start_date,'MM/DD')as startdate,login_name  as username from eventinfo e,authentication a where e.mgr_id=? and e.start_date<=now() and e.mgr_id=a.user_id and e.status!='INACTIVE' and e.listtype='PBL' order by e.eventid desc limit 10";


Vector GetManagerUpcomingEvents(String ebeeid){
Vector v=new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(eventsQuery,new String []{ebeeid});
				for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("startdate",dbmanager.getValue(i,"startdate",""));
				hm.put("eventurl","<a href=\"#\"  onClick=registerEvent("+dbmanager.getValue(i,"eventid","")+")>"+dbmanager.getValue(i,"eventname","").replaceAll("'","'")+"</a>");
				hm.put("regbutton","<a href=\"#\"  onClick=registerEvent("+dbmanager.getValue(i,"eventid","")+")><img src=\"/home/ningimages/register.jpg\" border=\"0\" height=\"16\"></a>");
				
				hm.put("eventid",dbmanager.getValue(i,"eventid",""));
				v.addElement(hm);
					}
return v;


}

Vector GetManagerPastEvents(String ebeeid){
Vector v=new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(pasteventsQuery,new String []{ebeeid});
				for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("startdate",dbmanager.getValue(i,"startdate",""));
				hm.put("eventurl","<a href=\"#\"  onClick=registerEvent("+dbmanager.getValue(i,"eventid","")+")>"+dbmanager.getValue(i,"eventname","").replaceAll("'","'")+"</a>");
				
				hm.put("eventid",dbmanager.getValue(i,"eventid",""));
				v.addElement(hm);
					}
return v;


}



%>





<%
String ningowner=request.getParameter("oid");
//ningowner="1n60rl6ztnrxp";
System.out.println("ningowner-----"+ningowner);
String ningviwer=request.getParameter("vid");
String ebeeid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{ningowner});

Vector newevents=GetManagerUpcomingEvents(ebeeid); 
Vector pastevents=GetManagerPastEvents(ebeeid); 


%>






<%


StringBuffer stylecontent=new StringBuffer("");
StringBuffer streamercontent=new StringBuffer("");
String background="#dce8ff";
String bordercolor="#660033";
String linkcolor="#3300CC";

String bigtextcolor="#3300CC";
String bigfonttype="Verdana";
String bigfontsize="21px";

String medtextcolor="#3300CC";
String medfonttype="Verdana";
String medfontsize="15px";

String smalltextcolor="#FF6600";
String smallfonttype="Verdana";
String smallfontsize="11px";
String width="460";

String padding="5px";


	stylecontent.append("<style type=\"text/css\">");
		stylecontent.append(".PartnerItemBody {font-family: "+medfonttype+";font-size:"+medfontsize+";padding: 0px;color: "+medtextcolor+";margin-top: 0px;margin-left: "+padding+";margin-right: "+padding+";margin-bottom: 10px;}");
		stylecontent.append(".PartnerEventBody {font-family: "+medfonttype+";font-size:"+medfontsize+";font-weight:normal;padding: 0px;color: #000000;margin-top: 0px;margin-left: "+padding+";margin-right: "+padding+";margin-bottom: 10px;}");
		stylecontent.append(".partnertitletop {font-family: "+bigfonttype+";font-size:"+bigfontsize+";font-weight:bold;text-align:left;color: "+bigtextcolor+";margin-top: 0px;margin-bottom: 15px; padding: 10px;}");
		stylecontent.append(".partnertitletop {font: bold 20px veradana, sans-serif;color: black;;margin-top: 0px;margin-bottom: 15px;;margin-left: 2px;}");
		stylecontent.append(".partnerbottom {text-align: center; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: lighter; color: #666666;margin-left: 2px;margin-bottom: 15px;}");
		stylecontent.append(".blockpartnerblock{border: solid 0px "+bordercolor+";width:"+width+";font-size:11px;background:"+background+"; }");
		stylecontent.append(".blockpartnerlist{margin: .2em 0 .4em .5em; list-style: disc;padding: 0;border: solid 0px "+bordercolor+";background:"+background+";}");
		stylecontent.append(".blockpartneritem {display: inline;list-style: disc; padding: 0;margin: .2em 0 .4em 1.5em;background:"+background+";line-height:16px;}");
		stylecontent.append(".blockpartneritem a { color: "+linkcolor+" }");
		stylecontent.append(".partnerbottom a { text-decoration: none;font-family: Verdana;color: "+linkcolor+"; }");
	stylecontent.append("</style>");
      	


 streamercontent.append("<div class=\"blockpartnerblock\" >");
	
if(newevents.size()>0){

	      
		streamercontent.append("<div class=\"partnertitletop\" >");
		streamercontent.append("Upcoming Events with Registration:");
		streamercontent.append("</div>");
		
	for(int i=0;i<newevents.size();i++){
		HashMap networkeventsmap=(HashMap)newevents.get(i);
	String evnturl=(String)GenUtil.getHMvalue(networkeventsmap,"eventurl","0");
	String regbutton=(String)GenUtil.getHMvalue(networkeventsmap,"regbutton","0");
	streamercontent.append("<div class=\"PartnerEventBody\" >");
	streamercontent.append("<ul class=\"blockpartnerlist\">");
	streamercontent.append("<li class=\"blockpartneritem\" >");

	streamercontent.append((String)GenUtil.getHMvalue(networkeventsmap,"startdate","0"));
	streamercontent.append("  ");
	streamercontent.append(evnturl);
	streamercontent.append("  ");
	
	streamercontent.append(regbutton);
	streamercontent.append("</div>");
      
	}
	
	
	
	
	streamercontent.append("</li>");
	streamercontent.append("</ul>");
		
	
	
	
}

else{

streamercontent.append("<div class=\"partnertitletop\" >");
		streamercontent.append("No Upcoming Events with Registration");
		streamercontent.append("</div>");
		


}

if(pastevents.size()>0){

	      
		streamercontent.append("<div class=\"partnertitletop\" >");
		streamercontent.append("Past Events with Registration:");
		streamercontent.append("</div>");
		
	for(int i=0;i<pastevents.size();i++){
		HashMap networkeventsmap=(HashMap)pastevents.get(i);
	String evnturl=(String)GenUtil.getHMvalue(networkeventsmap,"eventurl","0");
	streamercontent.append("<div class=\"PartnerEventBody\" >");
	streamercontent.append("<ul class=\"blockpartnerlist\">");
	streamercontent.append("<li class=\"blockpartneritem\" >");

	streamercontent.append((String)GenUtil.getHMvalue(networkeventsmap,"startdate","0"));
	streamercontent.append("  ");
	streamercontent.append(evnturl);
	
	streamercontent.append("</div>");
      
	}
	
	
	
	
	streamercontent.append("</li>");
	streamercontent.append("</ul>");
		
	
	
	
}

else{

streamercontent.append("<div class=\"partnertitletop\" >");
		streamercontent.append("No Past Events ");
		streamercontent.append("</div>");
		


}

	
	
		
	
	
	






streamercontent.append("<br><br></div>");
	
%>
document.write('<%=stylecontent%>');
document.write('<%=streamercontent%>');



