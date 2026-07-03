const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

if (!admin.apps.length) {
  admin.initializeApp();
}

const resendApiKey = defineSecret("RESEND_API_KEY");
const resendFromEmail = defineSecret("RESEND_FROM_EMAIL");

const contactRecipient =
  process.env.CONTACT_EMAIL_ADDRESS || "ayandamhlongof@gmail.com";

exports.sendWebContactEmail = onCall(
  {secrets: [resendApiKey, resendFromEmail]},
  async (request) => {
    const data = request.data || {};
    const name = readRequired(data.name, "name");
    const email = readRequired(data.email, "email");
    const message = readRequired(data.message, "message");
    const mobile = readOptional(data.mobile);

    if (!isValidEmail(email)) {
      throw new HttpsError("invalid-argument", "A valid email is required.");
    }

    const fields = [
      ["Name", name],
      ["Email", email],
      ["Mobile", mobile || "Not provided"],
      ["Message", message],
    ];

    await sendResendEmail({
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
  {secrets: [resendApiKey, resendFromEmail]},
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


exports.submitWebProfessionalApplication = onCall(
  {secrets: [resendApiKey, resendFromEmail]},
  async (request) => {
    const data = request.data || {};
    const fullName = readRequired(data.fullName, "fullName");
    const email = readRequired(data.email, "email").toLowerCase();
    const role = readRequired(data.role, "role");
    const experience = readRequired(data.experience, "experience");
    const location = readRequired(data.location, "location");
    const sessionTopic = readRequired(data.sessionTopic, "sessionTopic");
    const availability = readRequired(data.availability, "availability");
    const motivation = readRequired(data.motivation, "motivation");
    const company = readOptional(data.company);
    const phone = readOptional(data.phone);
    const linkedin = readOptional(data.linkedin);

    if (!isValidEmail(email)) {
      throw new HttpsError("invalid-argument", "A valid email is required.");
    }

    const firestore = admin.firestore();
    const existingApplication = await firestore
      .collection("professional_applications")
      .where("primaryEmailLowercase", "==", email)
      .limit(1)
      .get();

    if (!existingApplication.empty) {
      return {
        ok: true,
        alreadyExists: true,
        applicationId: existingApplication.docs[0].id,
        status: existingApplication.docs[0].data().status || "pending",
      };
    }

    const existingProfessional = await firestore
      .collection("professionals")
      .where("personalDetails.primaryEmailLowercase", "==", email)
      .limit(1)
      .get();

    if (!existingProfessional.empty) {
      return {
        ok: true,
        alreadyExists: true,
        professionalExists: true,
        status: "approved",
      };
    }

    const applicationRef = firestore.collection("professional_applications").doc();
    const nameParts = fullName.split(/\s+/).filter((part) => part.length > 0);
    const firstName = nameParts.shift() || fullName;
    const lastName = nameParts.join(" ");

    await applicationRef.set({
      userId: null,
      source: "web",
      primaryEmail: email,
      primaryEmailLowercase: email,
      candidateProfessional: {
        personalDetails: {
          firstName,
          lastName,
          displayName: fullName,
          primaryEmail: email,
          primaryEmailLowercase: email,
          primaryPhone: phone,
        },
        role,
        company,
        industries: [],
        yearsExperience: Number.parseInt(experience, 10) || 0,
        about: motivation,
        highlights: [],
        certificates: [],
        address: {
          fullAddress: location,
          streetNumber: "",
          streetName: "",
          city: location,
          province: "",
          postalCode: "",
          country: "",
          latitude: 0,
          longitude: 0,
        },
        sessionTopic,
        proposedRate: 0,
        sessionOffering: {topic: sessionTopic, price: 0},
        sessionOfferings: [{topic: sessionTopic, price: 0}],
        webLinks: {linkedin},
      },
      postApprovalSetup: {
        availabilityPlan: availability,
        availableCoffeeChatSlots: [],
        availablePaidSessionSlots: [],
      },
      status: "pending",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const fields = [
      ["Application ID", applicationRef.id],
      ["Name", fullName],
      ["Email", email],
      ["Phone", phone || "Not provided"],
      ["Role", role],
      ["Company", company || "Not provided"],
      ["Experience", experience],
      ["Location", location],
      ["Session topic", sessionTopic],
      ["Availability", availability],
      ["LinkedIn", linkedin || "Not provided"],
      ["Motivation", motivation],
    ];

    await sendResendEmail({
      to: contactRecipient,
      replyTo: email,
      subject: `TryMyDay web professional application from ${fullName}`,
      text: fields.map(([label, value]) => `${label}: ${value}`).join("\n\n"),
      html: fields
        .map(([label, value]) => {
          return `<p><strong>${escapeHtml(label)}:</strong><br>${escapeHtml(value)}</p>`;
        })
        .join(""),
    });

    logger.info("Web professional application recorded", {
      applicationId: applicationRef.id,
    });

    return {ok: true, alreadyExists: false, applicationId: applicationRef.id};
  },
);

async function sendAccountDeletionNotice({fullName, email, reason, requestId}) {
  const fields = [
    ["Request ID", requestId],
    ["Name", fullName],
    ["Email", email],
    ["Reason", reason || "Not provided"],
  ];

  await sendResendEmail({
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

async function sendResendEmail({to, replyTo, subject, text, html}) {
  const apiKey = resendApiKey.value();
  const fromEmail = resendFromEmail.value();

  if (!apiKey || !fromEmail) {
    logger.error("Missing Resend config for web email.");
    throw new HttpsError("failed-precondition", "Email is not configured.");
  }

  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: fromEmail,
      to: [to],
      reply_to: replyTo,
      subject,
      text,
      html,
    }),
  });

  if (!response.ok) {
    const errorBody = await response.text();
    logger.error("Resend web email failed", {
      status: response.status,
      body: errorBody.slice(0, 500),
    });
    throw new HttpsError("internal", "Email could not be sent.");
  }
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
