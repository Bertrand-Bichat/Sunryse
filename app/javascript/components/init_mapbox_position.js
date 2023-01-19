import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!


const sleep = (time) => {
  return new Promise((resolve) => setTimeout(resolve, time));
};

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
    const element = document.createElement('div');
    element.className = 'marker';
    element.style.backgroundImage = `url('${marker.image_url}')`;
    element.style.backgroundSize = 'contain';
    element.style.width = '40px';
    element.style.height = '40px';

    new mapboxgl.Marker(element)
    .setLngLat([ marker.lng, marker.lat ])
    .setPopup(popup)
    .addTo(map)
  });
};

const addUserMarkerToMap = (map, userMarkerPosition) =>{
  const userMar = document.createElement('div');

  userMar.className = 'user_marker';
  userMar.style.backgroundImage = `url('${userMarkerPosition.image_url}')`;
  userMar.style.backgroundSize = 'contain';
  userMar.style.width = '20px';
  userMar.style.height = '20px';

  new mapboxgl.Marker(userMar)
  .setLngLat([ userMarkerPosition.lng, userMarkerPosition.lat ])
  .addTo(map)

  // map.addControl(
  //   new mapboxgl.GeolocateControl({
  //     positionOptions: {
  //       enableHighAccuracy: true
  //     },
  //     trackUserLocation: true
  //   })
  // );
};

const centerMapToUser = (map, userPosition) => {
  map.jumpTo({center: userPosition, zoom: 14.5});
}

const initMapboxPosition = () => {
  const mapElement = document.getElementById('map-position');
    if (mapElement) {
      mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
      const map = new mapboxgl.Map({
      container: 'map-position',
      style: 'mapbox://styles/eveuuh/ck82ukg8v27lu1inubx72v0wo/draft'
    });
      // map.scrollZoom.disable();
      // const markersHouse = JSON.parse(mapElement.dataset.markersHouse);
      const markersPosition = JSON.parse(mapElement.dataset.markersPosition);
      // addMarkersToMap(map, markersHouse);
      addMarkersToMap(map, markersPosition);

      // setInterval(function() {
        let userMarkerPosition = JSON.parse(mapElement.dataset.userMarker);
        let userPosition = [userMarkerPosition.lng, userMarkerPosition.lat, userMarkerPosition.image_url];
        addUserMarkerToMap(map, userMarkerPosition);
        centerMapToUser(map, userPosition);
        // console.log('initMapboxPosition');
      // }, 5000);
      sleep(60000).then(() => { // attend 1 minutes
        document.location.reload();
      });
    };
};

export { initMapboxPosition };
