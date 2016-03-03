<link rel="stylesheet" type="text/css" href="<%=resourceaddress%>/main/build/fonts/fonts.css">
<link type="text/css" rel="stylesheet" href="<%=resourceaddress%>/main/build/carousel/assets/skins/sam/carousel.css">

<script src="<%=resourceaddress%>/main/build/utilities/utilities.js"></script>
<script src="<%=resourceaddress%>/main/js/YUI/carousel-min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=resourceaddress%>/main/css/YUI/yui.css">
<link rel="stylesheet" type="text/css" href="<%=resourceaddress%>/main/css/YUI/yuioverwrite.css">
<div id="testimonialcontainer">
<ol id="carousel">
<li class="item"><iframe width="290" height="280" frameborder="0" allowfullscreen="" src="//www.youtube.com/embed/EI1_xDgGvb0"></iframe></li>
<li class="item">
<img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/customers.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/1.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/2.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/3.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/4.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/5.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/6.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/7.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/8.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/9.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/10.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=resourceaddress%>/main/images/home/11.jpg"/></li>

</ol>
</div>
<script>
    (function () {
        var carousel;

        YAHOO.util.Event.onDOMReady(function (ev) {
            var carousel    = new YAHOO.widget.Carousel("testimonialcontainer", {
                        animation: { speed: 0.5 },
                        isVertical:false,
                        numVisible:1,
                        selectOnScroll:false

                });

            carousel.CONFIG.MAX_PAGER_BUTTONS=13;
            carousel.render(); // get ready for rendering the widget
            carousel.show();   // display the widget
            carousel.startAutoPlay();
        });
    })();
</script>
