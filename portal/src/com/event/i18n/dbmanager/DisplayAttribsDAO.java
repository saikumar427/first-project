package com.event.i18n.dbmanager;

import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.general.DbUtil;
import com.eventbee.interfaces.I18NWrapper;
import com.eventbee.layout.DBHelper;

public class DisplayAttribsDAO implements I18NWrapper {

	@Override
	public HashMap<String, Object> getData(HashMap<String, String> hm, String lang, String eid) {
		System.out.println("regflow DisplayAttribsDAO eventid: "+eid+" lang: "+lang);
		HashMap<String,String> customValues=null;
		HashMap<String,String> defaultValues=getDefaultAttribs(hm.get("module"), lang);
		//String attribValsQuery="select attrib_name,attrib_value from custom_event_display_attribs where eventid=CAST(? AS BIGINT) and module=?";
		
		JSONArray modulesJSONArray=getAllModulesData(lang, eid);
		customValues=customDisplayAttribs(modulesJSONArray, hm.get("module"));
		
		if(customValues!=null && customValues.size()>0)
			defaultValues.putAll(customValues);
		
		 HashMap<String, Object> displayAttribs=new HashMap<String, Object>();
		 displayAttribs.put("displayAttribs", defaultValues);
	return displayAttribs;
	}
	
	public static JSONArray getAllModulesData(String lang, String eid){
		String attribValsQuery="select data from custom_event_display_attribs where eventid=CAST(? AS BIGINT)";
		String data=DbUtil.getVal(attribValsQuery,new String []{eid});
		JSONArray allLanguages = new JSONArray();
		JSONArray modulesJSONArray= new JSONArray();;
		//System.out.println("111 getData data: "+data);
		if(!"".equals(data) && data!=null){
			try {
				allLanguages = new JSONArray(data);				
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}	
		
		for (int i = 0; i < allLanguages.length(); i++) {
			try {
		        JSONObject langJSONObject = allLanguages.getJSONObject(i);
		        if(langJSONObject.getString("lang").equals(lang)){
		        	modulesJSONArray=langJSONObject.getJSONArray("modules");		        	
		        	break;
		        }
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}		
	 return modulesJSONArray;
		
	}
	
	public static HashMap<String,String> displayAttribsMap(JSONArray jsonArray, String module){
		//System.out.println("333 displayAttribsMap jsonArray: "+jsonArray);
		HashMap<String,String> attribMap=new HashMap<String,String>();
		for (int i = 0; i < jsonArray.length(); i++) {
			try {
				JSONObject jsonObject = jsonArray.getJSONObject(i);
		        if(jsonObject.getString("m").equals(module)){
		        	attribMap=DBHelper.prepareHashMapFromJSON(jsonObject.getJSONObject("data"));
		        	break;
		        }
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return attribMap;
	}
	
	
	public static HashMap<String,String> customDisplayAttribs(JSONArray modulesJSONArray, String module){
		//System.out.println("222 customDisplayAttribs modulesJSONArray: "+modulesJSONArray);
		HashMap<String,String> attribMap=new HashMap<String,String>();
		try{
			attribMap=displayAttribsMap(modulesJSONArray,module);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return attribMap;
	}
	
	public static HashMap<String,String> getDefaultAttribs(String module, String lang){
		HashMap<String,String> defaultAttribMap=new HashMap<String,String>();
		String defaultLangValsQuery="select data from default_event_display_attribs where lang=?";
		String data=DbUtil.getVal(defaultLangValsQuery,new String []{lang});
		if(!"".equals(data) && data!=null){}
		else{
			data=DbUtil.getVal(defaultLangValsQuery,new String []{"en_US"});
		}
		try {
			JSONArray jsonArray = new JSONArray(data);
			defaultAttribMap=displayAttribsMap(jsonArray,module);
			
		} catch (JSONException e) {
			e.printStackTrace();
		} 
		return defaultAttribMap;
	}
	
	public HashMap<String, Object> getDataForKeys(HashMap<String, String> hm, String lang, String eid, String [] keys) {
		HashMap<String,String> customValuesMap=null;
		HashMap<String,String> defaultAttribMapForKeys=getDefaultAttribsForKeys(hm.get("module"), lang, keys);
		JSONArray modulesJSONArray=getAllModulesData(lang, eid);
		customValuesMap=customDisplayAttribs(modulesJSONArray, hm.get("module"));
		for (String key : keys) {
			if(customValuesMap.containsKey(key))
				defaultAttribMapForKeys.put(key, customValuesMap.get(key));
		}
		
		 HashMap<String, Object> data=new HashMap<String, Object>();
		 data.put("displayAttribsForKeys", defaultAttribMapForKeys);
	return data;
	} 
	
	public static HashMap<String,String> getDefaultAttribsForKeys(String module, String lang, String [] keys){
		HashMap<String,String> defaultAttribMap=new HashMap<String,String>();
		defaultAttribMap=getDefaultAttribs(module, lang);
		HashMap<String,String> defaultAttribMapForKeys=new HashMap<String,String>();
		for (String key : keys) {
			if(defaultAttribMap.containsKey(key))
				defaultAttribMapForKeys.put(key, defaultAttribMap.get(key));
		}
		return defaultAttribMapForKeys;
	}

}
