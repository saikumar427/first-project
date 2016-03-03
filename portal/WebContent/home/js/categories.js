var category= new Array("Arts","Associations","Books","Business","Career","Causes","Community","Corporate","Education","Entertainment","Entrepreneur","Games","Family","Festivals","Food","Health","Meeting","Movies","Music","Non-Profit","Party","Politics","Religion","School","Social","Sports","Technology","Travel","Trips","Other");
var subcat=new Array(31);
subcat[0]=new Array("Music","Painting","Exhibition","Performance","Photography","Concert","Audition","Opening","Preview","Other")
subcat[1]=new Array("Fund-Raising","Meeting","Other")
subcat[2]=new Array("Reading","Writing","Signing","Other")
subcat[3]=new Array("Meeting","Conference","Other")
subcat[4]=new Array("Meeting","Job-Fair","Counselling","Other")
subcat[5]=new Array("Fundraiser","Protest","Rally")
subcat[6]=new Array("Meeting","Activity","Other")
subcat[7]=new Array("Meeting","Press Release","Productdemo","Announcement","Conference","Other")
subcat[8]=new Array("Training","Class","Study Group","Lecture","Office Hours","Workshop","Other")
subcat[9]=new Array("Movie","Music","Show","Other")
subcat[10]=new Array("Meeting","Conference","Social","Other")



subcat[11]=new Array("Meeting","Conference","Other")
subcat[12]= new Array("Meeting","kids","Gardening","Do-it-yourself","Parenting","Other")
subcat[13]=new Array("Fair","Parade","Other")
subcat[14]=new Array("Cooking","Wine Tasting","Other")
subcat[15]=new Array("Activity","Other")

subcat[16]=new Array("Business Meeting","Club/Group Meeting","Convention","Dorm/House Meeting","Informational Meeting")

subcat[17]=new Array("Exhibition","Other")
subcat[18]=new Array("Classical","Country","Jazz","Metal","Pop","Rap & Hip Hop","Rock","Soul","Jam Session","Recital","Rehearsal","Listening Party","Other")
subcat[19]=new Array("Meeting","Fund-Raising","Conference","Other")

subcat[20]=new Array("Birthday Party","Cocktail Party","Club Party","Fraternity/Sorority Party","Barbecue","Card Night","Dinner Party","Holiday Party","Night of Mayhem","Movie/TV Night", "Drinking Games","Bar Night","LAN Party","Mixer","Slumber Party","Erotic Party","Benefit","Goodbye Party","House Party","Reunion")

subcat[21]=new Array("Meeting","Convention","Other")
subcat[22]=new Array("Meeting","Confence","Other")
subcat[23]=new Array("Alumni","Meeting","Counselling","Others")
subcat[24]=new Array("Meeting","Activity","Party","Clubbing","Other")
subcat[25]=new Array("Baseball","Basketball","Running","Swimmimg","Walking","Racing","Cricket","Cycling","Football","Badminton","Skiing","Golf","Hocky","Icehocky","Volleyball","Traiathlon","Tennis","Soccer","Softball","Pep Rally","Pick-Up","Sporting Event","Sports Practice","Tournament","Other");
subcat[26]=new Array("Meeting","Conference","Other")
subcat[27]=new Array("Sightseeing","Group Travel","Tour")

subcat[28]=new Array("Camping Trip","Daytrip","Group Trip","Roadtrip")
subcat[29]=new Array("Other");


function callCategeory()
{

	var SelObj=document.getElementById("category");
	var str="";
	var sub_category=document.getElementById("sub");
	var defval=document.getElementById("hsub");
			for(var i=sub_category.length-1;i>=0;i--){
				sub_category.remove(i);
			}
	var subcategory=subcat[SelObj.selectedIndex-1];
	var oOption=document.createElement("option");
	var innTxt=document.createTextNode(" -- Select Sub Category -- ");
	oOption.setAttribute('value','');
	oOption.appendChild(innTxt);
	sub_category.appendChild(oOption);
	if(subcategory){
		for(var i=0;i<subcategory.length;i++){
		oOption=document.createElement("OPTION");
		if(defval.value==subcategory[i]){
				oOption.setAttribute('selected','true');
			}
		var txt = document.createTextNode(subcategory[i]);
		var sttxt=subcategory[i];
		oOption.setAttribute('value',subcategory[i]);
		oOption.setAttribute('id',subcategory[i]);
		oOption.appendChild(txt);
		sub_category.appendChild(oOption);
		}
	}	
}
