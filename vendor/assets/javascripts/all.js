$(document).ready(function() {

  $(".my_party").click(function() {
    $('.product_area div').removeClass("hidden_p");
    $('.my_Parties li a').removeClass("active_p");

    var str = this.href.split("#")[1];
    if( str == "RSVPs")
      str = "create_parties"
    else
      str = "rsvp_party"
    $(this).addClass('active_p');
    document.getElementById(str).className += " hidden_p";
  });


  $(".scroll_to").click(function() {
    $('.scroll_to_div ul li').removeClass("side_active");
    var str = this.href.split("#")[1];
    $('html, body').animate({
      scrollTop: $("#"+str).offset().top
    }, 500);
    $(this).parent().addClass('side_active');
  });
  if ($('#side_bar_fx').length > 0 ){
    scroll_side();
  }

  var scrolled=0;

  $("#downClick").on("click" ,function(){
                scrolled=scrolled+200;
    console.log(scrolled);
        if (scrolled > 600 ) {
          scrolled = 600
        };
        $("#qs_div").animate({
                scrollTop:  scrolled
           });

      });

    
    $("#upClick").on("click" ,function(){
        scrolled=scrolled-200;
        if (scrolled < 0 ) {
          scrolled = 0
        };
        console.log(scrolled);
        
        $("#qs_div").animate({
                scrollTop:  scrolled
           });

      });
});

function scroll_side(){
  var sidebar = $('#side_bar_fx').offset();
  $(window).scroll(function(){
    console.log(sidebar.top + ", " + $(window).scrollTop());
    var diff = 57
    if (sidebar.top > 712)
      var diff = -95
    if($(window).scrollTop() > sidebar.top+diff){
      $('#side_bar_fx').css('position','fixed').css('top', '95px');
    } 
    else{
      $('#side_bar_fx').css('position','absolute').css('top', '95px');
    }
    if ($(window).scrollTop() >= $("#Venues").offset().top-100){
      activate_fx("#ven"); 
    } 
    if ($(window).scrollTop() >= $("#alumni_groups").offset().top-150){
      activate_fx("#al"); 
    }
    if ($(window).scrollTop() >= $("#sports").offset().top-200) 
    {
      activate_fx("#sp"); 
    }   
  });
}

function activate_fx(cls){
  $('.scroll_to_div ul li').removeClass("side_active");
  $(cls).addClass('side_active');
}

function showhide(d_id){
  if (document.getElementById) {
    var divid = document.getElementById(d_id);
    var divs = document.getElementsByClassName("faq_massage");
    for(var i=0;i<divs.length;i++) {
      divs[i].style.display = "none";
    }
    divid.style.display = "block";
    $('#qs_div div div').removeClass("faq_active");
    document.getElementById(d_id+"d").className += " faq_active";
  } 
  return false;
}