package com.customquestions.beans;

import java.util.HashMap;

public class CCustomAttribSet {
	private String attribSetid;
	private  HashMap<String,CCustomAttribute> attribs;
	//private HashMap customAttribSetHash=new HashMap();

	public void setAttribSetid(String attribsetid){
		this.attribSetid=attribsetid;
	}
	public String getAttribSetid(){
		return attribSetid;
	}
	public HashMap<String,CCustomAttribute> getAttributes(){
		return attribs;
	}
	public void setAttributes( HashMap<String,CCustomAttribute> attribs){
		this.attribs=attribs;
	}
	/*public HashMap getGenericData(){
		return customAttribSetHash;
	}
	public void setGenericData(HashMap customattsethash){
		this.customAttribSetHash=customattsethash;
	}
	public Object getGenericVal(Object key){
		return (this.customAttribSetHash).get(key);
	}
	public void setGenericval(Object key,Object val){
		(this.customAttribSetHash).put(key,val);
	}*/
}
