import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

const outputRoot = join(process.cwd(), 'build', 'web');
const outputDirectory = join(outputRoot, 'seo');
const source = await readFile(join(outputRoot, 'index.html'), 'utf8');

const pages = [
  {
    slug: 'about',
    title: 'About TryMyDay | Real, Practical Career Guidance',
    description: 'Learn how TryMyDay makes career guidance more human by connecting students, graduates, and career switchers with experienced professionals.',
    heading: 'Career guidance built around real conversations',
    body: 'TryMyDay helps students, graduates, career switchers, and curious professionals learn what a career is really like from people doing the work. Our mission is to make useful career insight more human, accessible, and practical.',
    sections: [
      ['Our mission', 'Connect curiosity with lived professional experience so people can make better-informed career decisions.'],
      ['Our promise', 'Real professionals, honest conversations, and practical context for your next step.'],
      ['Who TryMyDay is for', 'Students, graduates, career switchers, and anyone looking for clarity about their future.']
    ]
  },
  {
    slug: 'faq',
    title: 'TryMyDay FAQs | Coffee Chats, Bookings and Sessions',
    description: 'Find answers about free coffee chats, paid career sessions, scheduling, professional rates, and repeat bookings on TryMyDay.',
    heading: 'Frequently asked questions about TryMyDay',
    body: 'Quick answers about meeting professionals, free coffee chats, paid career sessions, rates, and scheduling.',
    sections: [
      ['What is a free coffee chat?', 'A short, casual video or voice conversation for asking initial questions before committing to a paid session.'],
      ['How do I book a paid session?', 'Find a professional, open their profile, review their availability, and choose a paid booking option.'],
      ['Do professionals set their own rates?', 'Yes. Professionals define their own rates and availability.'],
      ['Can I book the same professional again?', 'Yes. Repeat bookings support ongoing mentorship and career guidance.']
    ],
    schemaType: 'faq'
  },
  {
    slug: 'professionals',
    title: 'Become a TryMyDay Professional | Share Your Experience',
    description: 'Create your TryMyDay professional profile in two short steps, prepare your first session and availability, and go live after review.',
    heading: 'Create your professional profile in minutes',
    body: 'Start without an account, prepare your first bookable conversation, and finish scheduling while TryMyDay reviews your profile.',
    sections: [
      ['Create your profile', 'Add your name, role, experience, province, and service area. No exact address is collected.'],
      ['Add your first session', 'Describe one useful conversation and share when you are usually available.'],
      ['Review and go live', 'Prepare your schedule as a draft while TryMyDay completes a trust and safety review.']
    ]
  },
  {
    slug: 'contact',
    title: 'Contact TryMyDay | Career Guidance Support',
    description: 'Contact the TryMyDay team for help with career sessions, professional profiles, bookings, or general questions.',
    heading: 'Contact TryMyDay',
    body: 'Questions about career sessions, bookings, professional profiles, or TryMyDay? Our team is here to help.',
    sections: [
      ['General support', 'Email hello@trymyday.co.za for help or general enquiries.'],
      ['Account and privacy requests', 'Use the official contact form or email from the address connected to your TryMyDay account.']
    ]
  }
];

const escapeHtml = (value) => value
  .replaceAll('&', '&amp;')
  .replaceAll('<', '&lt;')
  .replaceAll('>', '&gt;')
  .replaceAll('"', '&quot;');

function faqSchema(page) {
  if (page.schemaType !== 'faq') return '';
  return `<script type="application/ld+json">${JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    mainEntity: page.sections.map(([name, text]) => ({
      '@type': 'Question',
      name,
      acceptedAnswer: { '@type': 'Answer', text }
    }))
  })}</script>`;
}

function renderContent(page) {
  const sections = page.sections.map(([heading, text]) =>
    `<section><h2>${escapeHtml(heading)}</h2><p>${escapeHtml(text)}</p></section>`
  ).join('');

  return `<main id="seo-content">
    <nav aria-label="Primary navigation"><a href="/">TryMyDay</a> <a href="/about">About</a> <a href="/faq">FAQs</a> <a href="/professionals">Professionals</a> <a href="/contact">Contact</a></nav>
    <article><h1>${escapeHtml(page.heading)}</h1><p>${escapeHtml(page.body)}</p>${sections}</article>
  </main>`;
}

function renderPage(page) {
  const canonical = `https://trymyday.co.za/${page.slug}`;
  return source
    .replace('<base href="$FLUTTER_BASE_HREF">', '<base href="/">')
    .replace(/<title>.*?<\/title>/, `<title>${escapeHtml(page.title)}</title>`)
    .replace(/(<meta name="description" content=")[^"]*(">)/, `$1${escapeHtml(page.description)}$2`)
    .replace(/(<link rel="canonical" href=")[^"]*(">)/, `$1${canonical}$2`)
    .replace(/(<meta property="og:title" content=")[^"]*(">)/, `$1${escapeHtml(page.title)}$2`)
    .replace(/(<meta property="og:description" content=")[^"]*(">)/, `$1${escapeHtml(page.description)}$2`)
    .replace(/(<meta property="og:url" content=")[^"]*(">)/, `$1${canonical}$2`)
    .replace(/(<meta name="twitter:title" content=")[^"]*(">)/, `$1${escapeHtml(page.title)}$2`)
    .replace(/(<meta name="twitter:description" content=")[^"]*(">)/, `$1${escapeHtml(page.description)}$2`)
    .replace('</head>', `${faqSchema(page)}<style>#seo-content{max-width:920px;margin:0 auto;padding:32px 24px;color:#173f3c;background:#f8fbf5;font-family:Arial,sans-serif}#seo-content nav{display:flex;flex-wrap:wrap;gap:18px;margin-bottom:64px}#seo-content a{color:#165a56}#seo-content article{max-width:720px}#seo-content h1{font-size:clamp(36px,6vw,64px);line-height:1.05}#seo-content h2{margin-top:36px}#seo-content p{font-size:18px;line-height:1.65}</style></head>`)
    .replace('<body>', `<body>${renderContent(page)}`);
}

await mkdir(outputDirectory, { recursive: true });
await Promise.all(pages.map((page) =>
  writeFile(join(outputDirectory, `${page.slug}.html`), renderPage(page), 'utf8')
));

console.log(`Generated ${pages.length} crawlable SEO route shells.`);
