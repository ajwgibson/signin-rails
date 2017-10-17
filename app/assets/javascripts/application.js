// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets
//= require metisMenu/metisMenu.js
//= require sb-admin-2/sb-admin-2.js
//= require toastr
//= require sweetalert
//= require_tree .


$(function() {

  toastr.options = {
    "closeButton": true,
    "debug": true,
    "progressBar": true,
    "preventDuplicates": false,
    "positionClass": "toast-top-right",
    "onclick": null,
    "showDuration": "400",
    "hideDuration": "1000",
    "timeOut": "2000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };

  $('.toastr-message').each(function() {
    window["toastr"][$(this).attr('data-toastr-type')]($(this).text());
  });

  $("button[type=submit].sweet-confirm").on('click', function(e) {
      e.preventDefault();
      var form = $(this).parents('form');
      swal({
          title: "Are you sure?",
          type: "warning",
          showCancelButton: true,
          cancelButtonText: "No",
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes",
          closeOnConfirm: false
      }, function(isConfirm){
          if (isConfirm) form.submit();
      });
  });

});
