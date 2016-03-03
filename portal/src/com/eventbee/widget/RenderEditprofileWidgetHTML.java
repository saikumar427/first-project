package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import com.eventbee.cachemanage.CacheManager;
import com.eventbee.layout.EventGlobalTemplates;

public class RenderEditprofileWidgetHTML implements RenderWidgetHTML{
	
	@Override
	public String getHTML(HashMap<String, String> refHash,
		HashMap<String, String> dataHash, HashMap<String, String> configHash) {
		String serveraddress=refHash.get("serveraddress");
		String groupid=refHash.get("eventid");
		String tid=refHash.get("tid");
		String token=refHash.get("token");
		String stage=refHash.get("stage");
		java.io.StringWriter out=new java.io.StringWriter();
		boolean isrsvp=false,isrecurring=false,isPriority=false;
		String recurringselect="",recurdateslabel="";
		StringBuffer sbf1=new StringBuffer();
		try{
			HashMap eventinfoMap=(HashMap)CacheManager.getData(groupid, "eventinfo");
			HashMap configMap=((HashMap)(eventinfoMap.get("configmap")));//DBHelper.getConfigValuesFromDb(groupid);
			VelocityContext vcontext = new VelocityContext();
		 	vcontext.put("eid",groupid);
		 	vcontext.put("serveraddress", serveraddress);
		 	vcontext.put("tid", tid);
		 	vcontext.put("token", token);
		 	vcontext.put("stage", stage);
			   
			VelocityEngine ve= new VelocityEngine(); 
			String editprofilewdgttemplate=configHash.get("global_template_editprofilewidget");
			   if(editprofilewdgttemplate==null || "".equals(editprofilewdgttemplate.trim()))
				   editprofilewdgttemplate=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_editprofilewidget");
		 	  try{
		 	  ve.init();
		 	  boolean abletopares=ve.evaluate(vcontext,out,"ebeetemplate",editprofilewdgttemplate);
		 	  sbf1=out.getBuffer();
		 	  }
		 	  catch(Exception exp){
		 	  System.out.println("Exception occured in evaluate velocity"+exp.getMessage());
		 	  exp.printStackTrace();
		 	  }  
		}catch(Exception e){
			System.out.println("Exception occured in RenderTicketsWidgetHTML"+e.getMessage());
			e.printStackTrace();
		}
 	    return sbf1.toString();
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) {
		// TODO Auto-generated method stub
		return true;
	}
}
