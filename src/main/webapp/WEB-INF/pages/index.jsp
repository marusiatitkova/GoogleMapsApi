<%--
  Created by IntelliJ IDEA.
  User: marus
  Date: 10/11/2018
  Time: 12:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        #map {
            height: 100%;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>

<h1>Map</h1>

<div>
    <input type="text" id="address" placeholder="Type in address ">
    <button id="convert">
        Find
    </button>
</div>
<div>
    <h3>Map</h3>
    <div id="map">

    </div>
</div>
<script>
    var map;
    var markers = [];
    var latLong = [];

    // var uniqueMarkers = Array.from(new Set(markers));

    function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
            center: {lat: 50.4501, lng: 30.5234},
            zoom: 8
        });

        map.addListener('zoom_changed', function () {
            var markerCluster = new MarkerClusterer(map, markers,
                {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});

        });
    }
</script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8G1V6ewWq_gMWVOmSLqoD4U9RGG-_-yo&callback=initMap"
        async defer></script>

<script>
    $("#convert").click(function (e) {
        e.preventDefault();
        $.ajax({
            type: "POST",
            url: "/find",
            data: $("#address").val(),
            dataType: "text",
            success: function (response) {
                let json = JSON.parse(response);
                let bounds = new google.maps.LatLngBounds();
                for (var key in json) {
                    let marker = new google.maps.Marker({position: json[key], map: map});
                    if (!contains(latLong, json[key])) {
                        markers.push(marker);
                        latLong.push(json[key]);
                    }
                }

                for (let latLong of markers) {
                    bounds.extend(latLong.position);
                }
                map.fitBounds(bounds);
                var markerCluster = new MarkerClusterer(map, markers,
                    {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
            },
            error: function (error) {
                alert("error");
            }
        });
    });

    function contains(array, element) {
        for (let x of array) {
            if (
                (x.lat === element.lat) &&
                (x.lng === element.lng)
            ){
                return true;
            }
        }
        return false;
    }


</script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
</script>

</body>
</html>
