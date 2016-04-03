$(document).ready(function(){
  $('.dispatch_status select').on('change', function(){
    this.form.submit();
  })
})

$(document).ready(function(){
  $('form.assign-client select').on('change', function(){
    this.form.submit();
  })
})
