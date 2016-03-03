<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.general.StatusObj" %>
<%@ page import="com.eventbee.general.EventbeeLogger" %>
<%
/*
To set default themes randomly the following code is used
String [] defaultthemes=GenUtil.strToArrayStr(EbeeConstantsF.get("accounts.basic.themes","india_zilla,tajmahal,wuhan,rin,india_sahyadri,orangesky,india_fastcricket,india_vande_mataram"),",",false);
List userid=DbUtil.getValues("select user_id from authentication where role_id=-100",null);
StatusObj statobj=null;
int length=0;
if(defaultthemes!=null)length=defaultthemes.length;
int position=0;
boolean flag=false;
if(userid!=null&&userid.size()>0){
	for(int i=0;i<userid.size();i++){
		if(position==length)position=0;
		statobj= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themecode) values(?,?,?)", new String[]{(String)userid.get(i),"Snapshot",defaultthemes[position] } );
		statobj= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themecode) values(?,?,?)", new String[]{(String)userid.get(i),"Photos",defaultthemes[position] } );
		if(position<length){
			position++;
		}
	}
}*/



List userid=DbUtil.getValues("select user_id from authentication where role_id=-100",null);
StatusObj statobj=null;
try{
	if(userid!=null&&userid.size()>0){
		for(int i=0;i<userid.size();i++){
			
			statobj= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themetype,themecode) values(?,?,?,?)", new String[]{(String)userid.get(i),"network","DEFAULT","basic"} );
			statobj= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themetype,themecode) values(?,?,?,?)", new String[]{(String)userid.get(i),"photo","DEFAULT","basic"} );
			statobj= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themetype,themecode) values(?,?,?,?)", new String[]{(String)userid.get(i),"eventspage","DEFAULT","basic" } );
			statobj= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themetype,themecode) values(?,?,?,?)", new String[]{(String)userid.get(i),"hubspage","DEFAULT","basic" } );
			
			}
		}
	out.println("Total Users Count==="+userid.size());		
	}
catch(Exception e){
	EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "setDefaultThemes.jsp", "service()", e.getMessage(), e ) ;
}

	
%>
