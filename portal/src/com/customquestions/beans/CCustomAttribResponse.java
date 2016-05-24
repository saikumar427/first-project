package com.customquestions.beans;

public class CCustomAttribResponse {
	private String ref_id;
	private String attribId;
 	private String attribsetid;
 	private String option_id;
 	private String shortResponse;
 	private String response;
 	private String question_shortform;
 	private String question_original;
 	private String optionVal;
 	private String option_display;

 	public void setOptionid(String optionid){
 		this.option_id=optionid;
 	}
 	public String getOptionid(){
 		return option_id;
 	}
 	public void setRefid(String refid){
 		this.ref_id=refid;
 	}
 	public String getRefid(){
 		return ref_id;
 	}
 	public void setattribId(String attribid){
 		this.attribId=attribid;
 	}
 	public String getattribId(){
 		return attribId;
 	}
 	public void setattribsetid(String attribsetid){
	 		this.attribsetid=attribsetid;
	}
	public String getattribsetid(){
	 		return attribsetid;
 	}
 	public void setShortResponse(String sresponse){
 		this.shortResponse=sresponse;
 	}
 	public String getShortResponse(){
 		return shortResponse;
 	}
 	public void setResponse(String response){
		this.response=response;
	}
	public String getResponse(){
		return response;
	}
	public void setQuestionShortform(String qsform){

		this.question_shortform=qsform;
	}
	public String getQuestionShortform(){
		return question_shortform;
	}
	public void setQuestionOriginal(String qoriginal){
		this.question_original=qoriginal;
	}
	public String getQuestionOriginal(){
		return question_original;
	}
	public void setOptionVal(String optval){
		this.optionVal=optval;
	}
	public String getOptionVal(){
		return optionVal;
	}
	public void setOptionDisplay(String optdisplay){
		this.option_display=optdisplay;
	}
	public String getOptionDisplay(){
		return option_display;
	}
}
