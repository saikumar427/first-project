<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.event.beans.*" %>
<%@ page import="com.event.beans.HomePageEventData,org.json.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>

<%!
ArrayList<HashMap<String,String>> getManagerPromotedEvents(String query,String[] param){
	ArrayList<HashMap<String,String>> list =new ArrayList<HashMap<String,String>>();
	DBManager db=new DBManager();
	StatusObj sob=db.executeSelectQuery(query,param);
	if(sob.getStatus()){
		for(int i=0;i<sob.getCount();i++){
			HashMap<String,String> promoMap=new HashMap<String,String>();
			promoMap.put("eid",db.getValue(i,"eventid",""));
			promoMap.put("eventname",db.getValue(i,"eventname",""));
			promoMap.put("extid",db.getValue(i,"extid",""));
			promoMap.put("name",db.getValue(i,"name",""));
			promoMap.put("day",db.getValue(i,"day",""));
			promoMap.put("network",db.getValue(i,"network",""));
			promoMap.put("dateformat",db.getValue(i,"dateformat",""));
			promoMap.put("hour",db.getValue(i,"hour",""));
			promoMap.put("profile_image_url",db.getValue(i,"profile_image_url",""));
			promoMap.put("mmddyyyy",db.getValue(i,"mmddyyyy",""));
			promoMap.put("tktsalecount",db.getValue(i,"ticket_sale_count",""));
			promoMap.put("visitcount",db.getValue(i,"visit_count",""));
			list.add(promoMap);
		}
	}
	return list;
}
public static String TruncateData(String basedata, int tsize){
	if(basedata==null) return "";
	if(basedata.length()<=tsize) return basedata;
	return basedata.substring(0,tsize-1 )+"...";
}

%>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
HomePageEventData hm=null;
ArrayList result_vec=new ArrayList();
int count=10;
String link="";
String type=request.getParameter("type"); 
String base="oddbase"; 
 JSONObject json=new JSONObject();
 ArrayList<HashMap<String,String>> promotionsarr=new ArrayList<HashMap<String,String>>();
 String query="select eventname,a.eventid,trunc(random() * (19-10) + 10) as hour,ticket_sale_count, visit_count,external_userid as extid ,to_char(a.promoted_at, 'Mon dd, YYYY')"+
         " as dateformat,to_char(a.promoted_at, 'MM/DD/YYYY') as mmddyyyy,network,profile_image_url,fname||' '||lname as name,to_char(a.promoted_at,'Day') as day from nts_visit_track a"+
         ",eventinfo b ,ebee_nts_partner c where a.eventid=b.eventid::varchar  and a.nts_code=c.nts_code and c.network in('facebook','twitter') and b.status='ACTIVE' and a.promoted_at is"+
         " not null order by a.promoted_at desc limit 50";
 
	String[] param=null;
	ArrayList<HashMap<String,String>> promolist=new ArrayList<HashMap<String,String>>();
	String extid="",eventid="",eventname="",name="",day="",network="",dateformat="",hour="",mmddyyyy="",visitcount="",tktsalecount="";
		boolean promotionisInCache=EbeeCachingManager.checkCache("recentPromos",120000);
		//promotionisInCache=false;
		if(!promotionisInCache){
			//System.out.println("hi::");
			promolist=getManagerPromotedEvents(query,null);
			if(promolist!=null && promolist.size()>0)
			EbeeCachingManager.put("recentPromos",promolist);
		}
		promolist=(ArrayList)EbeeCachingManager.get("recentPromos");
		if(promolist!=null && promolist.size()>0){
			int fbcount=0,twtcount=0;
			if(!promotionisInCache){
				for(HashMap<String,String> hsm:promolist){
					if("facebook".equals(hsm.get("network"))) fbcount++;
					else twtcount++;
				}
		
				
				
			}
			
			for(int i=0;i<promolist.size();i++){
			dateformat=promolist.get(i).get("dateformat");
				extid=promolist.get(i).get("extid");
				eventid=promolist.get(i).get("eid");
				eventname=promolist.get(i).get("eventname");
				name=promolist.get(i).get("name");
				day=promolist.get(i).get("day").trim();
				hour=promolist.get(i).get("hour");
				mmddyyyy=promolist.get(i).get("mmddyyyy");
				tktsalecount=promolist.get(i).get("tktsalecount");
				visitcount=promolist.get(i).get("visitcount");
				String src="",profileurl="",profileimg="";
				profileimg=promolist.get(i).get("profile_image_url");
				network=promolist.get(i).get("network");
		        if("facebook".equals(promolist.get(i).get("network"))){
					src=resourceaddress+"/main/images/fb_large_icon.png";
					src="<i class=\"fa fa-facebook\"></i>";
					//profileurl="http://www.facebook.com/profile.php?id="+extid;
					profileurl="http://www.facebook.com/"+extid;
					profileimg="https://graph.facebook.com/"+extid+"/picture";
				}
				else if("twitter".equals(promolist.get(i).get("network"))){
					src=resourceaddress+"/main/images/twitter_large_icon.png";
					src="<i class=\"fa fa-twitter\"></i>";
					profileurl="http://twitter.com/account/redirect_by_id?id="+extid;
					//profileimg="https://api.twitter.com/1/users/profile_image?user_id="+extid+"&size=bigger";
				}
				int enamelen=80-(name.length()+" promoted ".length()+" on ".length()+day.length());
				enamelen=65;//37;
				//if(enamelen<1) enamelen=30;
				HashMap<String,String> hmap=new HashMap<String,String>();
				hmap.put("eid",eventid);
				hmap.put("en",GenUtil.textToHtml(TruncateData(eventname,enamelen),true));
				hmap.put("n",name);
				hmap.put("dy",day);
				hmap.put("src",src);
				hmap.put("purl",profileurl);
				hmap.put("src",src);
				hmap.put("pimg",profileimg);
				hmap.put("dateformat",dateformat);
				hmap.put("hour",hour);
				hmap.put("network",network);
				hmap.put("mmddyyyy",mmddyyyy);
				hmap.put("tktsalecount",tktsalecount);
				hmap.put("visitcount",visitcount);
				promotionsarr.add(hmap);
		}
}					


