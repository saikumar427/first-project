package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderDescriptionWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash, HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException {
		// TODO Auto-generated method stub
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		JSONObject options = new JSONObject(config_options.getString("description"));
		String description = dataHash.get("description");
		String height = options.getString("height");
		VelocityContext vc = new VelocityContext();
		
		if("".equals(height.trim()) || "0".equals(height)) 		
			vc.put("description", description);
		 else{ 
			vc.put("description", description);
			vc.put("height", height+"px");
		}
					
		String template=configHash.get("global_template_description");
		if(template==null || "".equals(template.trim()))
		   template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_description");	
		
		return getVelocityOutPut(vc,template);
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException{
		// TODO Auto-generated method stub
		String descriptionIsRenderable = dataHash.get("description");
		if("".equals(descriptionIsRenderable.trim()))
			return false;
		return true;
	}

   private static String getVelocityOutPut(VelocityContext vc,String template){
   
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"description",template );
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("Exception in getVelocityOutPut for RenderDescriptionWidgetHTML ERROR: "+e.getMessage());
		}
		return str.toString();
	}
}
