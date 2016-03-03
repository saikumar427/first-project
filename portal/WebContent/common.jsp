<%@page import="java.util.HashMap"%>
<%!
 
	private HashMap<String,String> props=new HashMap<String,String>();
	
	public String getPropValue(String key,String lang){
		String prop=null;
		if(!"".equals(lang))
			prop= props.get(key+"_"+lang);
		else
		 prop= props.get(key+"_en-us");
		
		prop = prop == null ? (props.get(key+"_en-us") == null ? "" : props.get(key+"_en-us") ) : prop;
		return prop;			
	}	
	
	
	public String getSlashLinkPath(String lang){
		if("en-us".equals(lang))
			return "";		
		else
		 return "/"+lang;
	}
	
	public String getQuestionMarkLink( String lang){		
		 return "?lang="+lang;
	}
	
%>
<%
String lang=request.getParameter("lang");
lang= lang!=null ? lang.trim() : lang;
lang= lang==null || "".equals(lang) ? "en-us" : lang;
%>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script>
var resourceRequestURL='<%=lang%>'; 
	function countryClick(el,programClick){
		var index=el.attr('id').split("_")[1];	
		var languages=i18nLangJSON[parseInt(index)]['languages'];
		if(!programClick){
			languageClick(languages[0].code);
			return false;
		}
		el.addClass('active');
		el.siblings().removeClass('active');		
		var languagesHTML="";
		$.each(languages,function(index,value){
				if(I18N_ACTUAL_CODE==value.code)
					 languagesHTML+='<li class="active" style="cursor:pointer"><a title="'+value.label+'" onclick="languageClick(\''+value.code+'\')">'+value.label+'</a></li>';						
			    else
					 languagesHTML+='<li style="cursor:pointer"><a title="'+value.label+'" onclick="languageClick(\''+value.code+'\')">'+value.label+'</a></li>';							 
			});
		$("#languages").html(languagesHTML);
	}

	function languageClick(code){		
		  window.location.href="/"+code;
	}

	function getLangNCountry(){
		var url=location.pathname;
		var code=url.split("/")[1] ? url.split("/")[1] : "en-us";
		return code;
	}

	/* var i18nLangJSON=[{"country":"USA","code":"US","languages":[{"label":"English","code":"en-us"}]},
	                  {"country":"Colombia","code":"CO","languages":[{"label":"Español","code":"es-co"},{"label":"English","code":"en-co"}]}	                 
	                  ];

	var I18N_ACTUAL_CODE=getLangNCountry();
	var lang=I18N_ACTUAL_CODE.split("_")[0];
	var country=I18N_ACTUAL_CODE.split("_")[1]; */
	//$(document).ready(function(){
		/* var countryHTML="";
		var languagesHTML="";
		$.each(i18nLangJSON,function(index,value){
			if(country==value.code)
			 	 countryHTML+='<li class="active" id="index_'+index+'"><a title="'+value.country+'" href="javascript:;">'+value.country+'</a></li>';			
			 else
				 countryHTML+='<li  id="index_'+index+'"><a title="'+value.country+'" href="javascript:;">'+value.country+'</a></li>';
		}); */
		//$("#countries").html(countryHTML);
		
		//$(document).on("click","[id^='index']",function(){
			//countryClick($(this),false);
		//});
		/* $.each(i18nLangJSON,function(index,value){
			if(value.code==country)	
				countryClick($("#index_"+index),true);				
		}); */
		/* $(document).click(function(){
			if($("#i18nLang").is(":visible"))
				$("#i18nLang").hide('slow');		
		}); */
		
		/* $("#i18nLangToggle").click(function(e){
			e.stopPropagation();
			if($("#i18nLang").is(":visible")){
				$("#i18nLang").hide('slow');
				
			}
			else{
				$("#i18nLang").show('slow');
			}
		});	 */
		
	//});

 
</script>
<style>
.panel-body{
-webkit-box-shadow: none !important;
-moz-box-shadow: none !important;
box-shadow:none !important;
}
#countries li.active a,#languages li.active a{
color:#FF9900 !important;
}
.sub-text {
    color: #999999;
    font-size: 10px !important;
}
.sm-font {
    font-size: 12px !important;
}
#i18nLangToggle i{
 font-size:20px !important;
}
#i18nLang li {
 list-style:none !important;
}
#i18nLang li a{
 line-height:20px !important;
 padding:0px 10px !important;
 cursor:pointer;
 text-decoration:none;
}
</style>