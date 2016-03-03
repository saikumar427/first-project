package com.eventbee.widget;

import java.util.Date;
import java.util.HashMap;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.GenUtil;
import com.eventbee.layout.EventGlobalTemplates;
public class RenderFilesWidgetHTML implements RenderWidgetHTML{
	@Override
	public String getHTML(HashMap<String, String> refHash,
		HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException  {
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		JSONObject options = new JSONObject(config_options.getString("files"));
		VelocityContext vc = new VelocityContext();
		String eventid=refHash.get("eventid");
		vc.put("files", options);
		vc.put("eid", eventid);
		String template=configHash.get("global_template_files");
		if(template==null || "".equals(template.trim()))
			   template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_files");
		return getVelocityOutPut(vc,template);
	}
	
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException  {
		// TODO Auto-generated method stub
		JSONObject config_options_IsRenderable = new JSONObject(configHash.get("config_options"));
		JSONObject options_IsRenderable = new JSONObject(config_options_IsRenderable.getString("files"));
		JSONArray resultfile = new JSONArray(options_IsRenderable.getString("files"));
		if(resultfile.length()>0 ){
			if("".equals(resultfile.getJSONObject(0).getString("url"))){
				return false;
			}
			return true;
		}else{
			return false;
		}
		
	}
	
	private static String getVelocityOutPut(VelocityContext vc,String template){
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"files",template );
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("Exception in getVelocityOutPut for RenderFilesHTML ERROR: "+e.getMessage());
		}
		return str.toString();
	}
}