try{
json.put("fpromotions",promotionsarr);

}catch(Exception e){System.out.println("Exception occured while preparing is:"+e.getMessage());}

%>


  <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/animatecss/3.1.0/animate.min.css" /> 
   <!--  <link rel="stylesheet" type="text/css" href="/main/css/bootstrap/offcanvas.css" /> -->
   <%
   
   
   %>
     <style>
 
        .panel-title a {
            display: block;
            padding: 10px 15px;
            margin: -10px -15px;
            text-decoration: none
        }
        .panel-group table {
            margin-bottom: 0;
        }
        .panel-group tr a {
            display: block;
        }
        .panel-group tr a {
            display: block;
        }
        #graphContainer {
            /* width: 900px; */
            height: 270px;
            border-bottom: 0px solid #5388c4;
            border-left: 0px solid #5388c4;
            padding: 30px
        }
        
        #graphContainer img {
            position: absolute;
            border: 2px solid #5388c4;
            top: 10%;
            left: 10%;
            z-index:2;
        }
        #graphContainer img:hover {
            cursor: pointer;
        }
        .tooltip{
        z-index: 3;
        font-size: 13px;
        }
	.tooltip-inner {
    background-color:white;
	color:black;
}
         .time {
            height: 395px;
        }
        .time span,#dates span {
            position: absolute;
        }
        
        .img-circle {
border-radius: 50%;
}
.fa-2x {
    font-size: 1.5em;
}
        
    </style>
    

