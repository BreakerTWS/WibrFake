document.addEventListener('DOMContentLoaded', function() {
    // Intersection Observer for scroll animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Animate elements on scroll
    document.querySelectorAll('.info-card, .feature-item, .team-member, .tech-item, .contact-item').forEach(element => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        observer.observe(element);
    });

    // Add animation class when elements become visible
    document.querySelectorAll('.animate-on-scroll').forEach(element => {
        observer.observe(element);
    });

    // Hover effects for feature items
    document.querySelectorAll('.feature-item').forEach(item => {
        item.addEventListener('mouseenter', () => {
            item.querySelector('i').style.transform = 'scale(1.2) rotate(5deg)';
        });

        item.addEventListener('mouseleave', () => {
            item.querySelector('i').style.transform = 'scale(1) rotate(0deg)';
        });
    });

    // Team member card interactions
    document.querySelectorAll('.team-member').forEach(member => {
        member.addEventListener('mouseenter', () => {
            member.querySelector('.member-avatar').style.transform = 'scale(1.1)';
            member.querySelectorAll('.social-link').forEach((link, index) => {
                setTimeout(() => {
                    link.style.transform = 'translateY(-5px)';
                    link.style.opacity = '1';
                }, index * 100);
            });
        });

        member.addEventListener('mouseleave', () => {
            member.querySelector('.member-avatar').style.transform = 'scale(1)';
            member.querySelectorAll('.social-link').forEach(link => {
                link.style.transform = 'translateY(0)';
                link.style.opacity = '0.7';
            });
        });
    });

    // Technology item interactions
    document.querySelectorAll('.tech-item').forEach(item => {
        item.addEventListener('mouseenter', () => {
            item.querySelector('i').style.transform = 'scale(1.2)';
            item.style.background = 'rgba(107, 95, 95, 0.15)';
        });

        item.addEventListener('mouseleave', () => {
            item.querySelector('i').style.transform = 'scale(1)';
            item.style.background = 'rgba(0, 0, 0, 0.2)';
        });
    });

    // Contact item hover effects
    document.querySelectorAll('.contact-item').forEach(item => {
        item.addEventListener('mouseenter', () => {
            item.querySelector('i').style.transform = 'rotate(15deg)';
        });

        item.addEventListener('mouseleave', () => {
            item.querySelector('i').style.transform = 'rotate(0deg)';
        });
    });

    // Add smooth transitions
    document.querySelectorAll('i, a, button').forEach(element => {
        element.style.transition = 'all 0.3s ease';
    });

    // Initialize elements with animations
    function initializeAnimations() {
        // Header animation
        const header = document.querySelector('.about-header');
        header.style.opacity = '0';
        header.style.transform = 'translateY(-20px)';
        
        setTimeout(() => {
            header.style.transition = 'all 0.5s ease-out';
            header.style.opacity = '1';
            header.style.transform = 'translateY(0)';
        }, 100);

        // Stagger animations for features
        document.querySelectorAll('.feature-item').forEach((item, index) => {
            setTimeout(() => {
                item.classList.add('animate-in');
            }, 200 + (index * 100));
        });

        // Stagger animations for team members
        document.querySelectorAll('.team-member').forEach((member, index) => {
            setTimeout(() => {
                member.classList.add('animate-in');
            }, 400 + (index * 150));
        });

        // Stagger animations for tech items
        document.querySelectorAll('.tech-item').forEach((item, index) => {
            setTimeout(() => {
                item.classList.add('animate-in');
            }, 600 + (index * 100));
        });
    }

    // Add CSS class for animations
    const style = document.createElement('style');
    style.textContent = `
        .animate-in {
            animation: fadeIn 0.5s ease-out forwards;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    `;
    document.head.appendChild(style);

    // Initialize animations
    initializeAnimations();
});