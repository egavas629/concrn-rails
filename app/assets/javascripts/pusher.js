$(document).ready(function(){

  if(typeof channelName() != 'undefined' && channelName().length > 0 && !window.onunload){
    var pusherKey = $('body').data('pusher-key'),
        pusher    = new Pusher(pusherKey);
    pusher.subscribe(channelName());
    pusher.bind("refresh", function(data){
      $(function() {
        $.extend($.gritter.options, {
          position: 'bottom-right',
          width: '215px',
          height: '50px'
        });
        $.gritter.add({
          title: 'New information arrived!',
          text: "<a href='javascript:window.location.reload()'>Click here to update.</a>",
          sticky: false,
          time: 10000
        });
      });
    });
    pusher.bind("message", function(data){
      $('#log_body').val('');
      addMessage(data);
    });
  }

  function channelName(){
    var name;
    if($('.pusher').length > 0){
      name = 'reports-responders'
    }else if($('.pusher-id').length >0){
      var id = $('.pusher-id').data('id');
      name = 'report-' + id;
    }
    return name;
  }

  function addMessage(data){
    var logId = 'log_' + data['id'],
        messageRow = $('#' + logId);
    if(messageRow.length > 0){
      messageRow.html(data['inner_html'])
    }else{
      messageRow = document.createElement('tr');
      messageRow.setAttribute('id', logId);
      messageRow.innerHTML = data['inner_html'];
      $('#transcript').find('tbody').append(messageRow);
    }
  }
})
