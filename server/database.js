const emitter = require('./commonEmitter.js');
var admin = require("firebase-admin");
var serviceAccount = require("./ar-jumbo-firebase-adminsdk-eanoa-3c5c4d773d.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),

  databaseURL: "https://ar-jumbo-default-rtdb.europe-west1.firebasedatabase.app/"
});

const db = admin.database();

const database = {
        getDBInstance: function(){
                return db;
        },
        getNavigationInstructions: function(destination){
                var path = "destination" + "/" + destination;
                var ref = db.ref(path);
                ref.once("value", function (snapshot){
                        emitter.emit('navigationInstructionsRetrieved', snapshot);
                });
        },
        getDestinationList: function() {
                var path = "destination";
                var ref = db.ref(path);
                ref.once("value", function(snapshot){
                        emitter.emit('destinationListRetrieved', snapshot);
                });
        },
        uploadCustomMap: function(uid, destination, json){
                var path = "users" + "/" + uid + "/" + "destination" + "/" + destination;
                var ref = db.ref(path).set(json, function(error) {
                        if (error) {
                                emitter.emit("uploadCustomMapCompleted", false);
                        } else {
                                emitter.emit("uploadCustomMapCompleted", true);
                        }
                });
        },
        getCustomMapNames: function(uid){
                var path = "users" + "/" + uid + "/" + "destination";
                var ref = db.ref(path);
                ref.once("value", function(snapshot){
                        emitter.emit("downloadCustomMapNamesRetrieved", snapshot);
                });
        },
        getCustomMap: function(uid, name){
                var path = "users" + "/" + uid + "/" + "destination" + "/" + name;
                var ref = db.ref(path);
                ref.once("value", function (snapshot){
                        emitter.emit('customMapRetrieved', snapshot);
                });
        }
}
module.exports = database;
