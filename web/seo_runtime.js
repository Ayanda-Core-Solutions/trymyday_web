(function () {
  const origin = 'https://trymyday.co.za';
  const routes = {
    '/': {
      title: 'TryMyDay | Career Guidance from Experienced Professionals',
      description: 'Connect with experienced professionals for honest career advice, free coffee chats, and focused one-on-one sessions.'
    },
    '/about': {
      title: 'About TryMyDay | Real, Practical Career Guidance',
      description: 'Learn how TryMyDay makes career guidance more human by connecting students, graduates, and career switchers with experienced professionals.'
    },
    '/faq': {
      title: 'TryMyDay FAQs | Coffee Chats, Bookings and Sessions',
      description: 'Find answers about free coffee chats, paid career sessions, scheduling, professional rates, and repeat bookings on TryMyDay.'
    },
    '/professionals': {
      title: 'Become a TryMyDay Professional | Share Your Experience',
      description: 'Create a professional profile, offer free coffee chats or paid career sessions, set your availability, and help others make informed career choices.'
    },
    '/contact': {
      title: 'Contact TryMyDay | Career Guidance Support',
      description: 'Contact the TryMyDay team for help with career sessions, professional profiles, bookings, or general questions.'
    }
  };

  const privatePaths = ['/auth/magic', '/launch'];
  const path = window.location.pathname.replace(/\/$/, '') || '/';
  const page = routes[path] || (path.startsWith('/meet/') ? {
    title: 'Meet a Professional | TryMyDay',
    description: 'View this TryMyDay professional profile and discover their experience, career insights, and available conversation options.'
  } : null);
  const canonicalUrl = origin + path;

  function setMeta(selector, attribute, value) {
    const element = document.querySelector(selector);
    if (element) element.setAttribute(attribute, value);
  }

  if (page) {
    document.title = page.title;
    setMeta('meta[name="description"]', 'content', page.description);
    setMeta('meta[property="og:title"]', 'content', page.title);
    setMeta('meta[property="og:description"]', 'content', page.description);
    setMeta('meta[property="og:url"]', 'content', canonicalUrl);
    setMeta('meta[name="twitter:title"]', 'content', page.title);
    setMeta('meta[name="twitter:description"]', 'content', page.description);
    setMeta('link[rel="canonical"]', 'href', canonicalUrl);
  }

  if (privatePaths.some((privatePath) => path.startsWith(privatePath))) {
    setMeta('meta[name="robots"]', 'content', 'noindex,nofollow');
  }
})();
