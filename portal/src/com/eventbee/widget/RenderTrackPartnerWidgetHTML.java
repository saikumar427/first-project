package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONObject;

import com.eventbee.layout.DBHelper;
import com.eventbee.layout.EventGlobalTemplates;
        
public class RenderTrackPartnerWidgetHTML implements RenderWidgetHTML{

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		String template=configHash.get("global_template_trackpartner");
		String widgetType=DBHelper.getWidgetType("trackPartner",configHash);
		if(template==null || "".equals(template.trim()))
			template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_trackpartner");  
		// TODO Auto-generated method stub
		String trackcode=refHash.get("trackcode");
		System.out.println("the track code is::"+trackcode);
		String eid=refHash.get("eventid");
		if(trackcode==null)trackcode="";
		HashMap<String,String> detailsMap=new HashMap<String,String>();
		if(!"".equals(trackcode))
		detailsMap=DBHelper.getTrackUrlDetails(trackcode,eid);
		VelocityContext vc=new VelocityContext();     
		if(detailsMap.get("photo")!=null && !"".equals(detailsMap.get("photo")))
		vc.put("tracklogo",detailsMap.get("photo"));
		if(detailsMap.get("message")!=null && !"".equals(detailsMap.get("message")))
		vc.put("trackmsg",detailsMap.get("message"));
		if("narrow".equalsIgnoreCase(widgetType)|| "wide".equalsIgnoreCase(widgetType))
			vc.put("narrow",widgetType);
		return getVelocityOutPut(vc,template);
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash){
		try{
			String trackcode=refHash.get("trackcode");
			System.out.println("the track code isrenderable::"+trackcode);
			if(trackcode==null)return false;
			JSONObject config_options = new JSONObject(configHash.get("config_options"));
			System.out.println("the config options are::"+config_options);
			if(!config_options.has("trackPartner"))return false;
		}catch(Exception e){
			
		}
		// TODO Auto-generated method stub
		return true;
	}
private static String getVelocityOutPut(VelocityContext vc,String Template){
		
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"trackpartner",Template );
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("In RenderTrackPartner exception: "+e.getMessage());
		}
			return str.toString();
	}

}
