$(document).ready(function(){
  $("input[name=availability]").on('change', function(){
    var responderAvailability = this.checked ? 'available' : 'unavailable',
    path = $(this).data('update');
    $.ajax({
      url: path,
      type: 'PUT',
      data: {responder: {availability: responderAvailability}},
      success: function(data){
        console.log(data);
      }
    });
  })
});
