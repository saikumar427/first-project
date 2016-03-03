package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderFbcommentsWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException {
		
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		VelocityContext vc = new VelocityContext();
		JSONObject data = new JSONObject(config_options.getString("fbcomments"));

		String colorScheme = data.getString("colorscheme");
		String numPosts = data.getString("numposts");
		String eventUrl=refHash.get("serveraddress")+"/event?eid="+refHash.get("eventid");
		vc.put("colorScheme", colorScheme);
		vc.put("numPosts", numPosts);
		vc.put("eventUrl", eventUrl);
		String template=configHash.get("global_template_fbcomments");
		if(template==null || "".equals(template.trim()))
			template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_fbcomments");	
	
		return getVelocityOutPut(vc,template);
		
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) {
		
		return true;
	}
	private static String getVelocityOutPut(VelocityContext vc,String Template){		
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			ve.evaluate(vc,out1,"fbcommnets",Template );		
			
			str=out1.getBuffer();			
		 }catch(Exception e){System.out.println("sociallikes tempalte exception: "+e.getMessage());}
			return str.toString();
	 }
}
