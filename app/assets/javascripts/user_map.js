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
  
  var createUserWindow = function(user){
    var html = $("#marker_template").clone().removeClass("hide").html();
    html = html.replace(/:avatar:/, user['avatar']);
    html = html.replace(/:link:/g, user['link']);
    html = html.replace(/:username:/, user['username']);
    html = html.replace(/:user_class:/, user['user_class']);
    html = html.replace(/:level:/, user['level']);
    
    if(user['common_games'].length > 0){
      games = "<strong>Games you both play: </strong>";
      arr = []
      $.each(user['common_games'], function(){ arr.push("<a href='" + user['link'] + "'>" + user['name'] + "</a>") })
      games += arr.join(", ")
    } else {
      games = "<strong>Games: </strong>";
      arr = []
      $.each(user['games'], function(){ arr << "<a href='" + user['link'] + "'>" + user['name'] + "</a>" })
      games += arr.join(", ")
    }
    html = html.replace(/:games:/, games);
    
    if(user['common_networks'].length > 0){
      networks = "<strong>You're both on: </strong>" + user['common_networks'].join(", ");
    } else {
      networks = "<strong>Networks: </strong>" + user['networks'].join(", ");
    }
    html = html.replace(/:networks:/, networks);
    
    return html;
  }
  
  var placeMarkers = function(data){
    if(typeof($.gmaps_markers) == "undefined")
      $.gmaps_markers = [];
    else{
      $.each($.gmaps_markers, function(idx, marker){ marker.setMap(null); });
      $.gmaps_markers = [];
    }
    
    if(typeof($.gmaps_oms) == "undefined")
      $.gmaps_oms = [];
    else{
      $.each($.gmaps_oms, function(idx, oms){ 
        $.each(oms.getMarkers(), function(idx, marker){ marker.setMap(null); });
        oms.clearMarkers();
      });
      $.gmaps_oms = [];
    }
      
    $.each(data, function(key, val){
      
      if(val.length == 1){
        user = val.pop();
        html = createUserWindow(user);
        var latlng = new google.maps.LatLng(user['lat'], user['lng']);
        var infowindow = new google.maps.InfoWindow({
            content: html,
            maxWidth: 300
        });
        var marker = new google.maps.Marker({
            position: latlng,
            map: map,
            title: user['title']
        });
        google.maps.event.addListener(marker, 'click', function() {
          if(typeof($.gmaps_infowindow) != "undefined")
            $.gmaps_infowindow.close();
          infowindow.open(map,marker);
          $.gmaps_infowindow = infowindow;
        });

        $.gmaps_markers.push(marker);
        
      }else{
        var oms = new OverlappingMarkerSpiderfier(map, {keepSpiderfied: true});
        var infoWindow = new google.maps.InfoWindow();
        oms.addListener('click', function(marker) {
          if(typeof($.gmaps_infowindow) != "undefined")
            $.gmaps_infowindow.close();
          infoWindow.setContent(marker.desc);
          infoWindow.open(map, marker);
          $.gmaps_infowindow = infowindow;
        });
        oms.addListener('spiderfy', function(markers) {
          infoWindow.close();
        });
        
        $.each(val, function(idx, user){
          html = createUserWindow(user);
          var latlng = new google.maps.LatLng(user['lat'], user['lng']);
          var marker = new google.maps.Marker({
              position: latlng,
              map: map,
              title: user['title']
          });
          marker.desc = html;
          oms.addMarker(marker);
        });
        $.gmaps_oms.push(oms);
      }
      
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
  
  google.maps.event.addListener(map, 'dragend', updateMap);
  updateMap();
});