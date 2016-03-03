<%@ page import="com.event.dbhelpers.*,com.eventregister.*"%>
<%@ page import="java.util.*,com.eventbee.general.DbUtil,com.eventbee.general.*"%>
<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
Map reqmapnet=request.getParameterMap();
		String totalqstr="";
		Iterator iterator = reqmapnet.keySet().iterator();
		while (iterator.hasNext()) {
				String key = (String) iterator.next();
				totalqstr=totalqstr+key+":{";
				//System.out.println("1reqmapnet  key:" + key + " value " + reqmapnet.get(key));
				String[] stringArray = (String[])reqmapnet.get(key);
				// System.out.println("1stringArray"+stringArray.length+"array"+stringArray[0]);
				 
				 for(int i=0;i<stringArray.length;i++)
				  {
				  if(i==stringArray.length-1)
				   totalqstr=totalqstr+stringArray[i];
				   else
				  totalqstr=totalqstr+stringArray[i]+",";
				  }totalqstr=totalqstr+"} ";
	}
	 System.out.println("update totalqstr :"+totalqstr);
	 
	
	 try{
			StatusObj sb=DbUtil.executeUpdateQuery("insert into querystring_temp (tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",new String[]{tid, request.getHeader("User-Agent"),totalqstr,"updatetempaction.jsp"});
		}catch(Exception eq){System.out.println("error in updatetempaction.jsp inserting  query string"+eq.getMessage());}


String action=request.getParameter("current_action");
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.setEventRegTempAction(eid,tid,action);
%>

