package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderWhosPromotingWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		String promos="";
		String eventid=refHash.get("eventid");
		String template =configHash.get("global_template_whospromoting");
		if(template==null || "".equals(template.trim()))
			template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_whospromoting");
		
		VelocityContext vc = new VelocityContext();
		vc.put("eid", eventid);
		promos=getVelocityOutPut(vc,template);
		return promos;
		
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
		HashMap<String, String> dataHash, HashMap<String, String> configHash) throws Exception{		
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		try{
			JSONObject whosData= new JSONObject(config_options.getString("whosPromoting"));
			String seltype=whosData.getString("seloption");
			if("show".equals(seltype))
				return true;
			else
				return false;
		}catch(Exception e){
			System.out.println("Exception while render whos promoting:: "+e);
		}
		
		// TODO Auto-generated method stub	
	       return false;	
	}
	
private static String getVelocityOutPut(VelocityContext vc,String template){
		
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"whospromoting",template );
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("fbrsvplist exception: "+e.getMessage());
		}
			return str.toString();
	}
	
}
