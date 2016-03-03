package com.eventbee.widget;

import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderPhotoWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException {

		String refid = refHash.get("refid");
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		JSONObject photoOptions = new JSONObject(config_options.getString("photo_"+refid));
		VelocityContext vc = new VelocityContext();		
		if(!"".equals(photoOptions.getString("link").trim())) {
			vc.put("photoLink", photoOptions.getString("link").trim());
			vc.put("photoUrl", photoOptions.getString("url").trim());
		} else vc.put("photoUrl", photoOptions.getString("url").trim());
	
		String template=configHash.get("global_template_photos");
        if(template==null || "".equals(template.trim()))
		template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_photos");	
		return getVelocityOutPut(vc,template);
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws Exception {
		
		String refid = refHash.get("refid");
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		JSONObject photoOptions = new JSONObject(config_options.getString("photo_"+refid));
		if(photoOptions.getString("url")==null || "".equals(photoOptions.getString("url").trim())) {
			return false;
			//throw new Exception();
		}
		return true;
	}
	private static String getVelocityOutPut(VelocityContext vc,String Template){		
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			ve.evaluate(vc,out1,"sociallikes",Template);			
			str=out1.getBuffer();			
		 }catch(Exception e){System.out.println("sociallikes tempalte exception: "+e.getMessage());}
			return str.toString();
	 }
}
