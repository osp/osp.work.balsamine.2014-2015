// Choose the number of pages of the document
//var nb_page = 32;
var nb_page = $(".preview-page").length;


// Loads main content into <section id="container">
$("section#container").load("content.html");

$(window).load(function(){
    // __________________________________ DEBUG __________________________________ //
    $("button#debug").click(function(e){
        e.preventDefault();
        $(this).toggleClass("button-active");
        $("html").toggleClass("debug");
    });
    
    // __________________________________ SPREAD __________________________________ //
    $("button#spread").click(function(e){
        e.preventDefault();
        $(this).toggleClass("button-active");
        $("html").toggleClass("spread");
    });


    // __________________________________ HIGH RESOLUTION __________________________________ //
    $("button#hi-res").click(function(e){
        e.preventDefault();
        $(this).toggleClass("button-active");
        $("html").toggleClass("export");
        $("img").each(function(){
            var hires = $(this).attr("data-alt-src");
            var lores = $(this).attr("src");
            $(this).attr("data-alt-src", lores);
            $(this).attr("src", hires);
        });
        console.log("Wait for hi-res images to load");
        window.setTimeout(function(){
            console.log("Check image resolution");
            // Redlights images too small for printing
            $("img").each(function(){
                if (Math.ceil(this.naturalHeight / $(this).height()) < 6) {
                    console.log($(this).attr("src") + ": " + Math.floor(this.naturalHeight / $(this).height()) );
                    if($(this).parent().hasClass("moveable")) {
                        $(this).parent().toggleClass("lo-res");
                    } else {
                        $(this).toggleClass("lo-res");
                    }
                }
            });
        }, 500);
    });


    // __________________________________ PRINT MARKS __________________________________ //
    var doc_height = $("body").height();
    var page_height = $("#master-page").height(); 

    $(".preview-page").each(function(){
        $(this).append("<div class='inside'>");
        $("#master-page").children().clone().appendTo($(".inside", $(this)));
        $(".moveable", $(this)).appendTo($(".inside", $(this)));
        $(".titre-courant", $(this)).appendTo($(".inside", $(this)));

        //$("#master-page").clone().addClass("preview-page").attr("id","page-"+i).insertBefore($("#master-page"));
    });
    $("#master-page").hide();

    // __________________________________ TOC __________________________________ //
    $(".preview-page").each(function(){
        page = $(this).attr("id");
        $("#toc-pages").append("<li><a href='#" + page + "'>" + page.replace("-", " ") + "</a></li>")
    });
    $("#goto").click(function(e){
        e.preventDefault();
        $(this).toggleClass("button-active");
        $("#toc-pages").toggle();
    });


    // __________________________________ MOVEABLE ELEMENTS __________________________________ //
    $("div.moveable").
        append("<div class='properties button'>Properties</div>").
        draggable({
                cursor: "move",
                stack: "div.moveable", 
        }).
        resizable();
    $("button#back2front").click(function(){
        $(this).toggleClass("button-active");
        $(".moveable").toggleClass("foreground");
        $(".preview-page").toggleClass("overflow");
    });

    $('.properties').on('click', function() {
        var top = $(this).parent().css('top');
        var left = $(this).parent().css('left');
        var width = $(this).parent().width();
        var height = $(this).parent().height();
        var p = new Popelt({
            title: "Properties to copy/paste into this object's style attribute.",
            content: 'style="top: ' + top + '; left: ' + left + '; width: ' + width + 'px; height: ' + height + 'px;"',
        }).show();
    });
});
