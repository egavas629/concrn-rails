pusher = new Pusher('6e4f11b611afebfc624d')
channel = pusher.subscribe('reports');
channel.bind 'report_created', (data) -> 
  window.location.reload(true)
