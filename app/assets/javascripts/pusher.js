var channels = formatChannelNames();
if(channels.length > 0){
  var pusherKey = $('body').data('pusher-key'),
      pusher    = new Pusher(pusherKey);
  channels.forEach(function(channel){
    pusher.subscribe(channel);
  })
  pusher.bind("refresh", function(data){
    return window.location.reload(true);
  });
}

function formatChannelNames(){
  var channels = [];
  $('.pusher').each(function(index){
    var id   = $(this).data('id'),
        type = $(this).data('type');
    channels.push(type + '-' + id);
  });
  // User on index page that when repsonders update, should refresh
  if(channels.length > 1){
    channels.push('reports');
  }

  return channels;
};
