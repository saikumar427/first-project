package com.customquestions.beans;

import java.util.ArrayList;

public class CCustomAttribute {

	private String isActive;
	private String eraseonFocus;
	private String isRequired;
	private String versionNumber;
	private String textboxSize="10";
	private String rows="10";
	private String cols="70";
	private String position;
	private String attribId;
	private String attribSetid;
	private String attributeName;
	private String attributeType;
	private String lastUpdated;
	private String attributeName_shortForm;
	private String defaultValue;
	private ArrayList<CAttribOption> attriboptions=new ArrayList<CAttribOption>();

	public CCustomAttribute(){

	}
	public void setIsActive(String isactive){
		this.isActive=isactive;
	}
	public String getIsActive(){
		return isActive;
	}

	public void setisRequired(String isrequired){
		this.isRequired=isrequired;
	}
	public String getisRequired(){
		return isRequired;
	}
	public void setEraseonFocus(String eraseonfocus){
		this.eraseonFocus=eraseonfocus;
	}
	public String getEraseonFocus(){
		return eraseonFocus;
	}
	public void setVersionNumber(String versionnumber){
		this.versionNumber=versionnumber;
	}
	public String getVersionNumber(){
		return versionNumber;
	}
	public void setTextboxSize(String tboxsize){
		this.textboxSize=tboxsize;
	}
	public String getTextboxSize(){
		return textboxSize;
	}
	public void setRows(String rows){
		this.rows=rows;
	}
	public String getRows(){
		return rows;
	}
	public void setCols(String cols){
		this.cols=cols;
	}
	public String getCols(){
		return cols;
	}
	public void setPosition(String position){
		this.position=position;
	}
	public String getPosition(){
		return position;
	}
	public void setAttribSetId(String attribsetid){
		this.attribSetid=attribsetid;
	}
	public String getAttribSetId(){
		return attribSetid;
	}
	public void setAttribId(String attribid){
		this.attribId=attribid;
	}
	public String getAttribId(){
		return attribId;
	}
	public void setAttributeName(String attribname){
		this.attributeName=attribname;
	}
	public String getAttributeName(){
		return attributeName;
	}
	public void setAttributeType(String attribtype){
		this.attributeType=attribtype;
	}
	public String getAttributeType(){
		return attributeType;
	}
	public void setlastUpdated(String updated){
		this.lastUpdated=updated;
	}
	public String getlastUpdated(){
		return lastUpdated;
	}
	public void setAttributeName_shortForm(String shortform){
		this.attributeName_shortForm=shortform;
	}
	public String getAttributeName_shortForm(){
		return attributeName_shortForm;
	}
	public void setDefaultValue(String defvalue){
		this.defaultValue=defvalue;
	}
	public String getDefaultValue(){
		return defaultValue;
	}
	public void setOptions(ArrayList<CAttribOption> options){
		this.attriboptions=options;
	}
	public ArrayList<CAttribOption> getOptions(){
		return attriboptions;
	}
}
