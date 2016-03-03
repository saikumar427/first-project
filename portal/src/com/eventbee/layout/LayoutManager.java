package com.eventbee.layout;

import java.util.ArrayList;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;


public class LayoutManager { 
	
	public static String getWidgetHTML(String widgetId, String title, Boolean isDeletable,Boolean ishide) {
		StringBuffer html = new StringBuffer("<div class=\"dragbox well\" id=\""+widgetId+"\">"+"<span class='chtitle'>"+title);
		html.append("&nbsp;<span class=\"layouthelp\"><i class='fa fa-info-circle' style='position: relative; top: 3px;'></i></span></span><div class=\"dragbox-content pull-right\">");
		html.append("<i class='fa fa-paint-brush fa-3' data-toggle='tooltip' title='Look & Feel' id='lookandfeel'></i>");
		html.append("<i class='fa fa-cog' data-toggle='tooltip' title='Options' id='options'></i>");
		if(isDeletable)
			{html.append("<i class='fa fa-trash-o' data-toggle='tooltip' title='Delete' id='delete'></i>");
			 if(ishide)
			 html.append("<i class='fa fa-eye' data-toggle='tooltip' title='Show' id='hide'></i>");
			 else
			 html.append("<i class='fa fa-eye-slash' data-toggle='tooltip' title='Hide' id='hide'></i>");
			
			}
		html.append("</div></div>");
		return html.toString();
	}
	
	/*public static String getWidgetHTML(String widgetId, String title, Boolean isDeletable,Boolean ishide) {
		StringBuffer html = new StringBuffer("<div class='well'><div class=\"dragbox\" id=\""+widgetId+"\">"+"<span class='chtitle'>"+title);
		html.append("&nbsp;<span class=\"layouthelp\"><img src=\"../images/questionMark.gif\" /></span></span><div class=\"dragbox-content pull-right\">");
		html.append("<button id=\"lookandfeel\">Look &amp; feel</button>");
		html.append("<button id=\"options\">Options</button>");
		if(isDeletable)
			{html.append("<button id=\"delete\">Delete</button>");
			 if(ishide)
			 html.append("<button id=\"hide\">Show</button>");
			 else
			 html.append("<button id=\"hide\">Hide</button>");
			
			}
		html.append("</div></div></div>");
		return html.toString();
	}*/
	
	public static String getColumnWidgetsHTML(JSONArray widgets,JSONObject hidewidgets)throws Exception {
		JSONObject widget;
		String next;
		StringBuffer html = new StringBuffer();
		for(int i=0;i<widgets.length();i++) {
			widget = widgets.getJSONObject(i);
			Iterator<?> iter = widget.keys();
			while(iter.hasNext()) {
				next = (String)iter.next();
				if("tickets".equals(next))
					html.append(getWidgetHTML(next, widget.getString(next), false,hidewidgets.has(next) /*tickets widget cannot be deleted*/));
				else
					html.append(getWidgetHTML(next, widget.getString(next), true,hidewidgets.has(next)));
			}
		}
		
		System.out.println("the getColumnWidgetsHTML::"+html);
		return html.toString();
	}
	
	public static JSONArray concatArray(JSONArray...arrs) throws Exception {
		
		
		JSONArray result = new JSONArray();
		for (JSONArray arr : arrs){
			//System.out.println("arrssss:::"+arr);
			for (int i = 0; i < arr.length(); i++)
				result.put(arr.get(i));
		}
		return result;
	}
	
	
public static JSONObject concatArrays(JSONArray...arrs) throws Exception {
		
		
	JSONObject object = new JSONObject();
		for (JSONArray arr : arrs){
			//System.out.println("arrssss:::"+arr);
			for (int i = 0; i < arr.length(); i++){
				JSONObject posts = (JSONObject) arr.get(i);
				
				Iterator keysToCopyIterator = posts.keys();
				ArrayList<String> keys = new ArrayList<String>();
				while(keysToCopyIterator.hasNext()) {
				    String key = (String) keysToCopyIterator.next();
				    keys.add(key);
				}
				
				for(int j=0;j<keys.size();j++){
					object.put(keys.get(j),posts.get(keys.get(j)));
				}
				
			}
		}
		//System.out.println("the obecyts::"+object);
		return object;
	}
	
	
}
