package com.event.dbhelpers;

import java.util.HashMap;


import com.event.i18n.dbmanager.DisplayAttribsDAO;
import com.eventbee.layout.DBHelper;

public class BDisplayAttribsDB {
	
public static void insertDisplayAttribs(String eid,String module,HashMap<String, String>attribMap ,boolean forceDelete){
	/*Set<String> mapKeys = attribMap.keySet();
    Iterator<String> It = mapKeys.iterator();
    String inserAttribQuery="insert into custom_event_display_attribs(eventid ,module,attrib_name,attrib_value) " +
    		"values(CAST(? AS BIGINT),?,?,?)";
    String deleteQuery="delete from custom_event_display_attribs where eventid=CAST(? AS BIGINT) and module=?";
    if(forceDelete){
    	DbUtil.executeUpdateQuery(deleteQuery, new String []{eid,module});
    }
    while (It.hasNext()) {
            String key = (String)(It.next());
            String value=attribMap.get(key);
            DbUtil.executeUpdateQuery(inserAttribQuery, new String []{eid,module,key,value});
            }*/
}// End of insertDisplayAttribs
//getThemePageAttribs

public static HashMap<String,String> getAttribValues(String eid,String module){
	/*HashMap<String,String> defaultValues=new HashMap<String,String>();
	defaultValues=getDefaultAttribs(module);
	DBManager dbmanager=new DBManager();
	StatusObj statobj=null;
	String attribValsQuery="select attrib_name,attrib_value from event_display_attribs " +
			"where eventid=CAST(? AS BIGINT) and module=?";
	statobj=dbmanager.executeSelectQuery(attribValsQuery,new String []{eid,module});
	int count=statobj.getCount();
	if(statobj.getStatus() && count>0){
		for(int k=0;k<count;k++){
			 String attribname=dbmanager.getValue(k,"attrib_name","");
			 String attribval=dbmanager.getValue(k,"attrib_value","");
			 if(defaultValues.containsKey(attribname)){
				 defaultValues.remove(attribname);
			 }
			 defaultValues.put(attribname, attribval);
		}
	}*/
	String lang=DBHelper.getLanguageFromDB(eid);
	if(lang==null || "".equals(lang)) lang="en_US";
	return getDisplayAttribs(eid,module,lang);
}

public static HashMap<String,String> getDefaultAttribs(String module){
	/*HashMap<String,String> defaultAttribMap=new HashMap<String,String>();
	String defaultValsQuery="select attribname,attribdefaultvalue from event_display_defaultattribs where module=?";
	DBManager dbmanager=new DBManager();
	StatusObj statobj=null;
	statobj=dbmanager.executeSelectQuery(defaultValsQuery,new String []{module});
	int count=statobj.getCount();
	if(statobj.getStatus() && count>0){
		for(int k=0;k<count;k++){
		    String attribname=dbmanager.getValue(k,"attribname","");
		    String attribval=dbmanager.getValue(k,"attribdefaultvalue","");
		    defaultAttribMap.put(attribname, attribval);
		}
	}*/
	return getDefaultDisplayAttribs(module,"en_US");
}

public static HashMap<String,String> getDisplayAttribs(String eid,String module,String lang){
	HashMap<String,String> displayAttribs=new HashMap<String,String>();
	//String lang=DBHelper.getLanguageFromDB(eid);
	DisplayAttribsDAO displayDao=new DisplayAttribsDAO();
	HashMap<String, String> hm= new HashMap<String,String>();
	hm.put("module", module);
	displayAttribs=(HashMap<String,String>) displayDao.getData(hm, lang, eid).get("displayAttribs");
	return displayAttribs;
}

public static HashMap<String,String> getDefaultDisplayAttribs(String module,String lang){
	HashMap<String,String> defaultValues=new HashMap<String,String>();
	DisplayAttribsDAO displayDao=new DisplayAttribsDAO();
	HashMap<String, String> hm= new HashMap<String,String>();
	hm.put("module", module);
	defaultValues=(HashMap<String,String>) displayDao.getDefaultAttribs(module, lang);
	return defaultValues;
}

public static HashMap<String,String> getAttribValuesForKeys(String eid, String module, String lang, String [] keys){
	HashMap<String,String> defaultValues=new HashMap<String,String>();
	//String lang=DBHelper.getLanguageFromDB(eid);
	DisplayAttribsDAO displayDao=new DisplayAttribsDAO();
	HashMap<String, String> hm= new HashMap<String,String>();
	hm.put("module", module);
	defaultValues=(HashMap<String,String>) displayDao.getDataForKeys(hm, lang, eid, keys).get("displayAttribsForKeys");
	return defaultValues;
}

public static HashMap<String,String> getDefaultAttribValuesForKeys(String module,String lang, String [] keys){
	HashMap<String,String> defaultValues=new HashMap<String,String>();
	DisplayAttribsDAO displayDao=new DisplayAttribsDAO();
	HashMap<String, String> hm= new HashMap<String,String>();
	hm.put("module", module);
	defaultValues=(HashMap<String,String>) displayDao.getDefaultAttribsForKeys(module, lang, keys);
	return defaultValues;
}
} //End of class DisplayAttribsDB
