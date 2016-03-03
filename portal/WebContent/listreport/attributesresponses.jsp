<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<%!
private final static String RESPONSE_QUERY="select attrib_name,response,c.firstname || ' ' || c.lastname as name,"
				+" c.attendeekey  from  custom_attrib_response a,"
				+" custom_attrib_response_master b,eventattendee c where" 
				+" a.responseid=b.responseid and c.attendeekey=b.userid and"
				+" b.attrib_setid=? and c.priattendee='Y'"
				+" and attrib_name in (select attribname  from attendeelist_attributes where eventid=? order by position)";
	public static HashMap getResponses(String setid,String eid){
		DBManager dbmanager=new DBManager();
		Vector responses=new Vector();
		StatusObj statobj=null;
		HashMap hm=null;
		statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY,new String []{setid,eid});
		int count=statobj.getCount();
		if(statobj.getStatus()&&count>0){
		hm=new HashMap();
		for(int k=0;k<count;k++){
			String attendeekey=dbmanager.getValue(k,"attendeekey","");
			HashMap options=(HashMap)hm.get(attendeekey);
			if (options==null)
				options=new HashMap();
			options.put(dbmanager.getValue(k,"attrib_name","0"),dbmanager.getValue(k,"response","0"));
			hm.put(attendeekey,options);

		}

		}

	return hm;
}

public static Vector getRequiredAtribs(String eid){
	Vector attribsVector=new Vector();
String ATTENDEELIST_ATTRIBUTES="select attribname from attendeelist_attributes where eventid=? order by position";
	try{Integer.parseInt(eid);}
	catch(Exception e){return attribsVector;}
	DBManager dbmanager=new DBManager();
	HashMap hm = null;
	StatusObj statobj=dbmanager.executeSelectQuery(ATTENDEELIST_ATTRIBUTES,new String [] {eid});
	if(statobj.getStatus()){
	        for(int k=0;k<statobj.getCount();k++){
			attribsVector.add(dbmanager.getValue(k,"attribname",""));
	}
	}
	 return attribsVector;

	}

%>
