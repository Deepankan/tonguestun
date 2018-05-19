$(function(){
  $('#example').DataTable();

  $('.login, .sign-up').click(function(){
    $('#sign-in').toggleClass('hide');
    $('#sign-up').toggleClass('hide');
  })
});