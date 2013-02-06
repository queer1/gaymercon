$(function(){
  var lat = $("#map_canvas").data('lat');
  if(typeof(lat) == "undefined" || typeof(lng) == "null")
    lat = 37.777125;
  
  var lng = $("#map_canvas").data('lng');
  if(typeof(lng) == "undefined" || typeof(lng) == "null")
    lng = -122.419644;
  
  var mapOptions = {
    center: new google.maps.LatLng(lat, lng),
    zoom: 10,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
  
  var placeMarkers = function(data){
    console.log(data);
    $.each(data, function(){
      var html = $("#marker_template").clone().removeClass("hide").html();
      html = html.replace(/:avatar:/, this['avatar']);
      html = html.replace(/:link:/g, this['link']);
      html = html.replace(/:username:/, this['username']);
      html = html.replace(/:user_class:/, this['user_class']);
      html = html.replace(/:level:/, this['level']);
      
      if(this['common_games'].length > 0){
        games = "<strong>Games you both play: </strong>";
        arr = []
        $.each(this['common_games'], function(){ arr.push("<a href='" + this['link'] + "'>" + this['name'] + "</a>") })
        games += arr.join(", ")
      } else {
        games = "<strong>Games: </strong>";
        arr = []
        $.each(this['games'], function(){ arr << "<a href='" + this['link'] + "'>" + this['name'] + "</a>" })
        games += arr.join(", ")
      }
      html = html.replace(/:games:/, games);
      
      if(this['common_networks'].length > 0){
        networks = "<strong>You're both on: </strong>" + this['common_networks'].join(", ");
      } else {
        networks = "<strong>Networks: </strong>" + this['networks'].join(", ");
      }
      html = html.replace(/:networks:/, networks);
      
      var latlng = new google.maps.LatLng(this['lat'], this['lng']);
      var infowindow = new google.maps.InfoWindow({
          content: html,
          maxWidth: 300
      });
      var marker = new google.maps.Marker({
          position: latlng,
          map: map,
          title: this['title']
      });
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map,marker);
      });
      
    });
  };
  
  var updateMap = function(){
    var coords = map.getCenter();
    $.get('/map', {
      "lat": coords.lat(),
      "lng": coords.lng()
      },
      placeMarkers
    );
  };
  
  google.maps.event.addListener(map, 'center_changed', updateMap);
  updateMap();
});