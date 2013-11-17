pusher = new Pusher('6e4f11b611afebfc624d')
channel = pusher.subscribe('reports');
channel.bind 'refresh', (data) -> 
  window.location.reload(true)
