<%@ include file='/globalprops.jsp' %>
<%
String eventid = groupid;
System.out.println("eventlayoutpage.jsp::::::::::::::::::::::::::::::groupid: "+groupid+" prev: "+prev);
if("final".equals(prev)){
	if(!CacheManager.getInstanceMap().containsKey("buyerattlayoutmanage")){
		CacheLoader layoutManage=new BuyerAttLayoutManageLoader();
		layoutManage.setRefreshInterval(3*60*1000);
		layoutManage.setMaxIdleTime(3*60*1000);
		CacheManager.getInstanceMap().put("buyerattlayoutmanage",layoutManage);		
	}
	
	if(CacheManager.getData(groupid, "buyerattlayoutmanage")==null || CacheManager.getInitStatus(groupid+"_buyerattlayoutmanage")){
		request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
		return ;
	}
}
String jsonData="";
Map layoutManageMap=new HashMap();
if("final".equals(prev)){
	layoutManageMap=CacheManager.getData(groupid, "buyerattlayoutmanage");
	jsonData = (String)layoutManageMap.get("layout");
}else jsonData=BuyerAttDBHelper.getLayout(eventid,"",prev,"buyer"); 
//System.out.println("all content::"+jsonData);
JSONObject layout = new JSONObject(jsonData);
String columnWideHTML,columnNarrowHTML,columnSingleHTML,columnSingleBottomHTML;
columnSingleHTML = "<div class=\"single\">";
columnWideHTML = "<div class=\"wide\">";
columnNarrowHTML = "<div class=\"narrow\">";
columnSingleBottomHTML= "<div class=\"single\">";

JSONArray single_widgets=null,wide_widgets=null,narrow_widgets=null,single_bottom_widgets=null;
JSONObject total_widgets=new JSONObject();
try{
	single_widgets = layout.getJSONArray("column-single");
	wide_widgets = layout.getJSONArray("column-wide");
	narrow_widgets = layout.getJSONArray("column-narrow");
	single_bottom_widgets=layout.getJSONArray("column-single-bottom");
	total_widgets.put("single",single_widgets);

	total_widgets.put("wide",wide_widgets);
	total_widgets.put("narrow",narrow_widgets);
	total_widgets.put("singlebottom",single_bottom_widgets);
}catch(JSONException je) {
	out.print("<h1>Error establishing a database connection</h1>");
}

String headerTheme = layout.getString("header_theme");

JSONObject global_style = layout.getJSONObject("global_style");

String bodyBackgroundImage = global_style.getString("bodyBackgroundImage");
String bodyBackgroundColor = global_style.getString("bodyBackgroundColor");
String bodyBackgroundPosition = global_style.getString("backgroundPosition");
 
String coverPhoto = global_style.getString("coverPhoto");
String titleShowHide = "Y";
if(global_style.has("titleShow"))
	titleShowHide = global_style.getString("titleShow");
String titleColor = global_style.getString("title");
String backgroundRgba = global_style.getString("contentBackground");
String logoURL="",logoMsg="";
if(global_style.has("logourl"))
	logoURL=global_style.getString("logourl");
if(global_style.has("logomsg"))
	logoMsg=global_style.getString("logomsg");
String backgroundHex = backgroundRgba.split("rgba")[1];
backgroundHex = backgroundHex.substring(1, backgroundHex.length()-1);
int r = Integer.parseInt(backgroundHex.split(",")[0]);
int g = Integer.parseInt(backgroundHex.split(",")[1]);
int b = Integer.parseInt(backgroundHex.split(",")[2]);
Color color = new Color(r,g,b);
backgroundHex = "#"+Integer.toHexString(color.getRGB()).substring(2);
String backgroundOpacity = backgroundRgba.split(",")[3];
backgroundOpacity = backgroundOpacity.substring(0, backgroundOpacity.length()-1);
String details = global_style.getString("details");
String header = global_style.getString("header");
String headerText = global_style.getString("headerText");
String border = global_style.getString("border");
String content = global_style.getString("content");
String contentText = global_style.getString("contentText");

