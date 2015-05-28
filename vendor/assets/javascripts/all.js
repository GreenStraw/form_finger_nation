$(document).ready(function() {
  $(".scroll_to").click(function() {
    $('.scroll_to_div ul li').removeClass("active");
    var str = this.href.split("#")[1];
    $('html, body').animate({
        scrollTop: $("#"+str).offset().top
    }, 500);
    $(this).parent().addClass('active');
  });
});