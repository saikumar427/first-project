package com.eventbee.layout;

import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.widget.RenderWidgetHTML;

public class EventPageRenderer {
	
	private static String getMethodName(String widgetid) {
		return "Render" + Character.toUpperCase(widgetid.charAt(0)) + widgetid.substring(1) + "WidgetHTML";
	}

	public static String getWidgetHTML(String widgetid, String title,String eventid,HashMap<String,String>refHash,HashMap<String,String>dataHash,HashMap<String,String>configHash) throws JSONException {
		StringBuffer buffer = new StringBuffer("<div class=\"widget\"");
		try {
			JSONObject currentWidgetStyle =  new JSONObject((new JSONObject(configHash.get("styles"))).getString(widgetid));
			//System.out.println("STYLE::>>"+currentWidgetStyle);
			Boolean isGlobal = currentWidgetStyle.getBoolean("global");
			Boolean hideHeader = currentWidgetStyle.getBoolean("hideHeader");
			JSONObject radius = currentWidgetStyle.getJSONObject("radius");
			String headingBackground = currentWidgetStyle.getString("header");
			String headingText = currentWidgetStyle.getString("headerText");
			String border = currentWidgetStyle.getString("border");
			String contentBackground = currentWidgetStyle.getString("content");
			String contentText = currentWidgetStyle.getString("contentText");
			String topLeft = radius.getString("topLeft");
			String topRight = radius.getString("topRight");
			String bottomRight = radius.getString("bottomRight");
			String bottomLeft = radius.getString("bottomLeft");
			
			
			if(!isGlobal) {
				if("".equals(title))
					hideHeader=true;
				
				
				System.out.println("the hide heafer is::"+hideHeader);
				
				buffer.append(" style=\"border: 1px solid "+border+";" +
						"-webkit-border-top-left-radius: "+topLeft+";" +
						"-webkit-border-top-right-radius: "+topRight+";" +
						"-webkit-border-bottom-right-radius: "+bottomRight+";" +
						"-webkit-border-bottom-left-radius: "+bottomLeft+";" +
						"-moz-border-radius-topleft: "+topLeft+";" +
						"-moz-border-radius-topright: "+topRight+";" +
						"-moz-border-radius-bottomright: "+bottomRight+";" +
						"-moz-border-radius-bottomleft: "+bottomLeft+";" +
						"border-top-left-radius: "+topLeft+";" +
						"border-top-right-radius: "+topRight+";" +
						"border-bottom-right-radius: "+bottomRight+";" +
						"border-bottom-left-radius: "+bottomLeft+";\">");
				if(hideHeader) {
					
					buffer.append("<h2 style=\"display:none;background-color:"+headingBackground+";color:"+headingText+";border-bottom:1px solid "+border+";" +
							"-webkit-border-top-left-radius: "+topLeft+";" +
							"-webkit-border-top-right-radius: "+topRight+";" +
							"-moz-border-radius-topleft: "+topLeft+";" +
							"-moz-border-radius-topright: "+topRight+";" +
							"border-top-left-radius: "+topLeft+";" +
							"border-top-right-radius: "+topRight+";\">&nbsp;"+title+"</h2>");
					buffer.append("<div class=\"widget-content\" style=\"background-color:"+contentBackground+";color:"+contentText+";" +
							"-webkit-border-top-left-radius: "+topLeft+";" +
							"-webkit-border-top-right-radius: "+topRight+";" +
							"-moz-border-radius-topleft: "+topLeft+";" +
							"-moz-border-radius-topright: "+topRight+";" +
							"border-top-left-radius: "+topLeft+";" +
							"border-top-right-radius: "+topRight+";");
				} else {
				
					buffer.append("<h2 style=\"background-color:"+headingBackground+";color:"+headingText+";border-bottom:1px solid "+border+";" +
							"-webkit-border-top-left-radius: "+topLeft+";" +
							"-webkit-border-top-right-radius: "+topRight+";" +
							"-moz-border-radius-topleft: "+topLeft+";" +
							"-moz-border-radius-topright: "+topRight+";" +
							"border-top-left-radius: "+topLeft+";" +
							"border-top-right-radius: "+topRight+";\">&nbsp;"+title+"</h2>");
					buffer.append("<div class=\"widget-content\" style=\"background-color:"+contentBackground+";color:"+contentText+";");
				}
				buffer.append("-webkit-border-bottom-right-radius: "+bottomRight+";" +
						"-webkit-border-bottom-left-radius: "+bottomLeft+";" +
						"-moz-border-radius-bottomright: "+bottomRight+";" +
						"-moz-border-radius-bottomleft: "+bottomLeft+";" +
						"border-bottom-right-radius: "+bottomRight+";" +
						"border-bottom-left-radius: "+bottomLeft+";\">");
			} else {
				if("".equals(title))
					{buffer.append("><h2 style='display:none;'></h2>");
				     buffer.append("<div class=\"widget-content widget-content-ntitle\">");
					}
				     
				else{
					if("tickets".equals(widgetid)){
						buffer.append("><h2 id=\"pageheader\">&nbsp;"+title+"</h2>");
					}else
						buffer.append("><h2>&nbsp;"+title+"</h2>");
				     buffer.append("<div class=\"widget-content\">");
					}
			}
			
		} catch(Exception e) {
			if("".equals(title)){
				buffer.append("><h2 style='display:none;'></h2>");
				buffer.append("<div class=\"widget-content widget-content-ntitle\">");
			}
		     
			else{
				if("tickets".equals(widgetid)){
					buffer.append("><h2 id=\"pageheader\">&nbsp;"+title+"</h2>");
				}else
					buffer.append("><h2>&nbsp;"+title+"</h2>");
				buffer.append("<div class=\"widget-content\">");
			}
		}
		
		String refid = "";
		if(widgetid.contains("_")) {
			refid = widgetid.split("_")[1];
			refHash.put("refid", refid);
			widgetid = widgetid.split("_")[0];
		}
		try {
			RenderWidgetHTML widgetRenderer = (RenderWidgetHTML) Class.forName("com.eventbee.widget." + getMethodName(widgetid)).newInstance();
			if(!widgetRenderer.IsRenderable(refHash, dataHash, configHash))
				return "";
			else {
				System.out.println("getMethodName(widgetid):"+getMethodName(widgetid));
				try {
					buffer.append(widgetRenderer.getHTML(refHash, dataHash, configHash));					
				} catch(Exception e) {
					
					System.out.println("not in catch case-------------------->"+e.getMessage());
					/*JSONObject config_options = new JSONObject(configHash.get("config_options"));
					if(!"".equals(refid))
						config_options.put(widgetid+"_"+refid, DBHelper.getWidgetOptions(eventid, widgetid+"_"+refid,refHash.get("stage")));
					else
					/*if("draft".equalsIgnoreCase(refHash.get("stage")))
						config_options.put(widgetid, DBHelper.getWidgetOptions(eventid, widgetid,refHash.get("stage")));
					else{
						//if final version already widgets options will be there in config options, data has included at  event layout page
					}
					configHash.put("config_options",config_options.toString());*/
					//buffer.append(widgetRenderer.getHTML(refHash, dataHash, configHash));
				}
			}
		} catch(Exception e) {
			if("draft".equals(refHash.get("stage")))
			buffer.append("<pre style='color:maroon;font-size:12px;'>Error: This widget was misconfigured<pre>");
		}
		buffer.append("<div style='clear:both'></div></div><!--widget-content close --><div style='clear:both'></div></div><!--widget close -->");
		return buffer.toString();
	}
	
	public static JSONObject getWidgetsHTML(JSONArray widgets,String eventid,HashMap<String,String>refHash,HashMap<String,String>dataHash,HashMap<String,String>configHash)throws Exception {
		System.out.println("the widgets are::"+widgets);
		JSONObject widget;
		String next;
		//StringBuffer html = new StringBuffer();
		JSONObject jsonObj=new JSONObject();
		for(int i=0;i<widgets.length();i++) {
			widget = widgets.getJSONObject(i);
			Iterator<?> iter = widget.keys();
			while(iter.hasNext()) {
				next = (String)iter.next();
				//html.append(getWidgetHTML(next,widget.getString(next),eventid,refHash,dataHash,configHash));
				jsonObj.put(next, getWidgetHTML(next,widget.getString(next),eventid,refHash,dataHash,configHash));
			}
			
		}
		//return html.toString();
		return jsonObj;
	}
}