String headerTextFont="Verdana";
String headerTextSize="16";
String contentTextSize = "14";
String contentTextFont = "Verdana";

if(global_style.has("headerTextFont"))
	headerTextFont = global_style.getString("headerTextFont");
if(global_style.has("headerTextSize"))
	headerTextSize = global_style.getString("headerTextSize");
if(global_style.has("contentTextSize"))
	contentTextSize = global_style.getString("contentTextSize");
if(global_style.has("contentTextFont"))
	contentTextFont = global_style.getString("contentTextFont");

JSONObject radius = new JSONObject(global_style.getString("radius"));
String topLeft = radius.getString("topLeft");
String topRight = radius.getString("topRight");
String bottomLeft = radius.getString("bottomLeft");
String bottomRight = radius.getString("bottomRight");
JSONObject widgetStyles=new JSONObject();
if("final".equals(prev))
	widgetStyles = (JSONObject)layoutManageMap.get("widgetstyles");
else
	widgetStyles=DBHelper.getWidgetStyles(eventid,prev);//widget color bordre etc attributes json. common for both eventpage and buyerpage
HashMap<String, String> configHash = new HashMap<String, String>();
HashMap<String, String> refHash = new HashMap<String, String>();
HashMap<String, String> dataHash = new HashMap<String, String>();
DBHelper.getDataHash(getEventInfoMap(groupid),dataHash);
refHash.put("eventid", eventid);
refHash.put("tid",tid);
refHash.put("token",token);
refHash.put("stage", prev);
refHash.put("serveraddress", "http://"+EbeeConstantsF.get("serveraddress","localhost"));
refHash.put("i18nlang",DBHelper.getLanguageFromDB(eventid));
String config_options="";
String type="buyer";
if("final".equals(prev))
	config_options = (String)layoutManageMap.get("widgetoptions");
else{
	//System.out.println("insie draft");
	config_options=BuyerAttDBHelper.getAllWidgetOptions(eventid,prev,type,layout.getJSONObject("added")).toString();// $variables custom attributes 
}
configHash.put("config_options", config_options);
if(widgetStyles!=null)
	configHash.put("styles", widgetStyles.toString());
configHash.put("widgets",total_widgets.toString());

String googleMapsHTML = "<iframe width=\"100%\" height=\"100%\" frameborder=\"no\" src=\"http://www.eventbee.com/portal/customevents/googlemap_js.jsp?lon="+dataHash.get("longitude")+"&amp;lat="+dataHash.get("latitude")+"\"></iframe>";

StringBuffer bookmark=new StringBuffer("");
JSONObject singleWidgets=EventPageRenderer.getWidgetsHTML(single_widgets,eventid,refHash,dataHash,configHash);
JSONObject wideWidgets =EventPageRenderer.getWidgetsHTML(wide_widgets,eventid,refHash,dataHash,configHash);
JSONObject narrowWidgets=EventPageRenderer.getWidgetsHTML(narrow_widgets,eventid,refHash,dataHash,configHash);
JSONObject singleBottomWidget=EventPageRenderer.getWidgetsHTML(single_bottom_widgets,eventid,refHash,dataHash,configHash);
if(singleWidgets.has("whosAttending") || wideWidgets.has("whosAttending") || narrowWidgets.has("whosAttending") || singleBottomWidget.has("whosAttending"))
	scriptTag.append("<script type='text/javascript' src='##resourceaddress##/home/js/whosattending.js'></script>");
 %>
<%=scriptTag.toString().replace("##resourceaddress##", resourceaddress).replace("##timestamp##", String.valueOf(d.getTime())) %>
<%-- <%=eventlevelHiddenAttribs %> --%>
 <!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=getEventName(groupid)%></title>
