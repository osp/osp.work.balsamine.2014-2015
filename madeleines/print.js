// Choose the number of pages of the document
var nb_page = 14;
//var nb_page = $(".preview-page").length;



// Loads main content into <section id="container">
// For the flyers, we don't need this as everything is in one file
//$("section#container").load("content-bleu.html");

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
        $("img").each(function(){
            var hires = $(this).attr("data-alt-src");
            var lores = $(this).attr("src");
            $(this).attr("data-alt-src", lores)
            $(this).attr("src", hires)
        });
    });


    // __________________________________ PRINT MARKS __________________________________ //
    var doc_height = $("body").height();
    var page_height = $("#master-page").height(); 

    //printmarks = "\
            //<div class="crop-top-left">                                              \n \
                //<div class="crop-right" style="top: 0; right: 0;"></div>             \n \
                //<div class="crop-bottom" style="bottom: 0cm; left: 0;"></div>        \n \
            //</div>                                                                   \n \
            //<div class="crop-top-right">                                             \n \
                //<div class="crop-left" style="top: 0; left: 0;"></div>               \n \
                //<div class="crop-bottom" style="bottom: 0; right: 0;"></div>         \n \
            //</div>                                                                   \n \
            //<div class="crop-bottom-right">                                          \n \
                //<div class="crop-left" style="left: 0; bottom: 0;"></div>            \n \
                //<div class="crop-top" style="right: 0cm; top: 0;"></div>             \n \
            //</div>                                                                   \n \
            //<div class="crop-bottom-left">                                           \n \
                //<div class="crop-right" style="bottom: 0cm; right: 0;"></div>        \n \
                //<div class="crop-top" style="left: 0cm; top: 0"></div>               \n \
            //</div>                                                                   \n \
    //"

    $(".bla").append(' \
            <div class="crop-top-left">                                              \n \
                <div class="crop-right" style="top: 0; right: 0;"></div>             \n \
                <div class="crop-bottom" style="bottom: 0cm; left: 0;"></div>        \n \
            </div>                                                                   \n \
            <div class="crop-top-right">                                             \n \
                <div class="crop-left" style="top: 0; left: 0;"></div>               \n \
                <div class="crop-bottom" style="bottom: 0; right: 0;"></div>         \n \
            </div>                                                                   \n \
            <div class="crop-bottom-right">                                          \n \
                <div class="crop-left" style="left: 0; bottom: 0;"></div>            \n \
                <div class="crop-top" style="right: 0cm; top: 0;"></div>             \n \
            </div>                                                                   \n \
            <div class="crop-bottom-left">                                           \n \
                <div class="crop-right" style="bottom: 0cm; right: 0;"></div>        \n \
                <div class="crop-top" style="left: 0cm; top: 0"></div>               \n \
            </div>                                                                   \n \
    ');

    for (i = 1; i <= nb_page; i++){
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
        }).
        resizable();

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
