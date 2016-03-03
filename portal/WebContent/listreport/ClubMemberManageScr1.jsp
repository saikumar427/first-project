<%@ page import="java.io.*, java.util.*,java.text.*,java.sql.*,com.eventbee.clubs.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.customattributes.*" %>

<%
String CLASS_NAME="ClubMemberManageScr1.jsp";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);

String querystr="",mshipid="",name="",email="",dateopt="",montha="",daya="",yeara="",
monthb="",dayb="",yearb="",month1="",day1="",year1="",month2="",day2="",year2="",
statusid="",duechoice="",subscrdays="",subscrdaysmore="";

Map mshipmap=(Map)session.getAttribute("mshipmap");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"mshipmap is:"+mshipmap,"",null);

String clubid=request.getParameter("GROUPID");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"clubid is:"+clubid,"",null);
String memtype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {clubid});

String unitid="13579";

boolean nex=true;
try{
	if(Integer.parseInt(clubid)<=0){
		throw new Exception();
	}
}catch(Exception eno){
	System.out.println("Exception occured at converting clubid in ClubMemberManageScr1.jsp :"+eno);
	nex=false;
}

String clubname="";
String display="";

if(nex){
	clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String []{clubid});
}
if(clubname!=null&&!"".equals(clubname)){
	display=clubname+" Members";
}
else
display="";
List memlist=null;
String selec=request.getParameter("membopt");


if("mship".equals(selec)){
	mshipid=request.getParameter("mshipid");
	memlist=MemberSearchDB.getMembersMembershipId( clubid, mshipid);
	
	
}

if("All".equals(selec)){
	memlist=MemberSearchDB.getMembersAll(clubid);
	
	querystr="Search Filter All ";
}


if("str".equals(selec)){
	name=request.getParameter("name");
	
	if(name==null)name="";
	memlist=MemberSearchDB.getMembersName( clubid, name.toUpperCase());
	
	if("".equals(name))name="All";
	querystr="Search Filter  Name "+name;

}

if("email".equals(selec)){
	email=request.getParameter("email");
	if(email==null)email="";
	memlist=MemberSearchDB.getMembersEmail( clubid, email.toUpperCase());
	if("".equals(email))email="All";
	querystr="Search Filter  Email "+email;

}

if("dates".equals(selec)){
	dateopt=request.getParameter("dateopt");
	if(dateopt==null)dateopt="";
	if("after".equals(dateopt)){
		montha=request.getParameter("montha");
		daya=request.getParameter("daya");
		yeara=request.getParameter("yeara");
		String datestr=montha+"-"+daya+"-"+yeara;
		memlist=MemberSearchDB.getMembersAfterJoinDate( clubid, datestr);
		querystr="Search Filter  Join Date After "+montha+"/"+daya+"/"+yeara;
	}else
	if("before".equals(dateopt)){
		monthb=request.getParameter("monthb");
		dayb=request.getParameter("dayb");
		yearb=request.getParameter("yearb");
		String datestr=monthb+"-"+dayb+"-"+yearb;
		memlist=MemberSearchDB.getMembersBeforeJoinDate( clubid, datestr);
		querystr="Search Filter  Join Date Before "+monthb+"/"+dayb+"/"+yearb;
	}else
	if("betw".equals(dateopt)){
		month1=request.getParameter("month1");
		day1=request.getParameter("day1");
		year1=request.getParameter("year1");
		String datestr1=month1+"-"+day1+"-"+year1;

		month2=request.getParameter("month2");
		day2=request.getParameter("day2");
		year2=request.getParameter("year2");
		String datestr2=month2+"-"+day2+"-"+year2;
		memlist=MemberSearchDB.getMembersBetweenJoinDates( clubid, datestr1, datestr2);
		querystr="Search Filter  Join Date Between "+month1+"/"+day1+"/"+year1+" and "+month2+"/"+day2+"/"+year2;
	}
	
}//end of dates


if("status".equals(selec)){
	statusid=request.getParameter("statusid");
	if("EXCLUSIVE".equals(memtype)&&"1".equals(statusid))
	statusid="3";
	memlist=MemberSearchDB.getMembersByStatus( clubid, statusid);
	
	querystr="Search Filter  Status "+(String) MemAccountStatus.typeval.get(statusid);
}

if("subscription".equals(selec)){
	
	duechoice=request.getParameter("duechoice");
	if("within".equals(duechoice)){
		subscrdays=request.getParameter("subscrdays");
		memlist=MemberSearchDB.getMembersSubscriptionDueWithin( clubid, subscrdays);
		querystr="Search Filter:  Due in next "+subscrdays+" days  ";
	}else{
		subscrdaysmore=request.getParameter("subscrdaysmore");
		if("pastdue".equals(duechoice)){
			subscrdaysmore="0";
			querystr="Search Filter: Past due ";
		}else
			querystr="Search Filter: Past due by "+subscrdaysmore+ " days  ";
		memlist=MemberSearchDB.getMembersSubscriptionDueMore( clubid, subscrdaysmore);
	}
}

session.setAttribute("memlist",memlist);
session.setAttribute("clubid",clubid);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubMemberManageScr1.jsp","memlist issss"+memlist,"",null);

String submitbtn=request.getParameter("submit");

DateFormat DATEFORMAT=new SimpleDateFormat("MM/dd/yyyy");
java.util.Date dt=new java.util.Date();
String currentdate=DATEFORMAT.format(dt);
%>

<page1 title="<%=display%>" sub-title="<%=currentdate%>">
<s1 title=""/>
<%
if("yes".equals(request.getParameter("landf"))){

request.setAttribute("subtabtype","Communities");

%>


<%@ include file="ClubMemberReport.jsp" %>
<%}else{%>
<html>
<head></head>
<body>
<%@ include file="ClubMemberReport.jsp" %>
</body>
</html>
<%}%>
</page1>

