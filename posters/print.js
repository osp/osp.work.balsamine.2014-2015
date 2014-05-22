// Choose the number of pages of the document
var nb_page = 2;


// Loads main content into <section id="container">
//$("section#container").load("content.html");

$(window).load(function(){
    // __________________________________ DEBUG __________________________________ //
    $("button#debug").click(function(e){
        e.preventDefault();
        $(this).toggleClass("button-active");
        $("html").toggleClass("debug");
    });


    // __________________________________ PRINT PREVIEW __________________________________ //
    $("button#preview").click(function(e){
        e.preventDefault();
        $(this).toggleClass("button-active");
        $("html").toggleClass("export");
        //$("img").each(function(){
            //var hires = $(this).attr("data-alt-src");
            //var lores = $(this).attr("src");
            //$(this).attr("data-alt-src", lores)
            //$(this).attr("src", hires)
        //});
        $(".moveable img").toggle();
        $(".moveable svg").toggle();
    });


    // __________________________________ PRINT MARKS __________________________________ //
    var doc_height = $("body").height();
    var page_height = $("#master-page").height(); 

    for (i = 1; i < nb_page; i++){
        $("#master-page").clone().addClass("preview-page").attr("id","page-"+i).insertBefore($("#master-page"));
    }
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
    $(".moveable").
        append("<div class='properties button'>Properties</div>").
        draggable({
                cursor: "move",
                stack: ".moveable", 
                cancel: ".properties",
        }).
        resizable();
    $("button#back2front").click(function(){
        $(this).toggleClass("button-active");
        $(".moveable").toggleClass("foreground");
        $(".preview-page").toggleClass("overflow");
    });

    $('.properties').on('mouseover', function() {
        var top = Math.floor(parseInt($(this).parent().css('top')));
        var left = Math.floor(parseInt($(this).parent().css('left')));
        var width = Math.floor($(this).parent().width());
        var height = Math.floor($(this).parent().height());
        $(this).text('top: ' + top + 'px; left: ' + left + 'px; width: ' + width + 'px; height: ' + height + 'px;')
    });

});