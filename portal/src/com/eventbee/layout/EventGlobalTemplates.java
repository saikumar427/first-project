package com.eventbee.layout;

import java.util.HashMap;

public class EventGlobalTemplates {
		
	public static HashMap<String,HashMap<String, String>> globalWidgetTemplates = new HashMap<String,HashMap<String, String>>();
	public static HashMap<String,HashMap<String, String>> globalWidgetOptions = new HashMap<String,HashMap<String, String>>();
	public static HashMap<String,HashMap<String, String>> globalBuyerWidgetOptions = new HashMap<String,HashMap<String, String>>();

	public static HashMap<String, String> get(String lang){
		if(globalWidgetTemplates.get(lang)==null)
			globalWidgetTemplates.put(lang,DBHelper.getDefaultWidgetTemplates(lang));
		
		return (HashMap<String, String>)globalWidgetTemplates.get(lang);
	}
	
	public static HashMap<String, String> getWidgetOptions(String lang){
		if(globalWidgetOptions.get(lang)==null)
			globalWidgetOptions.put(lang, DBHelper.getDefaultWidgetOptions(lang));
		
		return (HashMap<String, String>)globalWidgetOptions.get(lang);
	}
	
	public static HashMap<String, String>getBuyerWidgetOptions(String lang, String type){
		if(globalBuyerWidgetOptions.get(lang)==null)
			globalBuyerWidgetOptions.put(lang, BuyerAttDBHelper.getDefaultBuyerWidgetOptions(lang));
		return (HashMap<String, String>)globalBuyerWidgetOptions.get(lang);
			
	}
	
	public static String getTemplateOfLanguage(String lang, String templateKey){
		/*if(globalWidgetTemplates.get(lang)==null)
			globalWidgetTemplates.put(lang,DBHelper.getDefaultWidgetTemplates(lang));
		String templateValue=globalWidgetTemplates.get(lang).get(templateKey);*/
		String templateValue=get(lang).get(templateKey);
		return templateValue==null?"":templateValue;
	}
	
	public static void clearAllCache(){
		globalWidgetTemplates.clear();
		globalWidgetOptions.clear();
		globalBuyerWidgetOptions.clear();
	}
	
	public static void clearCache(String key){//key=lang
		globalWidgetTemplates.remove(key);
		globalWidgetOptions.remove(key);
		globalBuyerWidgetOptions.remove(key);
	}
	
	static{
		System.out.println("::::::: in EventGlobalTemplates static block :::::::");
		globalWidgetTemplates.putAll(DBHelper.getAllLanguageDefaultGlobalTemplates());
		globalWidgetOptions.putAll(DBHelper.getAllLanguageDefaultWidgetOptions());
		globalBuyerWidgetOptions.putAll(BuyerAttDBHelper.getAllLanguageDefaultBuyerWidgetOptions());
	}

}
