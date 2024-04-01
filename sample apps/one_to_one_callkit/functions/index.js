/* eslint-disable max-len */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require("firebase-admin");
const functions = require("firebase-functions");
const apiCalls = require("firebase-functions/v2/https");
const axios = require("axios");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifySubscribers = functions.https.onCall(async (data, _) => {
  try {
    const message = {
      data: {
        body: data.messageBody,
        roomInfo: data.roomCode,
        callType: data.callType,
      },
      token: data.targetDevices,
    };

    await messaging.send(message).then((response) => {
      // Response is a message ID string.
      console.log("Successfully sent message:", response);
    }).catch((error) => {
      console.log("Error sending message:", error);
    });

    return true;
  } catch (ex) {
    return ex;
  }
});

exports.createRoom = apiCalls.onRequest((req, res) => {
  const managementToken = "Enter your management token here";
  const apiUrl = "https://api.100ms.live/v2/rooms";
  const roomCodeApiUrl = "https://api.100ms.live/v2/room-codes/room/";
  console.log(req.body.data);
  console.log(req.body.data.templateId);
  const requestData = {
    name: req.body.data.roomName,
    description: "hms_callkit_room",
    template_id: req.body.data.templateId,
  };
  const headers = {
    "Authorization": `Bearer ${managementToken}`,
    "Content-Type": "application/json",
  };
  axios.post(apiUrl, requestData, {headers: headers}).then((response) => {
    axios.post(`${roomCodeApiUrl}${response.data.id}`, {}, {headers: headers})
        .then((innerResponse) => {
          res.status(200).send({"data": innerResponse.data});
        })
        .catch((error) => {
          console.error("Error creating room code:", error);
          res.status(500).send({"data": "Error creating room code"});
        });
  }).catch((error) => {
    console.error("Error creating room:", error);
    res.status(500).send({"data": "Error creating room"});
  });
});
