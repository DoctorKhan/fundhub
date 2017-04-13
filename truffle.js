module.exports = {
  build: {
    "index.html": "index.html",
    "app.js": [
      "javascripts/app.js"
    ],
    "app.css": [
      "stylesheets/app.css"
    ],
    "fundhub.js": [
	"javascripts/_vendor/angular.js",
	"javascripts/fundhubController.js"
    ]
  },
  rpc: {
    host: "localhost",
    port: 8545
  }
};
