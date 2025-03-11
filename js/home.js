// JavaScript Corregido
function showSection(sectionId) {
    const sections = document.querySelectorAll('.main-section');
    
    sections.forEach(section => {
        if(section.id === sectionId) {
            section.style.display = 'block';
            setTimeout(() => section.classList.add('active'), 10);
        } else {
            section.classList.remove('active');
            setTimeout(() => {
                if(!section.classList.contains('active')) {
                    section.style.display = 'none';
                }
            }, 400);
        }
    });
}

function showSubsection(sectionId, subsectionId) {
    showSection(sectionId);
    setTimeout(() => {
        const element = document.getElementById(subsectionId);
        if(element) {
            element.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }, 500);
}

// Inicialización
document.addEventListener('DOMContentLoaded', () => {
    showSection('dashboard-section');
    
    // Manejar clics en el sidebar
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', (e) => {
            // Remover active de todos los items
            document.querySelectorAll('.sidebar li').forEach(li => {
                li.classList.remove('active');
            });
            
            // Marcar item activo
            let parentLi = e.target.closest('li');
            if(parentLi) parentLi.classList.add('active');
        });
    });
});
