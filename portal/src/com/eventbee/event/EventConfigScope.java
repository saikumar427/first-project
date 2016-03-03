package com.eventbee.event;
import com.eventbee.general.StatusObj;
import com.eventbee.general.*;
import com.eventbee.event.eventlevel.*;
import java.util.*;
public class EventConfigScope{
public String getScope(String eventid,String purpose)
{

String scope=DbUtil.getVal("select checkConfigScope(?,?,eventid) from eventinfo where eventid= cast(? as integer)",new String[]{"event."+purpose+".scope",purpose,eventid});
return scope;
}
public HashMap getEventConfigValues(String eventid,String purpose)
{
String scope=getScope(eventid,purpose);
HashMap hm=new HashMap();
String query="select  name,value from config c,config_master cm where c.config_id=cm.config_id and ref_id=checkConfigValues(?,?) and purpose=?";
if(!("GLOBAL".equals(scope)))
{
DBManager dbmanager=new DBManager();
StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{scope,eventid,purpose});
	int recordcount=statobj.getCount();
	for(int i=0;i<recordcount;i++){
		hm.put(dbmanager.getValue(i,"name",""),dbmanager.getValue(i,"value",""));
	}
	}
	return hm;
}
public void setScope(String eventid,String purpose,String scope)
{
java.sql.Connection con=null;
java.sql.PreparedStatement pstmt=null;
String config_id=DbUtil.getVal("select config_id from eventinfo where eventid=cast(? as integer)",new String []{eventid});
String DELETE_CONFIG_SCOPE="delete from config where config_id=? and name=?";
String SET_EVENT_CONFIG="insert into config(config_id,name,value) values(?,?,?)";
	try{

			con=EventbeeConnection.getConnection();
			pstmt=con.prepareStatement(DELETE_CONFIG_SCOPE);
			pstmt.setString(1,config_id);
			pstmt.setString(2,"event."+purpose+".scope");
			pstmt.executeUpdate();
			pstmt.close();
			pstmt=null;
			pstmt=con.prepareStatement(SET_EVENT_CONFIG);
			pstmt.setString(1,config_id);
			pstmt.setString(2,"event."+purpose+".scope");
			pstmt.setString(3,scope);
			pstmt.executeUpdate();
			pstmt.close();
			con.close();
	}
	catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			try
			{
				if(pstmt!=null) pstmt.close();
				pstmt=null;
				if(con!=null) con.close();
				con=null;
			}
			catch(Exception e)
			{
				// EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getMyListedEvents()","Error in getMyListedEvents",e);
				System.out.println("error in event config scope:"+e.getMessage());
			}
		}
}
public String getScope(String eventid,String purpose,String unitid)
{
	String scope=DbUtil.getVal("select value from config c,eventinfo e where c.config_id=e.config_id and e.eventid=? and c.name like ?",new String[]{eventid,"event."+purpose+".scope"});
	if(scope==null){
		if("13579".equals(unitid))
			scope="MEMBER";
		else
			scope="UNIT";	
	}
	return scope;
}
}
