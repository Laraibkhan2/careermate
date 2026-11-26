const { onDocumentCreated, onDocumentUpdated } = require('firebase-functions/v2/firestore');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

const STATUS_TEXT = {
  applied: 'back to Applied',
  interviewing: 'moved to Interview',
  rejected: 'Rejected',
};

/**
 * Sends a notification to ONE user: reads the tokens saved in
 * users/{uid}.fcmTokens (written by the app) and sends only to them.
 */
async function sendToUser(uid, title, body) {
  if (!uid) return;

  const userRef = getFirestore().doc(`users/${uid}`);
  const tokens = (await userRef.get()).data()?.fcmTokens ?? [];
  if (tokens.length === 0) {
    console.log(`No tokens for ${uid}, nothing to send.`);
    return;
  }

  const result = await getMessaging().sendEachForMulticast({
    tokens,
    notification: { title, body },
    android: { priority: 'high' },
  });

  // Remove tokens that stopped working (app uninstalled, token expired).
  const dead = tokens.filter((_, i) => !result.responses[i].success);
  if (dead.length > 0) {
    await userRef.update({ fcmTokens: FieldValue.arrayRemove(...dead) });
  }
  console.log(`Sent to ${uid}: ${result.successCount} ok, ${result.failureCount} failed.`);
}

// A job seeker applies  ->  notify the EMPLOYER who owns the job.
exports.onApplicationCreated = onDocumentCreated('applications/{id}', (event) => {
  const app = event.data?.data();
  if (!app) return;
  return sendToUser(
    app.employerId,
    'New applicant',
    `${app.seekerName || 'Someone'} applied for ${app.jobTitle}`,
  );
});

// The employer changes the status  ->  notify the JOB SEEKER who applied.
exports.onApplicationStatusChanged = onDocumentUpdated('applications/{id}', (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after || before.status === after.status) return;

  return sendToUser(
    after.seekerId,
    'Application update',
    `Your application for ${after.jobTitle} was ${STATUS_TEXT[after.status] ?? after.status}`,
  );
});
