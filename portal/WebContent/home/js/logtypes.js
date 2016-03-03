function selectcategories()
  {
 
  var movies=new Array("Hindi","Telugu","Tamil","Punjabi","Kannada","Malayalam","Marati","English","Other");
  //var travel=new Array("Business","Recreation","Other");
  //var reviews=new Array("Phone cards","Books","Doctors","Restaurents","Recreation","Stores","Websites","Airlines","Other");
  var recipies=new Array("Vegetarian","Non-vegetarian","Other");
  var deals=new Array("Electronics","Travel","Other");
  //var humor=new Array("India","Foreign");
  //var experiences=new Array("India","Abroad");
  var typeindex=document.form.type.options[document.form.type.options.selectedIndex].value;
 
  document.form.category.length=1;
  if(typeindex=='Movies')
  {
  	 document.form.category.length=movies.length+1;
 	 for(i=0;i<movies.length;i++){
	 document.form.category.options[i+1]=new Option(movies[i], movies[i]);
  }}
  if(typeindex=='Recipes')
    {
    	 document.form.category.length=recipies.length+1;
   	 for(i=0;i<recipies.length;i++){
  	 document.form.category.options[i+1]=new Option(recipies[i], recipies[i]);
  }}
  if(typeindex=='Deals')
    {
    	 document.form.category.length=deals.length+1;
   	 for(i=0;i<deals.length;i++){
  	 document.form.category.options[i+1]=new Option(deals[i], deals[i]);
  }}
  /*if(typeindex=='Travel')
  {
  	 document.form.category.length=travel.length+1;
 	 for(i=0;i<travel.length;i++){
	 document.form.category.options[i+1]=new Option(travel[i], travel[i]);
  }}
  
  if(typeindex=='Reviews')
  {
  	 document.form.category.length=reviews.length+1;
 	 for(i=0;i<reviews.length;i++){
	 document.form.category.options[i+1]=new Option(reviews[i], reviews[i]);
  }}
  
  if(typeindex=='Humor')
  {
	 document.form.category.length=humor.length+1;
 	 for(i=0;i<humor.length;i++){
	 document.form.category.options[i+1]=new Option(humor[i], humor[i]);
  }}
  if(typeindex=='Experiences')
  {
  	 document.form.category.length=experiences.length+1;
 	 for(i=0;i<experiences.length;i++){
	 document.form.category.options[i+1]=new Option(experiences[i], experiences[i]);
  }}*/
  
  
 }
 
	
  function checklogForm(form){
    
  var typeindex=document.form.type.options[document.form.type.options.selectedIndex].value;
		 if(trim(document.form.type.value)==''){
  			alert(typeempty);
  			return false;
  }else	 if((typeindex=='Movies'||typeindex=='Travel'||typeindex=='Recipes'||typeindex=='Reviews & Recommendations'||typeindex=='Deals'||typeindex=='Humor'||typeindex=='Experiences')&&(trim(document.form.category.value)=='')){
  	  		alert(categoryempty);
  			return false;
  }else if(trim(document.form.title.value)==''){
  	  		alert(titleempty);
  	  		return false;
	}
	/*else if(trim(document.form.description.value)==''){
  	alert("Description is empty");
  	return false;
	}*/
	
  }
  function disableloglocation(){
  var typeindex=document.form.type.options[document.form.type.options.selectedIndex].value;
 
  if(typeindex=='Movies'||typeindex=='Humor'||typeindex=='Recipes')
  {
  document.form.city.disabled=true;
  document.form.state.disabled=true;
  document.form.country.disabled=true;
  }else{
   document.form.city.disabled=false;
  document.form.state.disabled=false;
  document.form.country.disabled=false;
  }
  if(typeindex=='Movies'||typeindex=='Deals'||typeindex=='Recipes')
     {
    document.form.category.disabled=false;
    }
    else{
     document.form.category.disabled=true;
     }
  
  }
function disableloglocation1(){
var typeindex=document.form.type.options[document.form.type.options.selectedIndex].value;
  if(typeindex=='Movies'||typeindex=='Humor'||typeindex=='Recipes')
  {
  document.form.location.disabled=true;
    }else{
   document.form.location.disabled=false;
   }
  }
