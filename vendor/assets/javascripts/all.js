$(document).ready(function() {
  
  $(".scroll_to").click(function() {
    $('.scroll_to_div ul li').removeClass("side_active");
    var str = this.href.split("#")[1];
    $('html, body').animate({
        scrollTop: $("#"+str).offset().top
    }, 500);
    $(this).parent().addClass('side_active');
  });
  // if ($('#side_bar_fx').length > 0 ){
  //   scroll_side();
  // }
});

// function scroll_side(){
//   var sidebar = $('#side_bar_fx').offset();
//   $(window).scroll(function(){
//     console.log(sidebar.top + ", " + $(window).scrollTop());
//     if($(window).scrollTop() > sidebar.top+12){
//       $('#side_bar_fx').css('position','fixed').css('top', '135px');
//     } else {
//       $('#side_bar_fx').css('position','absolute').css('top', '95px');
//     } 
//     if ($(window).scrollTop() >= $("#Venues").offset().top-100){
//       activate_fx("#ven"); 
//     } 
//     if ($(window).scrollTop() >= $("#alumni_groups").offset().top-150){
//       activate_fx("#al"); 
//     }
//     if ($(window).scrollTop() >= $("#sports").offset().top-200) 
//     {
//       activate_fx("#sp"); 
//     }   
//   });
// }

// function activate_fx(cls){
//   $('.scroll_to_div ul li').removeClass("side_active");
//   $(cls).addClass('side_active');
// }

// $(window).load(function(){
//   scroll_side();
// });