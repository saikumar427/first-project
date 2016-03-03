<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%!
 String DEFAULT_LABEL_TD_WIDTH="240";
 String DEFAULT_VALUE_TD_WIDTH="240";
 String DEFAULT_XMLNS_XF="http://apache.org/cocoon/xmlform/1.0";

 

 String getXFLabelTD(String width, String labelname, boolean isMandatory){
  StringBuffer sb=new StringBuffer("");
  sb.append("<td height='30' width='");
  if(width==null) 
  	sb.append(DEFAULT_LABEL_TD_WIDTH);
  else
	sb.append(width);
  sb.append("' class='inputlabel'>");
  
  sb.append(labelname);
  if (isMandatory)
	sb.append(" *");
  sb.append("</td>");
 return sb.toString();
}

 String getXFValueTD(String width, String content, boolean isMandatory){
  StringBuffer sb=new StringBuffer("");
  sb.append("<td height='30' width='");
  if(width==null) 
  	sb.append(DEFAULT_VALUE_TD_WIDTH);
  else
	sb.append(width);
  sb.append("' class='inputvalue'>");
  
  sb.append( (content==null)?"":content );
  sb.append("</td>");
 return sb.toString();
}

 String getXFHeaderTD(String colspan, String content){
  StringBuffer sb=new StringBuffer("");
  sb.append("<td colspan='");
  sb.append(GenUtil.getEncodedXML(colspan));
  sb.append("' class='subheader'>");
  sb.append(GenUtil.getEncodedXML(content));
  sb.append("</td>");
 return sb.toString();
}

 String getXfHeader(String[] vals){
        StringBuffer sb=new StringBuffer();
      	sb.append("<tr>");
        for (int i=0; i<vals.length; i++){ 
                sb.append("<td class='subheader' align='center'>"+GenUtil.getEncodedXML( vals[i]) +"</td>");
       }
       sb.append("</tr>");
       return sb.toString(); 

 }

 String getXfHeaderR(String[] vals){
        StringBuffer sb=new StringBuffer();
      	sb.append("<tr>");
        for (int i=0; i<vals.length; i++){ 
                sb.append("<td class='colheader'>"+ GenUtil.getEncodedXML(vals[i] )+"</td>");
        }
       sb.append("</tr>");
       return sb.toString(); 

 }

String getXfBoolean(String ref, String caption){
        StringBuffer sb=new StringBuffer();
	/*sb.append("<table><tr><td><selectBoolean ref='"+GenUtil.getEncodedXML(ref)+"' selectUIType='checkbox'>");
        sb.append("</selectBoolean></td>");
	sb.append("<td>"+caption+"</td></tr></table>");*/
	sb.append("<input type='checkbox' name='"+ref+"'");
	sb.append(" value='true'");
	sb.append(" />");
	if(caption !=null)
		sb.append(" "+caption);
	
	return sb.toString();
   }

   String getXfBoolean(String ref, String caption , String selcval){
        StringBuffer sb=new StringBuffer();
	/*sb.append("<table><tr><td><selectBoolean ref='"+GenUtil.getEncodedXML(ref)+"' selectUIType='checkbox'>");
        sb.append("</selectBoolean></td>");
	sb.append("<td>"+caption+"</td></tr></table>");*/
	sb.append("<input type='checkbox' name='"+ref+"'");
	sb.append(" value='true'");
	if("true".equals(selcval)){
		sb.append("  checked='checked'");
	}
	
	sb.append(" />");
	if(caption !=null)
		sb.append(" "+caption);
	
	return sb.toString();
   }

   
   
String getXfBoolean(String ref){
        StringBuffer sb=new StringBuffer();
	/*sb.append("<table><tr><td><selectBoolean ref='"ref+"' selectUIType='checkbox'>");
        sb.append("</selectBoolean></td>");
	sb.append("</tr></table>");
	*/
	sb.append("*******************************************************");
	return sb.toString();
   }
 
String getXfSelectListBox(String ref, String[] values, String[] captions, String defval){  
      return  WriteSelectHTML.getSelectHtml(captions, values, ref,defval,null,null,null);
   }