<link href="/main/bootstrap/css/bootstrap.css" rel="stylesheet" />
<style>
table {
    border-collapse: separate !important;
    border-spacing: 2px !important;
}
body {
	margin: 0 0 0 0;
	font-family: Tahoma, Geneva, sans-serif;
	background-position: top;
	background-color: <%=bodyBackgroundColor%>;
	<%if(!"".equals(bodyBackgroundImage)){%>
	background-image: url('<%=bodyBackgroundImage%>');
	<%}%>
	<%
	if("cover".equals(bodyBackgroundPosition)) {
		out.println("background-size:100% auto;");
		out.print("\tbackground-repeat:no-repeat;");
	} else
		out.print("background-repeat:"+bodyBackgroundPosition+";");%>
}

#whosAttending .widget-content #attendeeinfo ul hr{
    margin: 10px 0px;
}

.container {
	box-shadow:-60px 0px 100px -90px #000000, 60px 0px 100px -90px #000000;
	background-color: <%=backgroundRgba%> !important;
}
.header {
	  margin-bottom: 15px;
} 
h2{
	text-transform: capitalize;
}
.widget {
	margin:5px 2px  20px;
	position:relative;
	border:1px solid <%=border%>;
	width: 100%;
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-webkit-border-bottom-right-radius: <%=bottomRight%>;
	-webkit-border-bottom-left-radius: <%=bottomLeft%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	-moz-border-radius-bottomright: <%=bottomRight%>;
	-moz-border-radius-bottomleft: <%=bottomLeft%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
	border-bottom-right-radius: <%=bottomRight%>;
	border-bottom-left-radius: <%=bottomLeft%>;
}
.widget h2{
    font-family:<%=headerTextFont%>;
	margin:0;
	font-size:<%=headerTextSize%>px;
	background-color:<%=header%>;
	color:<%=headerText%>;
	border-bottom:1px solid <%=border%>;
	padding:10px;
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
}
.widget-content{
	background-color:<%=content%>;
	color:<%=contentText%>;
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
	line-height:20px;
	padding:15px;
	-webkit-border-bottom-right-radius: <%=bottomRight%>;
	-webkit-border-bottom-left-radius: <%=bottomLeft%>;
	-moz-border-radius-bottomright: <%=bottomRight%>;
	-moz-border-radius-bottomleft: <%=bottomLeft%>;
	border-bottom-right-radius: <%=bottomRight%>;
	border-bottom-left-radius: <%=bottomLeft%>;
	position: static;
	#overflow: hidden;
}
.widget-content-ntitle{
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
}

table{
	color:<%=contentText%>;
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
}
.small {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
font-weight: lighter;
color:<%=contentTextFont%>;
overflow: hidden;
}
.small_s{
	font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: lighter;
    color: #666666;
}

hr {
	border: 0;
    height: 1px;
    background-image: -webkit-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:    -moz-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:     -ms-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:      -o-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
}
#whosPromoting .widget .widget-content{
	overflow: auto;
}
#subForm{
	background-color:#fff;
}
.alpaca-field-object{
padding:0px !important;
border:0px !important;
}

.legend{
border-bottom: 0px !important;
}
.textWidgetImg img{
	max-width:100%;
}
#whosAttending img{
	max-width:100%;
}
#organizer img{
	max-width: 100%;
}

#captchaidmgr{
	width: 70px !important;
}

