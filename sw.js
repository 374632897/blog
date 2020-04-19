importScripts('/workbox-sw.js');

if (workbox) {
  console.log(`Yay! Workbox is loaded 🎉`);
  workbox.setConfig({ modulePathPrefix: 'https://g.alicdn.com/kg/workbox/3.3.0/' });

  workbox.precaching.precache(['/', '/index.html']);

  workbox.routing.registerRoute(new RegExp('^https?://blog.noteawesome.com/?$'), workbox.strategies.networkFirst());

  workbox.routing.registerRoute(new RegExp('.*.html'), workbox.strategies.networkFirst());

  workbox.routing.registerRoute(new RegExp('.*.(?:js|css|jpg|png|gif)'), workbox.strategies.staleWhileRevalidate());
} else {
  console.log(`Boo! Workbox didn't load 😬`);
}