String getXfSelectOneRadio(String ref, String[] values, String[] captions,Map reqMap){
        StringBuffer sb=new StringBuffer();
	sb.append("<table>");
	if(values !=null){
		for(int i=0;i<values.length;i++){
			sb.append("<tr><td>");
			sb.append("<input type='radio' name='"+ref+"' onKeyPress='keypress(event,this)' ");
			sb.append("value='"+values[i] +"'"+     WriteSelectHTML.isRadioChecked(values[i],GenUtil.getHMvalue(reqMap ,ref)    ) );
			sb.append("/>");
			if(captions!=null){
				sb.append(captions[i]);
			}
			sb.append("</td></tr>");
		}
	}
	sb.append("</table>");   
	return sb.toString();
   }
   
  
   
   
   
   
   
   String getXfSelectOneRadio(String ref, String[] values, String[] captions,String selectedvl){
        StringBuffer sb=new StringBuffer();
	sb.append("<table>");
	if(values !=null){
		for(int i=0;i<values.length;i++){
			sb.append("<tr><td>");
			sb.append("<input type='radio' name='"+ref+"' onKeyPress='keypress(event,this)' ");
			sb.append("value='"+values[i] +"'"+     WriteSelectHTML.isRadioChecked(values[i],selectedvl   ) );
			sb.append("/>");
			if(captions!=null){
				sb.append(captions[i]);
			}
			sb.append("</td></tr>");
		}
	}
	sb.append("</table>");   
	return sb.toString();
   }
    String getXfSelectOneRadio(String ref, String[] values, String[] captions,String selectedvl,String script){
           StringBuffer sb=new StringBuffer();
   	sb.append("<table>");
   	if(values !=null){
   		for(int i=0;i<values.length;i++){
   			sb.append("<tr><td>");
   			sb.append("<input type='radio' name='"+ref+"' onKeyPress='keypress(event,this)' "+script);
   			sb.append("value='"+values[i] +"'"+     WriteSelectHTML.isRadioChecked(values[i],selectedvl   ) );
   			sb.append("/>");
   			if(captions!=null){
   				sb.append(captions[i]);
   			}
   			sb.append("</td></tr>");
   		}
   	}
   	sb.append("</table>");   
   	return sb.toString();
      }
   
   
   
   
   String getXfSelectOneRadio(String ref, String[] values, String[] captions,String selectedvl,String script,String idval){
              StringBuffer sb=new StringBuffer();
      	sb.append("<table>");
      	if(values !=null){
      		for(int i=0;i<values.length;i++){
      			sb.append("<tr><td>");
      			sb.append("<input type='radio' name='"+ref+"' id='"+idval+"'  onKeyPress='keypress(event,this)' "+script);
      			sb.append("value='"+values[i] +"'"+     WriteSelectHTML.isRadioChecked(values[i],selectedvl   ) );
      			sb.append("/>");
      			if(captions!=null){
      				sb.append(captions[i]);
      			}
      			sb.append("</td></tr>");
      		}
      	}
      	sb.append("</table>");   
      	return sb.toString();
      }
   
   
   
   
  
String getXfSelectOneCombo(String ref, String[] values, String[] captions,String defval){
     
	
	 return  WriteSelectHTML.getSelectHtml(captions, values, ref,defval,null,null,null);
	
	
   }
