const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();

exports.sendNotification = functions.pubsub.schedule('* * * * *').onRun(async (context) => {
    const query = await database.collection('notifications').where('whenToNotify','<=', admin.firestore.Timestamp.now().where('notificationStatus','==',false).get());
    
    query.forEach(async snapshot => {
        sendNotification(snapshot.data().token);
        await database.doc('notifications/' + snapshot.data().token).update({
            'notificationStatus' : true,
        });
    });

    function sendNotification(androidNotificationToken) {
        let title = snapshot.data().notificationTitle;
        let body = snapshot.data().notificationBody;

        const message = {
            notification : {title: title, body: body},
            token: androidNotificationToken,
            data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'},
        };

        admin.messaging().send(message).then(response => {
            return console.log("Successful message sent");
        }).catch(error => {
            return console.log("Error sending message");
        });
    }
    return console.log('send notification');
})

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
