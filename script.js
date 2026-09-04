document.addEventListener('DOMContentLoaded', () => {
  const header = document.querySelector('.site-header');
  const navToggle = document.querySelector('.mobile-toggle');
  const navMenu = document.querySelector('.nav-menu');
  const navLinks = document.querySelectorAll('.nav-link');
  const backToTop = document.querySelector('.back-to-top');
  const revealItems = document.querySelectorAll('.reveal');
  const yearNode = document.querySelector('[data-current-year]');
  const currentPage = document.body.dataset.page;

  if (yearNode) {
    yearNode.textContent = new Date().getFullYear();
  }

  const setHeaderState = () => {
    if (!header) return;
    header.classList.toggle('scrolled', window.scrollY > 20);
  };

  setHeaderState();
  window.addEventListener('scroll', setHeaderState, { passive: true });

  if (navToggle && navMenu) {
    navToggle.addEventListener('click', () => {
      const isOpen = navMenu.classList.toggle('open');
      navToggle.classList.toggle('active', isOpen);
      navToggle.setAttribute('aria-expanded', String(isOpen));
    });

    navLinks.forEach((link) => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('open');
        navToggle.classList.remove('active');
        navToggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  if (navLinks.length && currentPage) {
    navLinks.forEach((link) => {
      const href = link.getAttribute('href');
      if (!href) return;

      const pageMatch = href.includes(currentPage);
      if (pageMatch) {
        link.classList.add('active');
      }
    });
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.18 }
  );

  revealItems.forEach((item) => observer.observe(item));

  const toggleBackToTop = () => {
    if (!backToTop) return;
    backToTop.classList.toggle('visible', window.scrollY > 450);
  };

  toggleBackToTop();
  window.addEventListener('scroll', toggleBackToTop, { passive: true });

  if (backToTop) {
    backToTop.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  const filterButtons = document.querySelectorAll('.filter-btn');
  const portfolioCards = document.querySelectorAll('.portfolio-card');

  if (filterButtons.length && portfolioCards.length) {
    filterButtons.forEach((button) => {
      button.addEventListener('click', () => {
        const selected = button.dataset.filter;

        filterButtons.forEach((btn) => btn.classList.toggle('active', btn === button));

        portfolioCards.forEach((card) => {
          const matches = selected === 'all' || card.dataset.category === selected;
          card.classList.toggle('hidden-project', !matches);
        });
      });
    });
  }

  const contactForm = document.querySelector('#contactForm');

  if (contactForm) {
    contactForm.addEventListener('submit', (event) => {
      event.preventDefault();

      const form = event.currentTarget;
      const fields = {
        fullName: form.querySelector('#fullName'),
        email: form.querySelector('#emailAddress'),
        phone: form.querySelector('#phoneNumber'),
        company: form.querySelector('#companyName'),
        service: form.querySelector('#serviceNeeded'),
        budget: form.querySelector('#projectBudget'),
        message: form.querySelector('#message')
      };

      const messageBox = form.querySelector('.form-message');
      let hasError = false;

      Object.values(fields).forEach((field) => {
        const isMessage = field && field.id === 'message';
        field.classList.remove('error');

        if (!field || (!field.value.trim() && !isMessage)) {
          return;
        }

        if (field.id === 'fullName' && field.value.trim().length < 2) {
          field.classList.add('error');
          hasError = true;
        }

        if (field.id === 'emailAddress' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(field.value.trim())) {
          field.classList.add('error');
          hasError = true;
        }

        if (field.id === 'phoneNumber' && field.value.trim().length < 7) {
          field.classList.add('error');
          hasError = true;
        }

        if (field.id === 'message' && field.value.trim().length < 15) {
          field.classList.add('error');
          hasError = true;
        }
      });

      for (const key of ['fullName', 'emailAddress', 'phoneNumber', 'companyName', 'serviceNeeded', 'projectBudget', 'message']) {
        const field = form.querySelector(`#${key}`);
        if (!field) continue;

        if (!field.value.trim() && key !== 'projectBudget') {
          field.classList.add('error');
          hasError = true;
        }
      }

      if (hasError) {
        if (messageBox) {
          messageBox.textContent = 'Please complete the required fields correctly before submitting your enquiry.';
          messageBox.className = 'form-message error';
        }
        return;
      }

      if (messageBox) {
        messageBox.textContent = 'Thank you! Your enquiry has been prepared successfully. Connect this form to Formspree, EmailJS, or your preferred backend to send submissions.';
        messageBox.className = 'form-message success';
      }

      form.reset();
    });
  }
});