#when img, #where img{
    max-width: 100%;
}
</style>
<script src="/home/layout/eventPage.js"></script>
<script src="/home/js/widgetsRender.js"></script>
</head>
<body > 
<div id="rootDiv">
<!-- facebook js sdk -->
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
//var isSeating = document.getElementById('isseatingevent').value;
</script>
<!-- sdk end -->
<% if(global_style.has("fullWidth") && "Y".equalsIgnoreCase((String)global_style.get("fullWidth")) ){%>
  <div><!-- container -->
<% }else{%>
  <div class="container"  id="containerSeating"><!-- container -->
<%}%>
	 <div class="header">
	
		<%headerTheme=headerTheme
				.replace("$$eventTitle$$", "Y".equals(titleShowHide) ? dataHash.get("eventname") : "")
				.replace("$$coverPhotoURL$$", coverPhoto==null || "".equals(coverPhoto) ? "":coverPhoto)
			    .replace("$$logoUrl$$",logoURL==null || "".equals(logoURL) ? "":"<img src='"+logoURL+"' style='width:150px !important;height:150px !important'/>")
				.replace("$$logoMsg$$",logoMsg==null || "".equals(logoMsg) ? "":"<span class='small'>"+logoMsg+"</span>")
				.replace("$$titleColor$$", titleColor);

				VelocityContext layoutContext = new VelocityContext();
				if(coverPhoto!=null && !"".equals(coverPhoto))
				   layoutContext.put("coverPhotoURL",coverPhoto);
				if(logoURL!=null && !"".equals(logoURL))
					   layoutContext.put("logoUrl",logoURL);
				if(logoMsg!=null && !"".equals(logoMsg))
					   layoutContext.put("logoMsg",logoMsg);		
				VelocityEngine layoutEngine= new VelocityEngine();
				layoutEngine.init();
				layoutEngine.evaluate(layoutContext,out,"ebeelayouttemplate",  headerTheme==null?"":headerTheme); 	
		%> 
	</div>
	<div style="clear:both;"></div>
		
	<div class="widgets">
		<div class="col-sm-12 col-md-12 col-xs-12" id='single_widgetsSeating'>
			<div class="single" id="single_widgets">
				
			</div>
		</div>
		<div class="col-sm-12 col-md-8 col-xs-12" id="wide_widgetsSeating">
			<div class="wide" id="wide_widgets">
				
			</div>
		</div>
		<div class="col-sm-12 col-md-4 col-xs-12" id="narrow_widgetsSeating">
			<div class="narrow" id="narrow_widgets">
				
			</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12" id="singleBottom_widgetsSeating">
			<div class="single" id="single_bottom_widgets">
				
			</div>
		</div>
	</div>
	
	<!-- Footer start -->
	<div style="clear:both;"></div>
	<div>
		<table align="center" cellpadding="5" style="margin-bottom: 15px;">
		    <tbody>
		        <tr>
		            <td align="left" valign="middle">
		                <a style="margin-right:15px" href="http://www.eventbee.com/"><img src="http://www.eventbee.com/home/images/poweredby.jpg" border="0">
		                </a>
		            </td>
		            <td>&nbsp;&nbsp;</td>
		            <td align="left" valign="middle"><span class="small_s"><%=getPropValue("evh.footer.lnk",eventid)%><a href="http://www.eventbee.com">http://www.eventbee.com</a></span>
		            </td>
		        </tr>
		    </tbody>
		</table>
	</div> 
	<!-- Footer end -->
	
</div>
<script>
var stage='<%=prev%>';
var eventid=<%=eventid%>
var single_widgets = <%=single_widgets%>
var wide_widgets = <%=wide_widgets%>
var narrow_widgets = <%=narrow_widgets%>
var single_bottom_widgets = <%=single_bottom_widgets%>
var singleWidgets = <%=singleWidgets%>;
var wideWidgets = <%=wideWidgets%>;
var narrowWidgets = <%=narrowWidgets%>;
var singleBottomWidget = <%=singleBottomWidget%>;
	getAllWidgets('single_widgets', singleWidgets, single_widgets,eventid);
	getAllWidgets('wide_widgets', wideWidgets, wide_widgets,eventid);
	getAllWidgets('narrow_widgets', narrowWidgets, narrow_widgets,eventid);
	getAllWidgets('single_bottom_widgets', singleBottomWidget, single_bottom_widgets,eventid);
	
</script>
<script src="/home/js/eventlinks.js"></script>
</div>
</body>
</html>
 