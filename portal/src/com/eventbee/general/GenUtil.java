package com.eventbee.general;
import java.util.*;
import java.text.*;
import java.sql.*;
import javax.servlet.http.HttpServletResponse;
import java.io.*;



public class  GenUtil{

public static final SimpleDateFormat SDF=new SimpleDateFormat("MM/dd/yyyy");

public static String getHMvalue(HashMap hm,String key){
	return getHMvalue((Map) hm,key);
}
public static String getHMvalue(HashMap hm,String key,String defval){
	return getHMvalue((Map)hm,key,defval,false);
}
public static String getHMvalue(HashMap hm,String key,String defval,boolean encode){
	return getHMvalue((Map)hm,key,defval,encode);
}

public static String getHMvalue(Map hm,String key){
	return getHMvalue(hm,key,null,false);
}
public static String getHMvalue(Map hm,String key,String defval){
		return getHMvalue(hm,key,defval,false);
}
public static String getHMvalue(Map hm,String key,String defvalue,boolean encode){

	String rtval="";
	if(defvalue==null) defvalue="";
	defvalue=defvalue.trim();
	if(hm==null || hm.isEmpty()){
		rtval=defvalue;
	}else if(key==null || "".equals(key.trim())){
		rtval=defvalue;
	}else{
		String temp=(String) hm.get(key);
		if(temp==null || "".equals(temp)){
			rtval=defvalue;
		}else{
			rtval=temp;
		}
	}
	if(encode)
		return getEncodedXML(rtval);
	else
		return rtval;
}

public static String  getDataFromHash(Map datahash, String key, String defaul){
String value=defaul;
if(datahash!=null && key !=null){
	if(datahash.get(key) !=null){
		Object obj=datahash.get(key);
		 if( obj instanceof java.util.Date)return getDateString( (java.util.Date)obj );
		 else return obj.toString();
	}
}
return value;
}



public static String getDateString(java.util.Date date){
	String dat="";
	if(date!=null){
		dat=SDF.format(date);
	}

	return dat;

}

public static Object getObj(Object obj, Vector vec){

	Object obj1=null;
	if(vec!= null && obj !=null){
		if(vec.contains(obj)){
			obj1=vec.elementAt(vec.indexOf(obj));
		}
	}

	return obj1;

}



public static String getInitCapString(String str){
		String str1=null;
		if(str!=null  ){
			str1=str.trim();
			if(str1.length()>0)
			str1=(str1.substring(0,1)).toUpperCase()+str1.substring(1);
		}
		return str1;
}



public static String[] getKeysArray(HashMap hm){

if(hm==null|| hm.size()==0)return new String[0];
return (String[])hm.keySet().toArray(new String[0]);

}

public static String[] strToArrayStr(String schdatestr,String delim){
	return strToArrayStr(schdatestr,delim,false);
}

public static String[] strToArrayStr(String schdatestr,String delim,boolean returnDelims){
		if(schdatestr==null)return new String[]{""};
		StringTokenizer st = new StringTokenizer(schdatestr,delim,returnDelims);
		String[] datestra=new String[st.countTokens()];
		for(int i=0;i<datestra.length;i++){
			datestra[i]=((String)st.nextToken());
		}
		return datestra;
	}

public static String stringArrayToStr(String[] stra,String delim){

    String res="";
	if(stra!=null&&stra.length>0){
		StringBuffer resb=new StringBuffer("");
		if(delim==null)delim=",";
		for(int i=0;i<stra.length;i++){

		if(stra[i]!=null)
		resb.append(stra[i].trim()+delim);
	     }
        if(resb.length()>0)
		res=resb.substring(0, resb.lastIndexOf(delim) );

	}

return res;

}

//System.arraycopy(Object src, int srcPos, Object dest, int destPos, int length)
	public static String[] getNewArray(String[] oldarray,String newelement,int index){
		String[] newarray=null;

		if(index>oldarray.length)index=oldarray.length;

		if(oldarray !=null  ){
			newarray=new String[oldarray.length+1];


			if(newarray.length==1)return new String[]{newelement};

			if(newarray.length>1){
				newarray[index]=newelement;
				System.arraycopy( oldarray, 0, newarray ,0 , index);
				System.arraycopy( oldarray, index, newarray ,index+1 ,newarray.length-index-1 );

			}
		}else{
			System.out.println("GenUtil.getNewArray method passed array is null or index out of range");
		}

		return newarray;

	}





public static String stringArrayToStrWithQuotes(String[] stra,String delim,String quotes){
		String res="";
		if(quotes==null)quotes="\"";
			if(stra!=null&&stra.length>0){
				StringBuffer resb=new StringBuffer("");
				if(delim==null)delim=",";
				for(int i=0;i<stra.length;i++){
				if(stra[i]!=null)
				resb.append(quotes+stra[i].trim()+quotes+delim);
			}
			    if(resb.length()>0)
				res=resb.substring(0, resb.lastIndexOf(delim) );
			}

		return res;

}

public static String arrayToString(String[] arr){
	return 	arrayToString(arr,",",-1);
}
public static String arrayToString(String[] arr,String delim,int limit){

	String str="";
	if(arr!=null && arr.length>0){
		if(limit!=-1){
			for(int i=0;i<arr.length && i<limit;i++){
				if(arr[i]!=null && !("".equals(arr[i]))){
					str+=arr[i];
					if(i!=arr.length-1 && i!=limit-1) str+=delim;
				}else
					limit++;
			}
		}else{
			for(int i=0;i<arr.length;i++){
				if(arr[i]!=null && !("".equals(arr[i]))){
					str+=arr[i];
					if(i!=arr.length-1) str+=delim;
				}
			}
		}
	}
	return str;
}

public static String traverseString(String str,String searchval,String repval){
	return traverseString(str,searchval,repval,repval,repval);
}
public static String traverseString(String str,String searchval,String repval,String startval,String endval){
	if(str!=null && !("".equals(str.trim()))){

		if(repval==null) repval=" ";
		if(searchval!=null && !("".equals(searchval))){
			while(str.indexOf(searchval)!=-1){
				str=str.replaceAll(searchval,repval);
			}
		}

		if(endval!=null && !("".equals(endval))){
			while(str.endsWith(startval)){
				str=str.substring(0,str.length()-1);
			}
		}

		if(startval!=null && !("".equals(startval))){
			while(str.startsWith(endval)){
				str=str.substring(1,str.length());
			}
		}
	}
	else
		str="";
	return str;
}

public static String encodeAmpersand(String mes){
		if(mes==null) return "";
		//return mes.replaceAll("&","&amp;");
		return getProcessdString( mes);
}

/* narayan new */
public static String getProcessdString(String str){
		/*StringBuffer sb=new StringBuffer(str);
		//processString(sb,"&nbsp;","&#160;");
		processAmp( sb);
		return sb.toString();*/
		StringBuffer sb=new StringBuffer(str);
		processAmp( sb);
		str=sb.toString().replaceAll("&amp;amp;","&amp;");
		str=str.replaceAll("&amp;gt;","&gt;");
		str=str.replaceAll("&amp;lt;","&lt;");
		str=str.replaceAll("&amp;apos;","&apos;");
		str=str.replaceAll("&amp;quot;","&quot;");
		return str;



	}


public static 	 void processString(StringBuffer sb,String searchFor, String replaceWith){
		while(sb.indexOf(searchFor) !=-1){
			sb.replace(sb.indexOf(searchFor),sb.indexOf(searchFor)+searchFor.length(),   replaceWith);
		}
	}

