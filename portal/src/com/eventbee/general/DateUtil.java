package com.eventbee.general;
import java.util.*;
import java.text.*;


public class DateUtil{
	
	
	public static String getFormatedDate(Date d,String format,String def){
		SimpleDateFormat SDF=null;
		if(d !=null && format !=null){
			try{
				SDF=new SimpleDateFormat(format);
				return SDF.format(d);
			}catch(Exception exp){
				return def;
			}
				
		}else{
			return def;
		}
	}
	public static String getCurrDBFormatDate(){
		java.util.Date today=new java.util.Date();
		Format fm=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
		String timenow=fm.format(today);
		return timenow;
	}
}
