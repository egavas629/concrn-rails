$(document).ready(function(){
  $('.dispatch_status select').on('change', function(){
    this.form.submit();
  })
})
