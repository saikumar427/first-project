package com.customquestions.beans;


public class BCustomAttribSet{
	private String attribSetid;
	private BCustomAttribute[] attribs;
	//private HashMap customAttribSetHash=new HashMap();

	public void setAttribSetid(String attribsetid){
		this.attribSetid=attribsetid;
	}
	public String getAttribSetid(){
		return attribSetid;
	}
	public BCustomAttribute[] getAttributes(){
		return attribs;
	}
	public void setAttributes(BCustomAttribute[] attribs){
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
