const { getMessaging } = require('firebase-admin/messaging');
const admin = require('firebase-admin');
require('dotenv').config({ path: '../.env' });

admin.initializeApp({
    credential: admin.credential.cert(process.env.FIREBASE_ADMIN_CREDENTIALS),
});

const db = admin.firestore();

const pushNotifications = async (req, res) => {
    try {
        // Get the name of the missing person
        const { name, age } = req.body;

        // Fetch the FCM tokens from Firestore collection
        const tokensSnapshot = await db.collection('fcmTokens').get();

        if (tokensSnapshot.empty) {
            return res.status(400).json({
                message: 'No FCM tokens found in the database.',
            });
        }

        // Extract FCM tokens from Firestore
        const fcmTokens = tokensSnapshot.docs
            .map(doc => doc.data().token)
            .filter(token => token);

        // Ensure each token is unique, avoiding duplicates
        const uniqueTokens = [...new Set(fcmTokens)];

        if (uniqueTokens.length === 0) {
            return res.status(400).json({
                message: 'No valid FCM tokens available.',
            });
        }

        // Define notification message
        const message = {
            notification: {
                title: "Missing Person Alert",
                body: name + ", aged " + age + ", has been reported missing just now, press this notification for more details.",
                
            },
        };

        // Send a push notification on every device
        const response = await getMessaging().sendEachForMulticast({
            tokens: uniqueTokens,
            notification: message.notification,
        });

        // Check the response for failed messages
        const failedTokens = response.responses
            .map((resp, index) => resp.error ? uniqueTokens[index] : null)
            .filter(token => token);

        if (failedTokens.length > 0) {
            return res.status(500).json({
                message: 'Notifications failed to push on some devices',
                failedTokens,
            });
        }

        return res.status(200).json({
            message: 'Notification successfully pushed to all devices',
        });

    } catch (error) {
        console.error("Error sending notification: ", error);
        return res.status(500).json({
            message: 'Something went wrong',
            error: error.message || error,
        });
    }
}

module.exports = pushNotifications;
