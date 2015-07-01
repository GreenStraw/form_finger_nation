$(document).ready(function() {

  $(".my_party").click(function() {
    $('.product_area span').removeClass("hidden_p");
    $('.my_Parties li a').removeClass("active_p");

    var str = this.href.split("#")[1];
    var h_str = "MY PARTIES";
    if( str == "RSVPs"){
      h_str = str;
      str = "create_parties";
      // $("div.cl_rsvp_party").remove(); 
      // $(".add_rsvp_party:nth-child(3n)").after("<div class='clearfix cl_rsvp_party'></div>");
    }
    else
      str = "rsvp_party";
    $(this).addClass('active_p');
    document.getElementById(str).className += " hidden_p";
    document.getElementById("p_heading").innerHTML = h_str;
  });



  $("#locHref").click(function(e) {
    $("#locHref").toggleClass("active_p");
  });

  $(".changeLoc").click(function(e) {
    var v = $("#newLocVal").val();
    document.getElementById("NewlocUp").innerHTML = v;
    document.getElementById("curLoc").innerHTML = v;
    $("#locHref").removeClass("active_p");
    var userId = $("#newLocVal").data('user-id');
    var url = "/user/user_loc";
    $.ajax({
      url: url,
      type: 'PUT',
      data: {'id': userId,
             'loc': v,
             'ajax': true},
      success: function() {
      },
      error: function(){
        //do nothing
      }
    })
  });

  $('#loc').on('hidden.bs.modal', function () {
    $('#locHref').removeClass("active_p");
  });

  $("#menu-toggle").click(function(e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
  });

  $('.teams_sh').on('ifChecked', function(event){
    $('.teams_sh').removeClass("active_p");
    var str = $(this).val();
    $(this).addClass('active_p');
    $('.sp_contents').addClass("hidden_p");
    $('#'+str).removeClass("hidden_p");
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

    $('#ex1').slider();
    $('#time_slide').slider();
    $('#rsvp_slide').slider();

    $("#time_slide").on("slide", function(slideEvt) {
      $("#time_slideVal").text(slideEvt.value);
      var val0 = slideEvt.value,
        minutes0 = parseInt(val0 % 60, 10),
        hours0 = parseInt(val0 / 60 % 24, 10);
      startTime = getTime(hours0, minutes0);
      $("#time").text(startTime); //+ ' - ' + endTime
      $(".hid_class").val(startTime);
      $("#time_slideVal").text(startTime);
    });

    $("#rsvp_slide").on("slide", function(slideEvt) {
      var val0 = slideEvt.value;
      $(".hid_rsvp").val(val0);
      $("#rsvp_slideVal").text(val0);
    });

    $('.datepicker').datepicker({format: 'yyyy-mm-dd'});
    
    $('#ex2').slider();
    $('input').iCheck({
      checkboxClass: 'icheckbox_minimal-green',
      radioClass: 'iradio_minimal-green',
      increaseArea: '20%' // optional
    });

    $('.dropdown-menu.slide-box').click(function(e) {
      e.stopPropagation();
    });

    $("#acc_ph_change").on("click" ,function(){
      var input = document.getElementById("user_image_url");
      change_img(input)
      
    });

    $("#package_image_url").change(function(){
      var input = document.getElementById("package_image_url");
      change_img(input)
    });

    $("#sport_image_url").change(function(){
      var input = document.getElementById("sport_image_url");
      change_img(input)
    });

    $("#party_image_url").change(function(){
      var input = document.getElementById("party_image_url");
      change_img(input)
    });

    $("#team_image_url").change(function(){
      var input = document.getElementById("team_image_url");
      change_img(input)
    });

    $("#venue_image_url").change(function(){
      var input = document.getElementById("venue_image_url");
      change_img(input)
    });

    $("#party_ph_change").on("click" ,function(){
      console.log("in party upload photo");
      var input = document.getElementById("party_image_url");
      if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
          $('#acc_profile_image')
          .attr('src', e.target.result)
        };
        reader.readAsDataURL(input.files[0]);
      }
    });

  $('#new_venue').on('ifChecked', function() {
    console.log("if");
    $('#venue-create').removeClass('hidden');
    $('#venue-select').addClass('hidden');
  });
  $('#new_venue').on('ifUnchecked', function() {
    console.log("else");
    $('#venue-create').addClass('hidden');
    $('#party_venue_attributes_name').val('');
    $('#party_venue_attributes_address_attributes_street1').val('');
    $('#party_venue_attributes_address_attributes_street2').val('');
    $('#party_venue_attributes_address_attributes_city').val('');
    $('#party_venue_attributes_address_attributes_state').val('');
    $('#party_venue_attributes_address_attributes_zip').val('');
    $('#venue-select').removeClass('hidden');
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
function slideTime(event, ui){
  var val0 = $("#slider-range").slider("values", 0),
    minutes0 = parseInt(val0 % 60, 10),
    hours0 = parseInt(val0 / 60 % 24, 10);
  startTime = getTime(hours0, minutes0);
  endTime = getTime(hours1, minutes1);
  $("#time").text(startTime); //+ ' - ' + endTime
  $(".hid_class").val(startTime);
  $("#time_slideVal").text(startTime);
}
function getTime(hours, minutes) {
  var time = null;
  minutes = minutes + "";
  // if (hours < 12) {
  //   time = "AM";
  // }
  // else {
  //   time = "PM";
  // }
  if (hours == 0) {
    hours = 12;
  }
  // if (hours > 12) {
  //   hours = hours - 12;
  // }
  if (minutes.length == 1) {
    minutes = "0" + minutes;
  }
  return hours + ":" + minutes;
}
function change_img(input){
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#acc_profile_image')
      .attr('src', e.target.result)
    };
    reader.readAsDataURL(input.files[0]);
  }
}