const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const nodemailer = require("nodemailer");

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
