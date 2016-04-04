$(document).ready(function(){
	  var zoomLevel = 16;
  /* 
    for zoomLevel, 1 is really zoomed out (global view) and bigger numbers are more zoomed in.
    zoomLevel is an integer.
  */
  var latitude = 37.784659; 
  // latitude is the distance from the equator (north-south)
  var longitude = -122.4145; 
  // longitude is the distance from the Greenwich Meridian Line (east-west)

  mapboxgl.accessToken = 'pk.eyJ1IjoiYmVybmljZWNodWEiLCJhIjoiY2lrOHZsODJnMDByNnYwa3Byejd4azdwdyJ9.ULosBQzbIJtQg88gDsQExA';
  var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/light-v8',
      center: [longitude, latitude],
      zoom: zoomLevel
  });

  var popup = new mapboxgl.Popup({
      closeOnClick: false,
      closeButton: false
  });

  var legend = document.getElementById('legend');
  var monthLabel = document.getElementById('month');

  // Will contain the layers we wish to interact with on
  // during map mouseover and click events.
  var layerIDs = [];

  var magnitudes = [
      [8, '#7F3121'],
      [7.75, '#913C23'],
      [7.5, '#A24724'],
      [7.25, '#B35424'],
      [7, '#C46222'],
      [6.75, '#D37120'],
      [6.5, '#E2801B'],
      [6.25, '#EF9014'],
      [6, '#FCA107']
  ];

  var months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
  ];

  function filterBy(month, mag, index) {
      // Clear the popup if displayed.
      popup.remove();

      var filters = [
          "all",
          ["==", "month", month],
          [">=", "mag", mag[0]]
      ];

      if (index !== 0) filters.push(["<", "mag", magnitudes[index - 1][0]]);
      map.setFilter('circle-' + index, filters);
      map.setFilter('label-' + index, filters);

      // Set the label to the month
      monthLabel.textContent = months[month];
  }

  map.on('load', function() {

      // Data courtesy of http://earthquake.usgs.gov/
      // Query for significant earthquakes in 2015 URL request looked like this:
      // http://earthquake.usgs.gov/fdsnws/event/1/query
      //    ?format=geojson
      //    &starttime=2015-01-01
      //    &endtime=2015-12-31
      //    &minmagnitude=6'
      //
      // Here we're using d3 to help us make the ajax request but you can use
      // Any request method (library or otherwise) you wish.
      d3.json('/mapbox-gl-js/assets/data/significant-earthquakes-2015.geojson', function(err, data) {

          // Create a month property value based on time
          // used to filter against.
          data.features = data.features.map(function(d) {
              d.properties.month = new Date(d.properties.time).getMonth();
              return d;
          })

          map.addSource('earthquakes', {
              'type': 'geojson',
              'data': data
          });

          // Apply layer styles
          magnitudes.forEach(function(mag, i) {
              var layerID = 'circle-' + i;
              layerIDs.push(layerID);

              map.addLayer({
                  "id": layerID,
                  "type": "circle",
                  "source": "earthquakes",
                  "paint": {
                      "circle-color": mag[1],
                      "circle-opacity": 0.75,
                      "circle-radius": (mag[0] - 4) * 10 // Nice radius value
                  }
              });

              map.addLayer({
                  "id": "label-" + i,
                  "type": "symbol",
                  "source": "earthquakes",
                  "layout": {
                      "text-field": "{mag}m",
                      "text-font": ["Open Sans Bold", "Arial Unicode MS Bold"],
                      "text-size": 12
                  },
                  "paint": {
                      "text-color": "rgba(0,0,0,0.5)"
                  }
              });

              // Set filter to first month of the year +
              // Magnitude rating. 0 = January
              filterBy(0, mag, i);

              // Add legend bar
              var bar = document.createElement('div');
              bar.className = 'bar';
              bar.title = mag[0];
              bar.style.width = 100 / magnitudes.length + '%';
              bar.style.backgroundColor = mag[1];
              legend.insertBefore(bar, legend.firstChild);
          });

          document.getElementById('slider').addEventListener('input', function(e) {
              var month = parseInt(e.target.value, 10);
              magnitudes.forEach(function(mag, i) {
                  filterBy(month, mag, i);
              });
          });

          map.on('mousemove', function(e) {
              var features = map.queryRenderedFeatures(e.point, { layers: layerIDs });
              // Change the cursor style as a UI indicator.
              map.getCanvas().style.cursor = (features.length) ? 'pointer' : '';
          });

          map.on('click', function(e) {
              var features = map.queryRenderedFeatures(e.point, { layers: layerIDs });
              if (!features.length) {
                  popup.remove();
                  return;
              }

              var feature = features[0];

              var link = document.createElement('a');
              link.href = feature.properties.url;
              link.target = '_blank';
              link.textContent = feature.properties.place;

              // Use wrapped coordinates to ensure longitude is within (180, -180)
              var coords = feature.geometry.coordinates;
              var ll = new mapboxgl.LngLat(coords[0], coords[1]);
              var wrapped = ll.wrap();

              // Center the map to its point.
              map.flyTo({ center: wrapped });
              popup.setLngLat(wrapped)
                  .setHTML(link.outerHTML)
                  .addTo(map);
          });
      });
  });
});