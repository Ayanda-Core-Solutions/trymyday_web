const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const nodemailer = require("nodemailer");

if (!admin.apps.length) {
  admin.initializeApp();
}

const smtpUser = defineSecret("SMTP_USER");
const smtpPass = defineSecret("SMTP_PASS");

const contactRecipient =
  process.env.CONTACT_EMAIL_ADDRESS || "ayandamhlongof@gmail.com";
const smtpHost = process.env.SMTP_HOST || "smtp.gmail.com";
const smtpPort = Number(process.env.SMTP_PORT || 587);
const smtpSecure = process.env.SMTP_SECURE === "true";
const smtpFromName = process.env.SMTP_FROM_NAME || "TryMyDay";

exports.sendWebContactEmail = onCall(
  {secrets: [smtpUser, smtpPass]},
  async (request) => {
    const data = request.data || {};
    const name = readRequired(data.name, "name");
    const email = readRequired(data.email, "email");
    const message = readRequired(data.message, "message");
    const mobile = readOptional(data.mobile);

    if (!isValidEmail(email)) {
      throw new HttpsError("invalid-argument", "A valid email is required.");
    }

    const transporter = nodemailer.createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: smtpSecure,
      auth: {
        user: smtpUser.value().trim(),
        pass: smtpPass.value().replace(/\s/g, ""),
      },
    });

    const fields = [
      ["Name", name],
      ["Email", email],
      ["Mobile", mobile || "Not provided"],
      ["Message", message],
    ];

    await transporter.sendMail({
      from: `${smtpFromName} <${smtpUser.value().trim()}>`,
      to: contactRecipient,
      replyTo: email,
      subject: `TryMyDay contact enquiry from ${name}`,
      text: fields.map(([label, value]) => `${label}: ${value}`).join("\n\n"),
      html: fields
        .map(([label, value]) => {
          return `<p><strong>${escapeHtml(label)}:</strong><br>${escapeHtml(value)}</p>`;
        })
        .join(""),
    });

    logger.info("Contact email sent", {recipient: contactRecipient});

    return {ok: true};
  },
);

exports.requestWebAccountDeletion = onCall(
  {secrets: [smtpUser, smtpPass]},
  async (request) => {
    const data = request.data || {};
    const fullName = readRequired(data.fullName, "fullName");
    const email = readRequired(data.email, "email").toLowerCase();
    const reason = readOptional(data.reason).slice(0, 1000);
    const retentionNoticeAcknowledged =
      data.retentionNoticeAcknowledged === true;

    if (!isValidEmail(email)) {
      throw new HttpsError("invalid-argument", "A valid email is required.");
    }

    if (!retentionNoticeAcknowledged) {
      throw new HttpsError(
        "invalid-argument",
        "Please acknowledge the retention notice.",
      );
    }

    const firestore = admin.firestore();
    const existingSnapshot = await firestore
      .collection("account_deletion_requests")
      .where("emailLower", "==", email)
      .where("requestType", "==", "account_deletion")
      .where("isOpen", "==", true)
      .limit(1)
      .get();

    if (!existingSnapshot.empty) {
      const existing = existingSnapshot.docs[0];
      return {
        ok: true,
        requestId: existing.id,
        status: existing.data().status || "requested",
        alreadyExists: true,
      };
    }

    const requestRef = firestore.collection("account_deletion_requests").doc();
    await requestRef.set({
      userId: null,
      email,
      emailLower: email,
      fullName,
      userType: "",
      professionalId: "",
      authProvider: "",
      requestType: "account_deletion",
      status: "requested",
      isOpen: true,
      source: "web",
      reason,
      deleteAccount: true,
      partialDeletion: false,
      retentionNoticeAcknowledged: true,
      requestedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await sendAccountDeletionNotice({
      fullName,
      email,
      reason,
      requestId: requestRef.id,
    });

    logger.info("Web account deletion request recorded", {
      requestId: requestRef.id,
    });

    return {
      ok: true,
      requestId: requestRef.id,
      status: "requested",
      alreadyExists: false,
    };
  },
);

async function sendAccountDeletionNotice({fullName, email, reason, requestId}) {
  const transporter = nodemailer.createTransport({
    host: smtpHost,
    port: smtpPort,
    secure: smtpSecure,
    auth: {
      user: smtpUser.value().trim(),
      pass: smtpPass.value().replace(/\s/g, ""),
    },
  });

  const fields = [
    ["Request ID", requestId],
    ["Name", fullName],
    ["Email", email],
    ["Reason", reason || "Not provided"],
  ];

  await transporter.sendMail({
    from: `${smtpFromName} <${smtpUser.value().trim()}>`,
    to: contactRecipient,
    replyTo: email,
    subject: `TryMyDay account deletion request from ${fullName}`,
    text: fields.map(([label, value]) => `${label}: ${value}`).join("\n\n"),
    html: fields
      .map(([label, value]) => {
        return `<p><strong>${escapeHtml(label)}:</strong><br>${escapeHtml(value)}</p>`;
      })
      .join(""),
  });
}

function readRequired(value, fieldName) {
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new HttpsError("invalid-argument", `${fieldName} is required.`);
  }

  return value.trim();
}

function readOptional(value) {
  if (typeof value !== "string") return "";

  return value.trim();
}

function isValidEmail(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
}

function escapeHtml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;")
    .replaceAll("\n", "<br>");
}