	public static void processAmp(StringBuffer sb){


		/*int oldindex=sb.indexOf("&");
		boolean loop=true;
		if(oldindex !=-1){
			do{
				if( sb.charAt(oldindex+1 ) !='#' ){
					sb.replace(oldindex,oldindex+1,"&amp;");
				}
				int newindex=sb.indexOf("&",oldindex+1);
				if(newindex!=-1){
					oldindex=newindex;
					loop=true;
				}else{
					loop=false;
				}

			}while(loop);
		}*/

		int oldindex=sb.indexOf("&");
		boolean loop=true;
		if(oldindex !=-1){
			do{

				if(oldindex+1<sb.length() && sb.charAt(oldindex+1 ) =='#' ){
					int semicolindex=sb.indexOf(";",oldindex+1);

					if(semicolindex !=-1){
						CharSequence charseq=sb.subSequence(oldindex+2, semicolindex);
						try{
							int charnum=Integer.parseInt(charseq.toString());
							if(charnum>126 && charnum<160){
								sb.replace(oldindex,oldindex+1,"&amp;");
								//System.out.println("invalid char, between 127 and 160");
							}
						}catch(Exception exp){
							sb.replace(oldindex,oldindex+1,"&amp;");
						}

					}else{
					sb.replace(oldindex,oldindex+1,"&amp;");
					}

				}else{
					sb.replace(oldindex,oldindex+1,"&amp;");
				}
				int newindex=sb.indexOf("&",oldindex+1);
				if(newindex!=-1){
					oldindex=newindex;
					loop=true;
				}else{
					loop=false;
				}

			}while(loop);
		}
	}

