$(document).ready(function(){
  $('.availability').on('change', function(){
    $(this).closest('form').submit();
  })
});
