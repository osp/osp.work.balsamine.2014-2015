// Choose the number of pages of the document
var nb_page = 16;


// Loads main content into <section id="container">
$("section#container").load("content.html");

$(window).load(function(){
    // __________________________________ DEBUG __________________________________ //
    $("#debug").click(function(e){
        e.preventDefault();
        $("html").toggleClass("debug");
    });


    // __________________________________ PRINT PREVIEW __________________________________ //
    $("a#preview").click(function(e){
        e.preventDefault();
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

    for (i = 0; i < nb_page; i++){
        $("#master-page").clone().addClass("preview-page").attr("id","page"+i).insertBefore($("#master-page"));
    }
    $("#master-page").hide();


    // __________________________________ MOVEABLE ELEMENTS __________________________________ //
    $("div.moveable").
        append("<div class='properties button'>Properties</div>").
        draggable({
                cursor: "move",
                stack: "div.moveable", 
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
