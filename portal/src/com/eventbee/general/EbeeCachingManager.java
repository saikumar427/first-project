package com.eventbee.general;

import java.util.HashMap;

public class EbeeCachingManager {
public static HashMap ebeeCache=new HashMap();
public static void clearCache(String key){
	ebeeCache.remove(key);
}
public static void put(String key,Object object){
	ebeeCache.put(key,object);
	long cachetime=System.currentTimeMillis();
	ebeeCache.put(key+"_cachetime",cachetime);
}
public static Object get(String key){
	return ebeeCache.get(key);
}
public static void clearAllCache(){
	ebeeCache.clear();
}
public static boolean checkCache(String key,long time){
	try{
	if(ebeeCache.get(key+"_cachetime")==null)
		return false;
	long cachetime=(Long)ebeeCache.get(key+"_cachetime");
	long currentTime=System.currentTimeMillis();
	if((currentTime-cachetime)>time)
		return false;
	else
		return true;
	}catch (Exception e) {
		// TODO: handle exception
		return false;
	}
}
}
