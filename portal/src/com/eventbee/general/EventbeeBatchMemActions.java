package com.eventbee.general;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import com.eventbee.general.EventbeeBatch;
public class EventbeeBatchMemActions {
	
	
	public static HashMap<String,Object> ebeeBatchCache=new HashMap<String,Object>();
	public static  int  batchActionTime=60;
	public static String  batchStartTime="";
	public static String checkKey="_mkey";
	public static String timeKey="_timkey";
	public static String countKey="_cnkey";
	public static String maxCountKey="_mxcnKey";
	public static String maxtimeKey="_mxtimKey";
	
	static{
		batchStartTime=DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString());
		
	}
	public static void clearCache(String key){
		ebeeBatchCache.remove(key);
	}
	public static void put(String key,Object object){
		ebeeBatchCache.put(key,object);		
		ebeeBatchCache.put(key+"_"+timeKey,System.currentTimeMillis());	
		//checkAllTimeOutAction();
	}

	public static Object get(String key){
		return ebeeBatchCache.get(key);
	}
	public static void clearAllCache(){
		ebeeBatchCache.clear();
	}	
	public static void checkTimeOutAction(String key){
		try{
		 long time=getDateDiffer(ebeeBatchCache.get(key+timeKey)+"",DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString()));	    
		 /*System.out.println("strt time::"+ebeeBatchCache.get(key+timeKey));
		 System.out.println("differnce time::"+time);
		 System.out.println("cache max time::"+ebeeBatchCache.get(key+maxtimeKey)+"");*/
		 if(time>=Long.parseLong(ebeeBatchCache.get(key+maxtimeKey)+""))
					 triggerBatchAction(key,"timeout");
					 
		}catch(Exception e){System.out.println("time out exception EventbeeBatchMemActions"+e.getMessage());}
		 
	}
	
	public static void checkCountAction(String key){		
		try{
			 		 if(Long.parseLong(ebeeBatchCache.get(key+maxCountKey)+"")-Long.parseLong(ebeeBatchCache.get(key+countKey)+"")<=0)
						 triggerBatchAction(key,"exceed");
						 
			}catch(Exception e){System.out.println("exceed exception EventbeeBatchMemActions"+e.getMessage());
			
			}			 
	}
	
	private static void checkAllTimeOutAction(){
		
		 long time=getDateDiffer(batchStartTime,DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString()));	    
			 if(time>batchActionTime){				 
			 //Do all actions
				Iterator<String> cahe_itr= ebeeBatchCache.keySet().iterator();
				for(;cahe_itr.hasNext();){
					if(!(cahe_itr.next().toString().indexOf(checkKey)>-1))
						continue;
					triggerBatchAction(cahe_itr.next().toString(),"timeout");
					}				 
		 }
		
	}
	
	public static void triggerBatchAction(String batchClass,String mode){
		
		//System.out.println("batchClass::"+batchClass);
		if(batchClass==null || "".equals(batchClass))
			return;		
		try{								
			((EventbeeBatch)Class.forName(batchClass).newInstance()).userBatchActions(mode,batchClass);					
		}catch(Exception e){System.out.println("Problem Batch Class in EventbeeBatchMemActions::"+e.getMessage());}
	
	}
	
	
	public static long getDateDiffer(String dateStart,String dateStop){
		long result=0;
       try{ SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");	     
		Date d1 = null;
		Date d2 = null;
		d1 = format.parse(dateStart);
		d2 = format.parse(dateStop);

		//in milliseconds
		long diff = d2.getTime() - d1.getTime();
	    //in hours
	//	result = diff / (60 * 60 * 1000) % 24;
	//in minutes
		result = diff / (60 * 1000);
       }catch(Exception e){}
		return result;
	}

}