<div style="height:100px;"></div>
<div class="container">
<div class="row">
 			<div class="col-md-1 col-sm-1 col-xs-1 time" style="top:100px">
            	  <a id="fa_left"><i class="fa fa-3x fa-chevron-left"  style="cursor: pointer;color:#ccc;font-size:55px" onMouseOut="this.style.color='#CCC'" onMouseOver="this.style.color='#AAA'" ></i></a>           
            </div>
          <!--   <div class="col-md-1 col-sm-1 col-xs-1"></div> -->
          
          <div id="graphline"></div>
          
            <div class="col-md-10 col-sm-10 col-xs-10" id="graph">
                <div id="graphContainer" style="position:relative"></div>
				<div id="dates"></div>
             </div>
			<!-- <div class="col-md-1 col-sm-1 col-xs-1"></div> -->
			<div class="col-md-1 col-sm-1 col-xs-1 time" style="top:100px;">
			       <a id="fa_right"><i class="fa fa-3x fa-chevron-right" style="cursor: pointer;color:#ccc;font-size:55px" onMouseOut="this.style.color='#CCC'" onMouseOver="this.style.color='#AAA'" ></i></a>
			</div>
</div>
</div>
                   
<script>
var json=<%=json%>;
var dt_table_dd=json.fpromotions;
var min=0;max=4;
var finalJSON={};
var innerArr=[];
var diffDates=[];
var graphdivwidth=945;
var topJson={"18":0,"17":10,"16":20,"15":30,"14":40,"13":50,"12":60,"11":70,"10":80};

    function connect(div1, div2, color, thickness) {
         var off1 = getOffset(div1);
        var off2 = getOffset(div2);
        var x1 = off1.left + off1.width / 2;
        var y1 = off1.top + off1.height / 2;
        // center of second div
        var x2 = off2.left + off2.width / 2;
        var y2 = off2.top + off2.height / 2;
        // distance
        var length = Math.sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)));
        // center
        var cx = ((x1 + x2) / 2) - (length / 2);
        var cy = ((y1 + y2) / 2) - (thickness / 2);
        // angle
		//alert("top::"+cy);
        var angle = Math.atan2((y1 - y2), (x1 - x2)) * (180 / Math.PI);
       // alert("angle::"+angle);
        // make hr
		var graphcontaineroffset=$('#graphContainer').offset();
        var htmlLine = "<div class='joiner' style='border-top:dotted;display:none;z-index:1;padding:0px; margin:0px; height:" + thickness + "px; border-top-color:" + color + "; line-height:1px; position:absolute; left:" + (cx+graphcontaineroffset.left) + "px; top:" + (cy + graphcontaineroffset.top) + "px; width:" + length + "px; -moz-transform:rotate(" + angle + "deg); -webkit-transform:rotate(" + angle + "deg); -o-transform:rotate(" + angle + "deg); -ms-transform:rotate(" + angle + "deg); transform:rotate(" + angle + "deg);' />";
        //append html to body
       
        //document.body.innerHTML += htmlLine;
        
        document.getElementById('graphline').innerHTML+=htmlLine;
        
		//$('#graphContainer').append(htmlLine);
    }

    function getOffset(el) {
	var graphcontaineroffset=$('#graphContainer').offset();
        var _x = 0;
        var _y = 0;
        var _w = el.offsetWidth| 0;
        var _h = el.offsetHeight | 0;
        
		 _x+= $(el).position().left;
		 _y+= $(el).position().top;
			   
        return {top: _y,left: _x,width: _w,height: _h};
    }
    
    var temp=1;
    var globalImg=0;
    var globalDate=0;
	

    function run(direction) {
    	   globalImg=0;
    	   globalDate=0;

    	var images='';
    	var dates='';
    	for(var i=min;i<max;i++){
    		if(i>=dt_table_dd.length)
    			continue;
    		
    		var tooltipmsg='';
    		var width=40;
    		var height=40;
    		var date=dt_table_dd[i].dateformat;
			var name=dt_table_dd[i].n;
			var purl=dt_table_dd[i].purl;
			var evtname=dt_table_dd[i].en;
			evtname=evtname.split('"').join('');
			var eid=dt_table_dd[i].eid;
			evtname="<a target=_blank style=text-decoration:none href=http://www.eventbee.com/event?eid="+eid+">"+evtname+"</a>";
			var img=dt_table_dd[i].pimg;
			var network=dt_table_dd[i].network;
			var day=dt_table_dd[i].dy;
			var sales=parseInt(dt_table_dd[i].tktsalecount);
    		var visits=parseInt(dt_table_dd[i].visitcount);
			if(visits>0){
    			width=60,height=60;
			}
    		if(sales>0){
    			width=80,height=80;
    		}
    			if(sales==0 && visits==0){
    				width=40,height=40;	
    			}
			tooltipmsg="<a target=_blank style=text-decoration:none href="+purl+">"+name+"</a>";
			
			if(network=='facebook'){
			tooltipmsg+=" promoted "+evtname+" on "+day;
			tooltipmsg+="&nbsp;<i class='fa fa-facebook'></i>";
			}else{
			tooltipmsg+=' generated ticket sale for '+evtname+ ' on '+day;
			tooltipmsg+="&nbsp;<i class='fa fa-twitter'></i>";
			}
    			images+=' <img alt="'+name+'" src="'+img+'" title="'+tooltipmsg+'" class="animated fadeIn'+direction+' img-thumbnail img-circle" width="'+width+'" height="'+height+'" id="img_'+i+'"/>';
    				globalDate+=1;
    	}
    	$('#graphContainer').html(images);
    	var top=0;
    	var left=4;
    	globalImg=0;
    	globalDate=0;

    	
    	var hours=new Array();
    	for(var i=min;i<max;i++){
    		if(i>=dt_table_dd.length)
    			continue;
    		var hour=parseInt(dt_table_dd[i].hour);
    		hours.push(hour);
    	}
    		for(var i=min;i<max;i++){
    			if(i>=dt_table_dd.length)
        			continue;
    			if(graphdivwidth<945 && graphdivwidth>=750)
                	left+=3;
        		if(graphdivwidth<750 && graphdivwidth>=550)
            		left+=10;
        		if(graphdivwidth<550 && graphdivwidth>=380)
        		left+=17;
        		if(graphdivwidth<380)
            	left+=52;
    			var maxh=Math.max.apply(Math,hours);
    			var minh=Math.min.apply(Math,hours);
    		var diff=maxh-minh;
    			var postedat=dt_table_dd[i].dateformat;
				var hour=parseInt(dt_table_dd[i].hour);
				top=100-((hour/24)*100);
				if((minh-4)>0)
					top+=(minh-4);
				if(maxh<17)
					top-=(maxh+12);
				if(top<0)
				top=0;
				if(topJson[hour]==undefined)
				top=0;
				else	
				top=topJson[hour];
				console.log("the top value is::"+top);
        		$('#img_'+i).css({"top": (top)+'%',left: left+'%'});
        		left=left+26;

        		if(graphdivwidth<945 && graphdivwidth>=750)
                	left+=7;
        		if(graphdivwidth<750 && graphdivwidth>=550)
            		left+=10;
        		if(graphdivwidth<550 && graphdivwidth>=380)
            		left+=25;
        		
        		globalDate+=1;
    		}
    		
    		globalImg=0;
        	globalDate=0;
        
        var connectImages=function(){
        	var temp=0;
        	if(max==1)
        		$('#img_0').height($('#img_0').width());
        	for(var k=min;k<max-1;k++){
        		$('#img_'+k).height($('#img_'+k).width());
        		$('#img_'+(k+1)).height($('#img_'+(k+1)).width());
        		if(k>=dt_table_dd.length-1)
        			continue;
                var l=k+1;
                if(temp==0)
        		 connect(document.getElementById('img_'+k), document.getElementById('img_'+k), "lightgray", 2);
                connect(document.getElementById('img_'+k), document.getElementById('img_'+l), "lightgray", 2);
        	}
        	var toltip=0;
        	for(var img=min;img<max;img++){
        		if(toltip%2==0)
        		$('#img_'+img).tooltip({html:true,trigger: 'manual',placement : 'bottom'}).tooltip('show');
        		else
                $('#img_'+img).tooltip({html:true,trigger: 'manual',placement : 'top'}).tooltip('show');
        		++toltip;
        	}


			$('.tooltip-arrow').css({'border-top-color':'white','border-bottom-color':'white'});
			$('.top .tooltip-arrow').css({'border-width':'15px 15px 0','bottom':'-7px'});
			$('.bottom .tooltip-arrow').css({'border-width':'0 15px 15px','top':'-7px'});
        };
		connectImages();
            $('.joiner').fadeIn();
            if (navigator.userAgent.toLowerCase().indexOf('safari')>-1 && !(navigator.userAgent.toLowerCase().indexOf('chrome')>-1)){
            	$('.img-circle').css("border-radius","12%");
            }
    }
    
   
    $(window).load(function(){
    	run('Right');
		$( ".joiner" ).remove();
		setTimeout(run,1000,'Right');  
    });
	
	$(window).resize(function(){
   var leftarr=parseInt($('#fa_left').offset().left);
   var rightarr=parseInt($('#fa_right').offset().left);
   //alert(leftarr);
   //alert(parseInt($('#img_0').offset().left));
   

		//graphdivwidth=$('#graph').width();
		graphdivwidth=rightarr-leftarr-100;
    		  $( ".joiner" ).remove();
    		//alert('graphdivwidth::'+graphdivwidth);
			
			if(graphdivwidth>=945){max=min+4;
			
			}else if(graphdivwidth<945 && graphdivwidth>=750){max=min+3;
			}else if(graphdivwidth<750 && graphdivwidth>=550){max=min+2;
			}else if(graphdivwidth<550 && graphdivwidth>=380){max=min+1;
			//min=0,max=2;
			}else if(graphdivwidth<380){max=min+1;
			//min=0,max=1;
			}
			run('Right'); 
        });
	
    $(document).ready(function() {
    	$(document).on('click','#fa_left',function(){
        	//alert("hi");
    		$('img').tooltip('destroy');
    		$('#graphContainer img')
    			.removeClass('fadeInRight')
    			.removeClass('fadeInLeft')
    			.removeClass('fadeOutLeft')
    			.removeClass('fadeOutRight')
    			.addClass('fadeOutRight');
    		$('.joiner').fadeOut(function(){
    			$( ".joiner" ).remove();
    		}); 
		if(min<=0){min=0;max=4;
		if(graphdivwidth>=945){max=min+4;
		}else if(graphdivwidth<945 && graphdivwidth>=750){max=min+3;
		}else if(graphdivwidth<750 && graphdivwidth>=550){max=min+2;
		}else if(graphdivwidth<550 && graphdivwidth>=380){max=min+1;
		}else if(graphdivwidth<380){max=min+1;
		}
		}else{min-=4;max-=4;}
		/* $('.fade').each(function(i,obj){
			alert("i:"+i+":obj"+$(this).css("left"));
			$(this).css("left",($(this).css("left")+20)+"px");
		}); */
		//alert("min::"+min+":max::"+max);
    		setTimeout(run,1000,'Left');

		setTimeout(function(){
			$('.fade').each(function(i,obj){
				var leftcss=parseInt($(this).css("left"))+30;
				$(this).css("left",leftcss+"px");
			});
			},1200);
    	});
    	
		$(document).on('click','#fa_right',function(){
			$('img').tooltip('destroy');
			$('#graphContainer img')
				.removeClass('fadeInRight')
				.removeClass('fadeInLeft')
				.removeClass('fadeOutLeft')
				.removeClass('fadeOutRight')
				.addClass('fadeOutLeft');
			
			$('.joiner').fadeOut();
			setTimeout(function(){
				$('.joiner').remove();
			},1000);
		if(max>=dt_table_dd.length){
			min=dt_table_dd.length-4;
			max=dt_table_dd.length;
		}else{min+=4;max+=4;}
			setTimeout(run,1000,'Right');	
    	});
    	
    	
    });
</script>
