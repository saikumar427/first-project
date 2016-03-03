<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<%!
private final static String RESPONSE_QUERY="select attribid,bigresponse as response,c.fname || ' ' || c.lname as name,"
				+" c.profilekey from  custom_questions_response a,"
				+" custom_questions_response_master b,profile_base_info c where" 
				+" a.ref_id=b.ref_id and c.profilekey=b.profilekey and"
				+" b.attribsetid=?"
				+" and attribid in (select attrib_id  from attendeelist_attributes where eventid=CAST(? AS BIGINT) order by position)";
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
			String attendeekey=dbmanager.getValue(k,"profilekey","");
			HashMap options=(HashMap)hm.get(attendeekey);
			if (options==null)
				options=new HashMap();
			options.put(dbmanager.getValue(k,"attribid","0"),dbmanager.getValue(k,"response","0"));
			hm.put(attendeekey,options);

		}

		}

	return hm;
}
public static HashMap<String,HashMap<String,String>> getBasicResponses(String eid){
	HashMap<String,HashMap<String,String>> basicResponse=new HashMap<String,HashMap<String,String>>();
	String query="select profilekey,email,phone from profile_base_info where eventid =?::bigint";
	StatusObj statobj=null;
	DBManager dbmanager=new DBManager();
	statobj=dbmanager.executeSelectQuery(query,new String []{eid});
	if(statobj.getStatus() && statobj.getCount()>0){
	for(int k=0;k<statobj.getCount();k++){
		HashMap<String,String> hm=new HashMap<String,String>();
		hm.put("email",dbmanager.getValue(k,"email",""));
		hm.put("phone",dbmanager.getValue(k,"phone",""));
		basicResponse.put(dbmanager.getValue(k,"profilekey",""),hm);
	}
	}
	return basicResponse;
}
public static Vector getRequiredAtribs(String eid){
String ATTENDEELIST_ATTRIBUTES="select attrib_id from attendeelist_attributes where eventid=CAST(? AS INTEGER) order by position";
	Vector attribsVector=new Vector();
	DBManager dbmanager=new DBManager();
	HashMap hm = null;
	StatusObj statobj=dbmanager.executeSelectQuery(ATTENDEELIST_ATTRIBUTES,new String [] {eid});
	if(statobj.getStatus()){
	        for(int k=0;k<statobj.getCount();k++){
			attribsVector.add(dbmanager.getValue(k,"attrib_id",""));
	}
	}
	 return attribsVector;

	}

%>
