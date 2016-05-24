package com.event.dbhelpers;

import java.util.HashMap;

import com.event.i18n.dbmanager.DisplayAttribsDAO;
import com.eventbee.layout.DBHelper;

public class CDisplayAttribsDB {
	public static void insertDisplayAttribs(String eid,String module,HashMap<String, String>attribMap ,boolean forceDelete){
		// 
	}
	
	public static HashMap<String,String> getAttribValues(String eid,String module){
		String lang=DBHelper.getLanguageFromDB(eid);
		if(lang==null || "".equals(lang)) lang="en_US";
		return getDisplayAttribs(eid,module,lang);
	}
	
	public static HashMap<String,String> getDefaultAttribs(String module){
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
	
	// don't know where it is using in angular ticket widget
	public static HashMap<String,String> getDefaultAttribValuesForKeys(String module,String lang, String [] keys){
		HashMap<String,String> defaultValues=new HashMap<String,String>();
		DisplayAttribsDAO displayDao=new DisplayAttribsDAO();
		HashMap<String, String> hm= new HashMap<String,String>();
		hm.put("module", module);
		defaultValues=(HashMap<String,String>) displayDao.getDefaultAttribsForKeys(module, lang, keys);
		return defaultValues;
	}
}