	/**********narayan new */



public static String decodeAmpersand(String mes){
		if(mes==null) return "";
		return mes.replaceAll("&amp;","&");
}

public static String getEncodedStr(String mes){
		return encodeAmpersand( decodeAmpersand( mes));
}

public static String getCSVData(String [] str)
{
String st1="";
for(int i=0;i<str.length;i++)
{
if(("".equals(str[i]))||(str[i])==null)
{
}
else{
st1=st1+str[i].trim()+", ";
}
}
if(!("".equals(st1)))
{
st1=st1.trim();
if(!"".equals(st1.trim()))
st1=st1.substring(0,st1.length()-1);
}
return st1;
}



public static void main(String args[]) throws Exception{

Map hm=new HashMap();
hm.put("t1","ttttt");
hm.put("t2","t22222");
hm.put("t3","t33333");
/*String[] tests=getKeysArray( hm);
System.out.println(tests[2]);
System.out.println(tests.length);
System.out.println(hm.get(tests[2]));
*/

System.out.println(getSelectHtml( hm,"nameofsel", "t2"));
System.out.println(stringArrayToStrWithQuotes(new String[]{"abc","xyz"}, null , null ) );

}// end of main


/*narayan*/


public static String getSelectHtml(Map map,String nameofsel,String defsel){

	return getSelectHtml(map,nameofsel,defsel,null);

}

public static String getSelectHtml(Map map,String nameofsel,String defsel,String attr){

	if(map==null)return "";
	Set set=map.entrySet();

	StringBuffer sb=new StringBuffer();
	sb.append("<select name='"+nameofsel+"' ");
	if(attr!=null)
		sb.append(attr+" >");
	else
		sb.append(" >");

	for( Iterator iter=set.iterator();iter.hasNext();){
		Map.Entry me=(Map.Entry)iter.next();
		String key=me.getKey().toString();
		String val=me.getValue().toString();
		sb.append("<option value='"+getEncodedHTML(key)+"'  "+ isSelectSelected(key,defsel)+" >"+getEncodedXML(val)+"</option>");
	}
	sb.append("</select>");
	return sb.toString();

}


public static String getSelectHtml(String[] names,String[] values,String nameofsel,String defsel){
	if(names==null) return "";
	StringBuffer sb=new StringBuffer();
	sb.append("<select name='"+nameofsel+"' >");
	for( int i=0;i<names.length;i++){
		sb.append("<option value='"+getEncodedHTML(values[i])+"'  "+ isSelectSelected(values[i],defsel)+" >"+getEncodedXML(names[i])+"</option>");
	}
	sb.append("</select>");
	return sb.toString();
 }

public static String isSelectSelected(String curr,String pre){
	String str="";
	if(curr.equals(pre))str="selected='selected'";
		return str;
}


//GenUtil.isChecked(List list, String pre)
public static String isChecked(List list, String pre){
String str="";
if(list != null && pre !=null){
	if(list.size()>0)
	if(list.contains(pre))str="checked='checked'";
}

return str;
}




