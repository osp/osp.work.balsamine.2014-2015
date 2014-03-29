$(window).load(function(){
    // __________________________________ PRINT MARKS __________________________________ //
    doc_height = $("body").height();
    page_height = $("#master-page").height(); 
    //page_height = 22; 
    nb_page = Math.ceil(doc_height/page_height);
    //gutter = parseInt($("#fakepage").css("top"));  // = 1cm

    console.log(doc_height);
    console.log(page_height);
    console.log(nb_page);

    for (i = 0; i < nb_page; i++){
        $("#master-page").clone().addClass("preview-page").attr("id","page"+i).insertBefore($("#master-page"));
            
        // FOLIO
        //$("#fakepage-p" + i + " .folio").html("<p>page " + (i+1) + "</p>");
    }
    $("#master-page").hide();



    $("div.bouge").append("<div class='properties'>Propriétés</div>").draggable(
            {
                stack: "div.bouge", 
            }).resizable();
    $('.properties').on('click', function() {
        var style = $(this).parent('.bouge').attr('style');
        var p = new Popelt({
            title: 'Styles à reporter dans le mode édition',
            content: 'style = "' + style + '"',
        }).show();
    });
});
