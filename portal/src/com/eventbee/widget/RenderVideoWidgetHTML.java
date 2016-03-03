package com.eventbee.widget;

import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderVideoWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException {

		String refid = refHash.get("refid");
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		
		String video_url = config_options.getString("video_"+refid);
		String vid = "";
	try{
		  VelocityContext vc = new VelocityContext();
		  if(video_url.contains("youtube")|| video_url.contains("youtu.be")){
			  vid=video_url.split("/v/|v=|youtu.be/|embed/|u/\\w+/|/e/")[1].split("/[?&]/")[0];
			  vc.put("youtubeUrl", vid);			   
			}
		   else if(video_url.contains("vimeo")) {
			Pattern pattern = Pattern.compile("^.+vimeo.com\\/(.*\\/)?([^#\\?]*)");
			Matcher matcher = pattern.matcher(video_url);       
			vid = (matcher.find() ? matcher.group(2)  : "");
			vc.put("vimeoUrl", vid);
			}
		  String template=configHash.get("global_template_videos");
		  if(template==null || "".equals(template.trim()))
			  template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_videos");	
		return getVelocityOutPut(vc,template);
	  }catch(Exception e){System.out.println("exeception while loading videos tempalte"+e.getMessage());}
	return "";
	
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws Exception {
		
		String refid = refHash.get("refid");
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		
		String video_url = config_options.getString("video_"+refid);
		if("".equals(video_url.trim())|| video_url == null) {
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
			ve.evaluate(vc,out1,"videos",Template );			
			str=out1.getBuffer();	
		   }catch(Exception e){System.out.println("sociallikes tempalte exception: "+e.getMessage());}
			return str.toString();
	 }

}