String getXfSelectMany(String ref, String[] values, String[] captions,Map reqMap){
        StringBuffer sb=new StringBuffer();
	
	String [] selectedvalarr=new String[0];
	
	
	sb.append("<table>");
	if(values !=null){
		for(int i=0;i<values.length;i++){
			sb.append("<tr><td>");
			sb.append("<input type='checkbox' name='"+ref+"' onKeyPress='keypress(event,this)'  ");
			String ischecked="";
			if( reqMap.get(ref) instanceof String){
				ischecked=WriteSelectHTML.isRadioChecked(values[i],GenUtil.getHMvalue(reqMap ,ref)    );
			}else{
				String[] selvalarr=(String[])reqMap.get(ref);
				if(selvalarr !=null)
				ischecked=GenUtil.isChecked( Arrays.asList(selvalarr), values[i]);
			}
			
			sb.append("value='"+values[i] +"' " +  ischecked  );
			sb.append("/>");
			
			/*if(captions!=null){
				sb.append("value='"+captions[i] +"' ");
			}*/
			sb.append("</td></tr>");
		}
	}
	sb.append("</table>");
	
	
	return sb.toString();
   }

   
   
   String getXfSelectMany(String ref, String[] values, String[] captions,String[] selvalarr){
        StringBuffer sb=new StringBuffer();
	
	String [] selectedvalarr=new String[0];
	
	
	sb.append("<table>");
	if(values !=null){
		for(int i=0;i<values.length;i++){
			sb.append("<tr><td>");
			sb.append("<input type='checkbox' name='"+ref+"' onKeyPress='keypress(event,this)' ");
			String ischecked="";
			if(selvalarr !=null)
				ischecked=GenUtil.isChecked( Arrays.asList(selvalarr), values[i]);
			if(ischecked.length()>0) ischecked="checked=''";
			sb.append("value='"+values[i] +"' " +  ischecked  );
			sb.append("/>");
			if(captions!=null)
				sb.append(GenUtil.getEncodedXML(captions[i]) );
			sb.append("</td></tr>");
		}
	}
	sb.append("</table>");
	
	
	return sb.toString();
   }

 String getXfSelectMany(String ref, String[] values, String[] captions,String[] selvalarr,String script){
        StringBuffer sb=new StringBuffer();
	
	String [] selectedvalarr=new String[0];
	
	
	sb.append("<table>");
	if(values !=null){
		for(int i=0;i<values.length;i++){
			sb.append("<tr><td>");
			sb.append("<input type='checkbox' name='"+ref+"' onKeyPress='keypress(event,this)' "+script);
			String ischecked="";
			if(selvalarr !=null)
				ischecked=GenUtil.isChecked( Arrays.asList(selvalarr), values[i]);
			if(ischecked.length()>0) ischecked="checked=''";
			sb.append("value='"+values[i] +"' " +  ischecked  );
			sb.append("/>");
			if(captions!=null)
				sb.append(GenUtil.getEncodedXML(captions[i]) );
			sb.append("</td></tr>");
		}
	}
	sb.append("</table>");
	
	
	return sb.toString();
   }  
   
   
   
   String getXfSelectMany(String ref, String[] values, String[] captions,String[] selvalarr,String script,String idval){
           StringBuffer sb=new StringBuffer();
   	
   	String [] selectedvalarr=new String[0];
   	
   	
   	sb.append("<table>");
   	if(values !=null){
   		for(int i=0;i<values.length;i++){
   			sb.append("<tr><td>");
   			sb.append("<input type='checkbox' name='"+ref+"' id='"+idval+"' onKeyPress='keypress(event,this)' "+script);
   			String ischecked="";
   			if(selvalarr !=null)
   				ischecked=GenUtil.isChecked( Arrays.asList(selvalarr), values[i]);
   			if(ischecked.length()>0) ischecked="checked=''";
   			sb.append("value='"+values[i] +"' " +  ischecked  );
   			sb.append("/>");
   			if(captions!=null)
   				sb.append(GenUtil.getEncodedXML(captions[i]) );
   			sb.append("</td></tr>");
   		}
   	}
   	sb.append("</table>");
   	
   	
   	return sb.toString();
      }  
   
   
   
   
   
   
   
   
String getXfWriteOneRow(String[] values){
	StringBuffer sb=new StringBuffer();
	for(int i=0;i<values.length;i++){
        	sb.append("<td class='subheader'>");
		sb.append(values[i]);
        	sb.append("</td>");
	}

	return sb.toString();
  }

String getXfWriteOneRowData(String[] values){
	StringBuffer sb=new StringBuffer();
	for(int i=0;i<values.length;i++){
        	sb.append("<td class='data'>");
		sb.append(values[i]);
        	sb.append("</td>");
	}

	return sb.toString();
  }

