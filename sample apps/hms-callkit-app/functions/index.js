const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifySubscribers = functions.https.onCall(async (data, _) => {
  try {
    console.log(data.targetDevices);
    await messaging.sendToDevice(data.targetDevices, {
      notification: {
        title: data.messageTitle,
        body: data.messageBody,
      },
      data: {
        params: data.callkitParams,
      },
    });

    return true;
  } catch (ex) {
    console.log(ex);
    return false;
  }
});