	public static String XMLEncode(String mes){
		if(mes==null) return "";
		//mes=mes.replaceAll("&","&amp;");
		mes=getProcessdString( mes);
		mes=mes.replaceAll("\"","&quot;");
		mes=mes.replaceAll("'","&apos;");
		mes=mes.replaceAll(">","&gt;");
		return mes.replaceAll("<","&lt;");
	}

	public static String AllXMLEncode(String mes){
		if(mes==null) return "";
		mes=mes.replaceAll("&","&amp;");
		mes=getProcessdString( mes);
		mes=mes.replaceAll("\"","&quot;");
		mes=mes.replaceAll("'","&apos;");
		mes=mes.replaceAll(">","&gt;");
		return mes.replaceAll("<","&lt;");
	}



	public static String XMLDecode(String mes){
		if(mes==null) return "";
		mes=mes.replaceAll("&amp;","&");
		mes=mes.replaceAll("&quot;","\"");
		mes=mes.replaceAll("&apos;","'");
		mes=mes.replaceAll("&gt;",">");
		return mes.replaceAll("&lt;","<");
	}

	public static String getEncodedXML(String mes){
		//return XMLEncode( XMLDecode(mes));
		return getEncodedLT(mes);
	}

	public static String getEncodedLT(String mes){
		if(mes==null) return "";
		return mes.replaceAll("<","&lt;");
	}

	public static String HTMLEncode(String mes){
		return encodeAmpersand(mes);
	}

	public static String HTMLDecode(String mes){
		return decodeAmpersand(mes);
	}

	public static String getEncodedHTML(String mes){
		return HTMLEncode( HTMLDecode(mes));
	}

	public static String processTextHtml(String data,boolean encodeXML) throws Exception{
		if(encodeXML)
			return processTextHtml(getEncodedXML(data));
		else
			return processTextHtml(data);
	}

	public static String processTextHtml(String data) throws Exception{
		StringBuffer sb=new StringBuffer();
		data=data.replaceAll("\\n"," <br/> ");
		String[] st=strToArrayStr(data," ",true);
		int stsize=st.length;
		String temp=null;
		for(int i=0;i<stsize;i++){
			temp=st[i].toLowerCase();
			if((temp.startsWith("http://"))||(temp.startsWith("https://"))){
				sb.append("<a href='"+st[i]+"'>"+st[i]+"</a>");
			}else	if((EventBeeValidations.isValidEmail(st[i],"")).getStatus()){
				sb.append("<a href='mailto: "+st[i]+"'>"+st[i]+"</a>");
			}else{
				sb.append(st[i]);
			}
		}
		return sb.toString();
	}

	public static String textToHtml(String data) {
		StringBuffer sb=new StringBuffer();
		data=data.replaceAll("\\n"," <br/> ");
		String[] st=strToArrayStr(data," ",true);
		int stsize=st.length;
		String temp=null;
		for(int i=0;i<stsize;i++){
			temp=st[i].toLowerCase();
			if((temp.startsWith("http://"))||(temp.startsWith("https://"))){
				sb.append("<a href='"+st[i]+"'>"+st[i]+"</a>");
			}else	if((EventBeeValidations.isValidEmail(st[i],"")).getStatus()){
				sb.append("<a href='mailto: "+st[i]+"'>"+st[i]+"</a>");
			}else{
				sb.append(st[i]);
			}
		}
		return sb.toString();
	}


