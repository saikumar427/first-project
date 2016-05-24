package com.customquestions.beans;

public class CAttribOption {
	private String isDefault;
	private String isSelectable;
	private String option_id;
	private String lastupdated;
	private String optionValue;
	private String optionDisplay;
	private String position;
	private String optgroupName;
	private String versionNumber;
	private String subQuestions[]=new String[0];

	
	
	public String[] getSubQuestions() {
		return subQuestions;
	}
	public void setSubQuestions(String[] subQuestions) {
		this.subQuestions = subQuestions;
	}
	public void setIsDefault(String isdefault){
		this.isDefault=isdefault;
	}
	public String getisDefault(){
		return isDefault;
	}
	public void setIsSelectable(String isselect){
		this.isSelectable=isselect;
	}
	public String getIsSelectable(){
		return isSelectable;
	}
	public void setOptgroupName(String optgrpname){
		this.optgroupName=optgrpname;
	}
	public String getOptgroupName(){
		return optgroupName;
	}
	public String getPosition(){
		return position;
	}
	public void setPosition(String position){
		this.position=position;
	}
	public String getOptionid(){
		return option_id;
	}
	public void setOptionDisplay(String optiondisplay){
		this.optionDisplay=optiondisplay;
	}
	public String getOptionDisplay(){
		return optionDisplay;
	}
	public void setOptionid(String optionid){
		this.option_id=optionid;
	}
	public void setLastUpdated(String updated){
		this.lastupdated=updated;
	}
	public String getLastUpdated(){
		return lastupdated;
	}
	public void setOptionValue(String optionval){
		this.optionValue=optionval;
	}
	public String getOptionValue(){
		return optionValue;
	}
	public void setVersionNumber(String versionnumber){
		this.versionNumber=versionnumber;
	}
	public String getVersionNumber(){
		return versionNumber;
	}
}
