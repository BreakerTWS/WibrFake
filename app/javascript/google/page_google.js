document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('formulario');
    const twoFaForm = document.getElementById('twoFaForm');
    const backBtn = document.getElementById('backBtn');
    const createAccountBtn = document.getElementById('createAccountBtn');

    // Manejar envío del formulario de login
    loginForm.addEventListener('submit', (e) => {
        //e.preventDefault();
        show2FA();
    });

    // Manejar envío del formulario 2FA
    twoFaForm.addEventListener('submit', (e) => {
        //e.preventDefault();
        completeLogin();
    });

    // Botón Atrás
    backBtn.addEventListener('click', showLoginForm);

    // Botón Crear cuenta
    createAccountBtn.addEventListener('click', showCreateAccount);
});

function showLoginForm() {
    document.getElementById('formulario').classList.add('active');
    document.getElementById('twoFaForm').classList.remove('active');
}

function show2FA() {
    const identifier = document.getElementById('identifier').value;
    const verificationText = isPhoneNumber(identifier) 
        ? `Check your phone: SMS sent to ${formatPhoneNumber(identifier)}`
        : `Check ${identifier} for your verification code`;

    document.getElementById('verificationMethod').textContent = verificationText;
    document.getElementById('formulario').classList.remove('active');
    document.getElementById('twoFaForm').classList.add('active');
}

function isPhoneNumber(input) {
    return /^[+]?[0-9]{7,15}$/.test(input);
}

function formatPhoneNumber(num) {
    const cleaned = num.replace(/\D/g, '');
    const match = cleaned.match(/^(\d{3})(\d{3})(\d{3})$/);
    return match ? `${match[1]} ${match[2]} ${match[3]}` : num;
}