String getXfOutput(String ref, String caption){
        StringBuffer sb=new StringBuffer();
      	//sb.append("<output ref='"+ref+"'>");
        if(caption!=null)
		sb.append(GenUtil.getEncodedXML(caption) );
    	//sb.append("</output>");
    	return sb.toString(); 
  }

 String getXfOutput(String caption){
        StringBuffer sb=new StringBuffer();
        
        if(caption!=null)
          	sb.append(caption);
        
	return sb.toString(); 
   }

   String getXfTextArea(String ref, String caption, String rows, String cols){
	StringBuffer sb=new StringBuffer();
      	sb.append("<textarea rows='"+GenUtil.getEncodedXML(rows)+"' cols='"+GenUtil.getEncodedXML(cols)+"' name='"+GenUtil.getEncodedXML(ref)+"'>");
	if(caption!=null)
		sb.append(caption);
    	sb.append("</textarea>");
    	return sb.toString(); 
   }

  String getXfTextAreaRO(String ref, String caption, String rows, String cols){
	StringBuffer sb=new StringBuffer();
      	sb.append("<textarea rows='"+GenUtil.getEncodedXML(rows)+"' cols='"+GenUtil.getEncodedXML(cols)+"' name='"+GenUtil.getEncodedXML(ref)+"' readonly='true' >");
	if(caption!=null)
		sb.append(caption );
    	sb.append("</textarea>");
    	return sb.toString(); 
   }

  String getXfTextBox(String ref, String caption, String size){
  
	StringBuffer sb=new StringBuffer();
      	sb.append("<input type='text' size='"+GenUtil.getEncodedXML(size)+"' name='"+GenUtil.getEncodedXML(ref)+"' onKeyPress='keypress(event,this)'");
	if(caption!=null)
		sb.append(" value='"+GenUtil.getEncodedXML(caption)+"'" );
    	
    	sb.append(" />");
    	return sb.toString(); 
   }
 
   String getXfTextBox(String ref, String caption, String size, Map reqMap){
  
	StringBuffer sb=new StringBuffer();
      	sb.append("<input type='text' size='"+GenUtil.getEncodedXML(size)+"' name='"+GenUtil.getEncodedXML(ref)+"' onKeyPress='keypress(event,this)' ");
	if(caption!=null)
		sb.append(" value='"+GenUtil.getHMvalue(reqMap ,ref, GenUtil.getEncodedXML(caption))+"'" );
    	
    	sb.append(" />");
    	return sb.toString(); 
   }
   
   
   
  String getXfTextBox(String ref, String caption, String size, String Attributes)
   {
	StringBuffer sb=new StringBuffer();
      	sb.append("<input type='text' size='"+size+"'  name='"+GenUtil.getEncodedXML(ref)+"' onKeyPress='keypress(event,this)' ");
	if(Attributes!=null)
		sb.append(Attributes);
    	
	if(caption!=null)
		sb.append(" value='"+GenUtil.getEncodedXML(caption)+"'" );
    	
	sb.append(" />");
	
    	return sb.toString(); 
   }

  String getXfPassWord(String ref, String caption, String size){
	return "<input type='password' name='"+ref+"' value='"+( (caption!=null)?caption:"" )+"'  size='"+( (size!=null)?size:"20" )+"' onKeyPress='keypress(event,this)'  />";
    	
   }
   
   String getXfPassWord(String ref, String caption, String size, Map reqMap){
	return "<input type='password' name='"+ref+"' value='"+( (caption!=null)?caption:"" )+"'  size='"+( (size!=null)?size:"20" )+"'  onKeyPress='keypress(event,this)' />";
    	
   }

  String getXfHidden(String ref, String val){
         StringBuffer sb=new StringBuffer();
        
	 sb.append("<input type='hidden' name='"+ref+"' value='"+( (val!=null)?val:"" )+"' />");
         return sb.toString();
   }
  String getXFButton(String id, String caption, String hint){
 	StringBuffer sb=new StringBuffer();
	//WriteXFTags.getXFButton("prev","Previous","Go to Prev page")
	//<input value="Next" type="submit" name="cocoon-action-next" class="button" title="Go to Next Page" />
	sb.append("<input type='submit' name='cocoon-action-"+id+"' value='"+caption+"' class='button' />");
	
        return sb.toString();
   }

String getXfSelectListBox(String nameofsel,String[] optionDisp, String[] optionVal,  
String defaultVal,String script){
StringBuffer sb=new StringBuffer();
sb.append("<select name='"+nameofsel+"'  "+script+">");
for(int i=0;i<optionDisp.length;i++){
if(optionVal[i].equals(defaultVal)){
sb.append("<option value='"+optionVal[i]+"' selected='selected'      >"+optionDisp[i]+"</option>");
}else{
sb.append("<option value='"+optionVal[i]+"'>"+optionDisp[i]+"</option>");
}
}

sb.append("</select>");

return sb.toString();

}










   
%>