	public static String textToHtml(String data, boolean xmlencode) {
		if(data ==null)data="";
		if(xmlencode){
			data=data.replaceAll("<","&lt;");
			return textToHtml(data);
		}else{
			return textToHtml(data);
		}


	}
	public static String displayErrMsgs(String suffix,Object obj,String prefix){
		return displayErrMsgs(suffix,obj,prefix,true);
	}
	public static String displayErrMsgs(String suffix,Object obj,String prefix,boolean adderrormsg){

		if(suffix==null) suffix="";
		if(prefix==null) prefix="";

		if(obj==null)
			return "";
		else{
			StringBuffer sb=new StringBuffer();
		   try{

			if(obj instanceof HashMap){
			      HashMap hm=(HashMap) obj;
			      Set e =hm.entrySet();
			      for (Iterator i = e.iterator(); i.hasNext();){
                        	  Map.Entry entry =(Map.Entry)i.next();
				  if(entry.getValue()!=null && !("".equals(((String)entry.getValue()).trim()))){
					  sb.append(suffix);
					  sb.append(getEncodedXML((String)entry.getValue()));
					  sb.append(prefix);
				  }
			      }
			}else{
				if(obj instanceof Vector){
					Vector v=(Vector) obj;
					if(adderrormsg){
					if(v.size()>0){
					     sb.append(suffix);
					     String str="There is [1] error ";
					     if(v.size()>1)
						     str="There are ["+v.size()+"] errors: ";
					     sb.append(str);
					     sb.append(prefix);
					}
					}
					for(int i=0;i<v.size();i++){
						if(v.elementAt(i)!=null && !("".equals(((String)v.elementAt(i)).trim()))){
							sb.append(suffix);
							sb.append(getEncodedXML((String)v.elementAt(i)));
							sb.append(prefix);
						}
					}
				}
			}
		   }catch(Exception e){System.out.println("Exception Occured at GenUtil/dispErrMsg(): "+e);}
			return sb.toString();
		}
	}

	public static String processTextArea(String str,String repA,String repB,int len,boolean word){
		if(str==null || "".equals(str)) return str;
		if(repA==null) repA="";
		if(repB==null) repB="";

		if(len>str.length()){
			if(!repA.equals(repB))
				str=str.replaceAll(repA,repB);
			return str;
		}
		int count=1,i=0;
		String process_str="";

		while(i<str.length()){
			if(word){
				if(str.charAt(i)=='\n'){
					process_str+=repB;
					count=1;
				}else if(str.charAt(i)==' ' && count>len){
					process_str+=(""+str.charAt(i))+repB;
					count=1;
				}else{
					process_str+=(""+str.charAt(i));
					count++;
				}
			}else{
				if(str.charAt(i)=='\n'){
					process_str+=repB;
					count=1;
				}else if(count>len){
					process_str+=(""+str.charAt(i))+repB;
					count=1;
				}else{
					process_str+=(""+str.charAt(i));
					count++;
				}
			}
			i++;
		}
		return process_str;
	}
public static String getServerAddress(String unitid){
	return EbeeConstantsF.get("serveraddress","http://www.eventbee.com");
}

public static String [] getStringArray(Object object)
{
String [] str={};
if(object instanceof String [])
		{
		str=(String [])object;
		}
		else
		{
		String str2=(String)object;
		str=new String[1];
		str[0]=str2;
		}
return str;
}
public static String wrapUNBRText(String str, int length)
{
StringBuffer sb=new StringBuffer();
int strlen=0;
	if(str!=null){
		strlen=str.length();
		if(strlen>length){
			int iter_no_of_times=strlen/length;
			for(int i=0;i<iter_no_of_times;i++){
			sb.append(str.substring(length*i,(i+1)*length));
			sb.append("<br/>");
			}
			if((strlen%length)>0)
			sb.append(str.substring(length*iter_no_of_times,strlen));

		}else{
		sb.append(str);
		}
	}
return sb.toString();
}
public static String TruncateData(String basedata, int tsize){
	if(basedata==null) return "";
	if(basedata.length()<=tsize) return basedata;
	//String t1=basedata.substring(tsize-1);
	//int spacerindex=t1.indexOf(" ");
	//return basedata.substring(0,tsize-1 )+ t1.substring(0, (spacerindex==-1)?0:spacerindex  )+" ...";
	return basedata.substring(0,tsize-1 )+" ...";


}
public static String getLeftZeroPadded( String str, int len,String paddedString )
   {

  for(int j=0;j<len;j++){
  paddedString+=paddedString;
  }

   String s = str;
   if (s.length() > len )
   return s.substring(0,s.length());
   else if ( s.length() < len )
   return paddedString.substring(0, len - s.length ()) + s;
   else return s;
   }

public static void Redirect(HttpServletResponse response, String url)
			throws IOException {
		response.getWriter().print(
				"<script>window.location='" + url + "'</script>");
	}

}

