const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
    .document('messages/{groupId1}/{groupId2}/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

        const idFrom = doc.idFrom
        const idTo = doc.idTo
        const contentMessage = doc.content

        // Get push token user to (receive)
        admin
            .firestore()
            .collection('users')
            .where('uid', '==', idTo)
            .get()
            .then(querySnapshot => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().displayName}`)
                    if (userTo.data().pushToken) {
                        // Get info user from (sent)
                        admin
                            .firestore()
                            .collection('users')
                            .where('uid', '==', idFrom)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().displayName}`)
                                    const payload = {
                                            notification: {
                                                title: `Tienes un mensaje de "${userFrom.data().displayName}"`,
                                                body: contentMessage,
                                                badge: '1',
                                                sound: 'default'
                                            }
                                        }
                                        // Let push to the target device
                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().pushToken, payload)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user')
                    }
                })
            })
        return null
    })